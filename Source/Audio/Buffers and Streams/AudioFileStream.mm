//==============================================================================
//
//  AudioFileStream.cpp
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================

#include "AudioFileStream.h"


AudioFileStream::AudioFileStream(int sampleID, AudioDeviceManager& sharedDeviceManager)    :    deviceManager(sharedDeviceManager),
                                                                                                thread("Sample Playback No. " + String(sampleID))
{
    
    m_iSampleID =   sampleID;
    m_bAudioCurrentlyPlaying    =   false;
    
    transportSource.setSource(nullptr);
    formatManager.registerBasicFormats();
    audioEffectSource.clear(true);
    m_pbBypassStateArray.clear();
    
    for (int effectNo = 0; effectNo < MIN_NUM_EFFECTS; effectNo++)
    {
        audioEffectSource.add(nullptr);
    }
    
    thread.startThread(3);
}


AudioFileStream::~AudioFileStream()
{
    transportSource.setSource(nullptr);
    
    currentAudioFileSource  =   nullptr;
    
    audioEffectSource.clear(true);
    m_pbBypassStateArray.clear();

    thread.stopThread(20);
}



void AudioFileStream::loadAudioFile(String audioFilePath)
{
    m_sCurrentFilePath  =   audioFilePath;
    
    transportSource.stop();
    transportSource.setSource(nullptr);
    
    currentAudioFileSource  =   nullptr;
    
    AudioFormatReader* reader = formatManager.createReaderFor(File(m_sCurrentFilePath));
    
    
    if (reader != nullptr)
    {
        currentAudioFileSource = new AudioFormatReaderSource (reader, true);
        currentAudioFileSource->setLooping(true);
        transportSource.setSource(currentAudioFileSource, 32768, &thread, deviceManager.getCurrentAudioDevice()->getCurrentSampleRate());
    }
}



//==============================================================================
// Add and Remove Audio Effect
// Will pause playback for an instant and restart
//==============================================================================

void AudioFileStream::addAudioEffect(int effectPosition, int effectID)
{
    if (effectPosition < (MIN_NUM_EFFECTS - 1))
    {
        audioEffectSource.set(effectPosition, new AudioEffectSource(effectID, 2));
    }
    
    else
    {
        audioEffectSource.add(new AudioEffectSource(effectID, 2));
    }
}


void AudioFileStream::removeAudioEffect(int effectPosition)
{
    audioEffectSource.set(effectPosition, nullptr);
}



void AudioFileStream::setAudioEffectBypassState(int effectPosition, bool bypassState)
{
    m_pbBypassStateArray.set(effectPosition, bypassState);
}





//==============================================================================
// Process Functions - Audio Source Callbacks
// !!! Audio Thread
//==============================================================================

void AudioFileStream::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    transportSource.prepareToPlay(samplesPerBlockExpected, sampleRate);
    
    for (int effectNo = 0; effectNo < audioEffectSource.size(); effectNo++)
    {
        if (audioEffectSource.getUnchecked(effectNo) != nullptr)
        {
            audioEffectSource.getUnchecked(effectNo)->audioDeviceAboutToStart(float(deviceManager.getCurrentAudioDevice()->getCurrentSampleRate()));
        }
    }
}


void AudioFileStream::releaseResources()
{
    transportSource.releaseResources();
}


void AudioFileStream::getNextAudioBlock(const AudioSourceChannelInfo &audioSourceChannelInfo)
{
    transportSource.getNextAudioBlock(audioSourceChannelInfo);
    processAudioBlock(audioSourceChannelInfo.buffer->getArrayOfChannels(), audioSourceChannelInfo.numSamples);
}



void AudioFileStream::processAudioBlock(float **audioBuffer, int numSamples)
{
    if (audioEffectSource.size() > 0)
    {
        for (int effectNo = 0; effectNo < audioEffectSource.size(); effectNo++)
        {
            if (audioEffectSource.getUnchecked(effectNo) != nullptr)
            {
                audioEffectSource.getUnchecked(effectNo)->process(audioBuffer,
                                                                  numSamples,
                                                                  m_pbBypassStateArray[effectNo]);
            }
        }
        
    }
}





//==============================================================================
// Transport Control Methods
//==============================================================================

void AudioFileStream::startPlayback()
{
    m_bAudioCurrentlyPlaying    =   true;
    transportSource.setPosition(0);
    transportSource.start();
}

void AudioFileStream::stopPlayback()
{
    m_bAudioCurrentlyPlaying    =   false;
    transportSource.stop();
}


void AudioFileStream::setLooping(bool looping)
{
    currentAudioFileSource->setLooping(looping);
}




//==============================================================================
// Set and Get Audio Effect Parameters
//==============================================================================

void AudioFileStream::setParameter(int effectPosition, int parameterID, float value)
{
    if (parameterID == PARAM_BYPASS)
    {
        m_pbBypassStateArray.set(effectPosition, bool(value));
    }
    
    else if (parameterID == PARAM_GAIN)
    {
        transportSource.setGain(value);
    }
    
    else
    {
        audioEffectSource.getUnchecked(effectPosition)->setParameter((parameterID - 2), value);
    }
}



float AudioFileStream::getParameter(int effectPosition, int parameterID)
{
    if (parameterID == PARAM_BYPASS)
    {
        return m_pbBypassStateArray.getUnchecked(effectPosition);
    }
    
    else if (parameterID == PARAM_GAIN)
    {
        return transportSource.getGain();
    }
    
    else
    {
        return audioEffectSource.getUnchecked(effectPosition)->getParameter(parameterID - 2);
    }
}


int AudioFileStream::getEffectType(int effectPosition)
{
    return audioEffectSource.getUnchecked(effectPosition)->getEffectType();
}
