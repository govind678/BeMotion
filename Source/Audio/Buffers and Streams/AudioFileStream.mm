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
    
    m_iButtonMode               =   MODE_LOOP;
    m_iQuantization             =   1;
    m_iBeat                     =   1;
    
    transportSource.setSource(nullptr);
    formatManager.registerBasicFormats();
    audioEffectSource.clear(true);
    m_pbBypassStateArray.clear();
    audioEffectInitialized.clear();
    m_pbGestureControl.clear();
    
    for (int effectNo = 0; effectNo < MIN_NUM_EFFECTS; effectNo++)
    {
        audioEffectSource.add(nullptr);
        audioEffectInitialized.add(false);
        m_pbBypassStateArray.add(false);
    }
    
    
    for (int param = 0; param < 2; param++)
    {
        m_pbGestureControl.add(false);
    }
        

    m_pcLimiter = new CLimiter(2);
    
    thread.startThread(3);
}


AudioFileStream::~AudioFileStream()
{
    transportSource.setSource(nullptr);
    
    currentAudioFileSource  =   nullptr;
    
    audioEffectInitialized.clear();
    m_pbGestureControl.clear();
    
    audioEffectSource.clear(true);
    m_pbBypassStateArray.clear();
    
    m_pcLimiter     =   nullptr;

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
        
//        transportSource.setSource(currentAudioFileSource, 32768, &thread, deviceManager.getCurrentAudioDevice()->getCurrentSampleRate());
        transportSource.setSource(currentAudioFileSource, 32768, &thread, reader->sampleRate);
        transportSource.setGain(0.5);
        
        if (m_iSampleID != 4)
        {
            currentAudioFileSource->setLooping(true);
        }
    }
}



//==============================================================================
// Add and Remove Audio Effect
// Will pause playback for an instant and restart
//==============================================================================

void AudioFileStream::addAudioEffect(int effectPosition, int effectID)
{
    if (effectID == 0)
    {
        audioEffectSource.set(effectPosition, nullptr);
        audioEffectInitialized.set(effectPosition, false);
    }
    
    
    else
    {
        if (effectPosition < (MIN_NUM_EFFECTS - 1))
        {
            audioEffectSource.set(effectPosition, new AudioEffectSource(effectID, 2));
            audioEffectInitialized.set(effectPosition, true);
        }
        
        else
        {
            audioEffectSource.add(new AudioEffectSource(effectID, 2));
            audioEffectInitialized.add(true);
        }
    }
}


void AudioFileStream::removeAudioEffect(int effectPosition)
{
    audioEffectSource.set(effectPosition, nullptr);
    audioEffectInitialized.set(effectPosition, false);
}



void AudioFileStream::setAudioEffectBypassState(int effectPosition, bool bypassState)
{
    m_pbBypassStateArray.set(effectPosition, bypassState);
}



bool AudioFileStream::isPlaying()
{
    return m_bAudioCurrentlyPlaying;
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
            audioEffectSource.getUnchecked(effectNo)->audioDeviceAboutToStart(sampleRate);
        }
    }
    
    m_pcLimiter->prepareToPlay(sampleRate);
    
//    m_pcAutoLimiter->Setup(sampleRate);
}


void AudioFileStream::releaseResources()
{
    transportSource.releaseResources();
}


void AudioFileStream::getNextAudioBlock(const AudioSourceChannelInfo &audioSourceChannelInfo)
{
    transportSource.getNextAudioBlock(audioSourceChannelInfo);
    processAudioBlock(audioSourceChannelInfo.buffer->getArrayOfWritePointers(), audioSourceChannelInfo.numSamples);
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
    
    m_pcLimiter->process(audioBuffer, numSamples, false);
//    m_pcAutoLimiter->Process(numSamples, audioBuffer);
}





//==============================================================================
// Transport Control Methods
//==============================================================================

