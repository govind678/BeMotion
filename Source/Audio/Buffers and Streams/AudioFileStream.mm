//==============================================================================
//
//  AudioFileStream.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================

#include "AudioFileStream.h"


AudioFileStream::AudioFileStream(int sampleID, AudioDeviceManager& sharedDeviceManager)    :    deviceManager(sharedDeviceManager),
                                                                                                thread("Sample Playback No. " + String(sampleID))
{
    
    m_iSampleID =   sampleID;
    m_bAudioCurrentlyPlaying    =   false;
    
    m_iButtonMode               =   MODE_LOOP;
    m_iQuantization             =   QUANTIZATION_LEVELS - 1;
    m_iBeat                     =   0;
    m_fGain                     =   1.0f;
    
    transportSource.setSource(nullptr);
    formatManager.registerBasicFormats();
    audioEffectSource.clear(true);
    m_pbBypassStateArray.clear();
    audioEffectInitialized.clear();
    m_pbGestureControl.clear();
    m_pcParameter.clear();
    
    for (int effectNo = 0; effectNo < MIN_NUM_EFFECTS; effectNo++)
    {
        audioEffectSource.add(nullptr);
        audioEffectInitialized.add(false);
        m_pbBypassStateArray.add(false);
    }
    
    
    for (int param = 0; param < NUM_SAMPLE_PARAMS; param++)
    {
        m_pbGestureControl.add(false);
        
        m_pcParameter.add(new Parameter());
        m_pcParameter.getUnchecked(param)->setSmoothingParameter(0.6f);
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
    m_pcParameter.clear();
    
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
        transportSource.setGain(GAIN_SCALE);
        
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
        if (effectPosition < (MIN_NUM_EFFECTS))
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
        m_fGain     =   value;
        transportSource.setGain((value * value) * GAIN_SCALE);
    }
    
    else if (parameterID == PARAM_QUANTIZATION)
    {
        m_iQuantization =  int(powf(2, int(QUANTIZATION_LEVELS - value - 1)));
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
        return m_fGain;
    }
    
    else if (parameterID == PARAM_QUANTIZATION)
    {
        return  (QUANTIZATION_LEVELS - log2f(m_iQuantization) - 1);
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
    if (audioEffectInitialized.getUnchecked(effectPosition))
    {
        audioEffectSource.getUnchecked(effectPosition)->setGestureControlToggle(parameterID, toggle);
    }
}


bool AudioFileStream::getSampleGestureControlToggle(int parameterID)
{
    return m_pbGestureControl.getUnchecked(parameterID);
}


bool AudioFileStream::getEffectGestureControlToggle(int effectPosition, int parameterID)
{
    if (audioEffectInitialized.getUnchecked(effectPosition))
    {
        return audioEffectSource.getUnchecked(effectPosition)->getGestureControlToggle(parameterID);
    }
    
    else
    {
       return false;
    }
}


float AudioFileStream::getCurrentPlaybackTime()
{
    if (m_bAudioCurrentlyPlaying)
    {
        return (transportSource.getCurrentPosition() / transportSource.getLengthInSeconds());
    }
    
    else
    {
        return 0.0f;
    }
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


void AudioFileStream::motionUpdate(float *motion)
{
    if (m_pbGestureControl.getUnchecked(PARAM_MOTION_GAIN))
    {
        transportSource.setGain(m_pcParameter.getUnchecked(PARAM_MOTION_GAIN)->process(motion[ATTITUDE_PITCH] * motion[ATTITUDE_PITCH]) * GAIN_SCALE);
    }
    
    
    if (m_pbGestureControl.getUnchecked(PARAM_MOTION_QUANT))
    {
        float smooth = m_pcParameter.getUnchecked(PARAM_MOTION_QUANT)->process(motion[ATTITUDE_ROLL]);
        
        if ((smooth >= 0.0f) && (smooth < 0.25f))
        {
            m_iQuantization = 8;
        }
        
        else if ((smooth >= 0.25f) && (smooth < 0.5f))
        {
            m_iQuantization = 4;
        }
        
        else if ((smooth >= 0.5f) && (smooth < 0.75f))
        {
            m_iQuantization = 2;
        }
        
        else if ((smooth >= 0.75f) && (smooth < 1.0f))
        {
            m_iQuantization = 1;
        }

    }
    
    
    for (int effect = 0; effect < MIN_NUM_EFFECTS ; effect++)
    {
        if (audioEffectInitialized.getUnchecked(effect))
        {
            audioEffectSource.getUnchecked(effect)->motionUpdate(motion);
        }
    }
}


void AudioFileStream::setTempo(float newTempo)
{
    for (int effect = 0; effect < MIN_NUM_EFFECTS ; effect++)
    {
        if (audioEffectInitialized.getUnchecked(effect))
        {
            audioEffectSource.getUnchecked(effect)->setTempo(newTempo);
        }
    }
}