void AudioFileStream::startPlayback()
{
    m_bAudioCurrentlyPlaying    =   true;
    
    if (m_iButtonMode != MODE_BEATREPEAT)
    {
        transportSource.setPosition(0);
        transportSource.start();
    }
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

void AudioFileStream::setEffectParameter(int effectPosition, int parameterID, float value)
{
    if (parameterID == PARAM_BYPASS)
    {
        m_pbBypassStateArray.set(effectPosition, bool(value));
    }
    
    else
    {
        if (audioEffectInitialized.getUnchecked(effectPosition))
        {
            audioEffectSource.getUnchecked(effectPosition)->setParameter((parameterID), value);
        }
    }
}


void AudioFileStream::setSampleParameter(int parameterID, float value)
{
    if (parameterID == PARAM_GAIN)
    {
        transportSource.setGain(value * 0.5f);
    }
    
    else if (parameterID == PARAM_QUANTIZATION)
    {
        m_iQuantization = int(powf(2, int(MAX_QUANTIZATION - value + 0.5f)));
    }
    
    else if (parameterID == PARAM_PLAYBACK_MODE)
    {
        m_iButtonMode   =   int(value + 0.5f);
        
        if (m_iButtonMode != MODE_LOOP)
        {
            setLooping(false);
        }
        
        else
        {
            setLooping(true);
        }
    }
}



float AudioFileStream::getEffectParameter(int effectPosition, int parameterID)
{
    if (parameterID == PARAM_BYPASS)
    {
        return m_pbBypassStateArray.getUnchecked(effectPosition);
    }
    
    else
    {
        if (audioEffectInitialized.getUnchecked(effectPosition))
        {
            return audioEffectSource.getUnchecked(effectPosition)->getParameter(parameterID);
        }
        
        else
        {
            return 0.0f;
        }
        
    }
}


float AudioFileStream::getSampleParameter(int parameterID)
{
    if (parameterID == PARAM_GAIN)
    {
        return transportSource.getGain();
    }
    
    else if (parameterID == PARAM_QUANTIZATION)
    {
        return int(log2f(m_iQuantization + MAX_QUANTIZATION) + 0.5f);
    }
    
    else if (parameterID == PARAM_PLAYBACK_MODE)
    {
        return m_iButtonMode;
    }
    
    else
    {
        return 0.0f;
    }
}


void AudioFileStream::setSmoothing(int effectPosition, int parameterID, float smoothing)
{
    audioEffectSource.getUnchecked(effectPosition)->setSmoothing(parameterID, smoothing);
}

int AudioFileStream::getEffectType(int effectPosition)
{
    if (audioEffectInitialized.getUnchecked(effectPosition))
    {
        return audioEffectSource.getUnchecked(effectPosition)->getEffectType();
    }
    
    else
    {
        return EFFECT_NONE;
    }
    
}



void AudioFileStream::setSampleGestureControlToggle(int parameterID, bool toggle)
{
    m_pbGestureControl.set(parameterID, toggle);
}

void AudioFileStream::setEffectGestureControlToggle(int effectPosition, int parameterID, bool toggle)
{
    audioEffectSource.getUnchecked(effectPosition)->setGestureControlToggle(parameterID, toggle);
}


bool AudioFileStream::getSampleGestureControlToggle(int parameterID)
{
    return m_pbGestureControl.getUnchecked(parameterID);
}


bool AudioFileStream::getEffectGestureControlToggle(int effectPosition, int parameterID)
{
    return audioEffectSource.getUnchecked(effectPosition)->getGestureControlToggle(parameterID);
}



void AudioFileStream::beat(int beatNum)
{
    m_iBeat = beatNum % m_iQuantization;
    
    if (m_iButtonMode == MODE_BEATREPEAT)
    {
        if (m_bAudioCurrentlyPlaying)
        {
            if (m_iBeat == 0)
            {
                transportSource.setPosition(0);
                transportSource.start();
            }
        }
    }
}
