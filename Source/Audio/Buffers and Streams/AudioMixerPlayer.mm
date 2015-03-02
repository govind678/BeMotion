//==============================================================================
//
//  AudioMixerPlayer.mm
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/9/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================


#include "AudioMixerPlayer.h"

//#include <iostream>
//#include <stdio.h>


AudioMixerPlayer::AudioMixerPlayer(AudioDeviceManager& sharedDeviceManager)   :   deviceManager(sharedDeviceManager)
{
    audioFileStream.clear(true);
    
    for (int sampleNo = 0; sampleNo < NUM_SAMPLE_SOURCES; sampleNo++)
    {
        audioFileStream.add(new AudioFileStream(sampleNo));
        audioMixer.addInputSource(audioFileStream.getUnchecked(sampleNo), false);
    }
    
    
    audioSourcePlayer.setSource(&audioMixer);
    
    m_pcLimiter             = new CLimiter(2);
    m_pcAudioFileRecorder   = new AudioFileRecord(deviceManager);
    
    m_bRecording            = false;
    
    m_fTempo                =   DEFAULT_TEMPO;
    
    deviceManager.addAudioCallback(this);
}


AudioMixerPlayer::~AudioMixerPlayer()
{
    deviceManager.removeAudioCallback(this);
    
    m_pcLimiter             =   nullptr;
    m_pcAudioFileRecorder   =   nullptr;
    
    audioFileStream.clear(true);
    audioSourcePlayer.setSource(0);
    
    audioFileStream.clear();
    
    audioMixer.removeAllInputs();
}




int AudioMixerPlayer::loadAudioFile(int sampleID, String filePath)
{    
    return (audioFileStream.getUnchecked(sampleID)->loadAudioFile(filePath));
}



void AudioMixerPlayer::startPlayback(int sampleID)
{
    audioFileStream.getUnchecked(sampleID)->startPlayback();
}



void AudioMixerPlayer::stopPlayback(int sampleID)
{
    audioFileStream.getUnchecked(sampleID)->stopPlayback();
}

void AudioMixerPlayer::startRecordingOutput(String filePath)
{
    m_pcAudioFileRecorder->startRecording(filePath, false);
    m_bRecording    =   true;
    
}

void AudioMixerPlayer::stopRecordingOutput()
{
    m_pcAudioFileRecorder->stopRecording();
    m_bRecording    =   false;
}


void AudioMixerPlayer::setEffectParameter(int sampleID, int effectPosition, int parameterID, float value)
{
    audioFileStream.getUnchecked(sampleID)->setEffectParameter(effectPosition, parameterID, value);
}

void AudioMixerPlayer::setSampleParameter(int sampleID, int parameterID, float value)
{
    audioFileStream.getUnchecked(sampleID)->setSampleParameter(parameterID, value);
}


float AudioMixerPlayer::getEffectParameter(int sampleID, int effectPosition, int parameterID)
{
    return audioFileStream.getUnchecked(sampleID)->getEffectParameter(effectPosition, parameterID);
}

float AudioMixerPlayer::getSampleParameter(int sampleID, int parameterID)
{
    return audioFileStream.getUnchecked(sampleID)->getSampleParameter(parameterID);
}

int AudioMixerPlayer::getEffectType(int sampleID, int effectPosition)
{
    return audioFileStream.getUnchecked(sampleID)->getEffectType(effectPosition);
}


void AudioMixerPlayer::setSmoothing(int sampleID, int effectPosition, int parameterID, float smoothing)
{
    audioFileStream.getUnchecked(sampleID)->setSmoothing(effectPosition, parameterID, smoothing);
}



void AudioMixerPlayer::setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle)
{
    audioFileStream.getUnchecked(sampleID)->setSampleGestureControlToggle(parameterID, toggle);
}

void AudioMixerPlayer::setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle)
{
    audioFileStream.getUnchecked(sampleID)->setEffectGestureControlToggle(effectPosition, parameterID, toggle);
}


bool AudioMixerPlayer::getSampleGestureControlToggle(int sampleID, int parameterID)
{
    return audioFileStream.getUnchecked(sampleID)->getSampleGestureControlToggle(parameterID);
}

bool AudioMixerPlayer::getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID)
{
    return audioFileStream.getUnchecked(sampleID)->getEffectGestureControlToggle(effectPosition, parameterID);
}


//--- Metronome ---//

void AudioMixerPlayer::beat(int beatNo)
{
//    for (int i=0; i < NUM_SAMPLE_SOURCES - 1; i++)
//    {
//        if (buttonModes.getUnchecked(i) == BeatRepeat)
//        {
//            if (buttonStates.getUnchecked(i))
//            {
//                audioFileStream.getUnchecked(i)->startPlayback();
//            }
//        }
//    }
//
    for (int i=0; i < NUM_SAMPLE_SOURCES - 2; i++)
    {
        audioFileStream.getUnchecked(i)->beat(beatNo);
    }
}




//==============================================================================
// Add and Remove Audio Effect
// Will pause playback for an instant and restart
//==============================================================================

void AudioMixerPlayer::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    deviceManager.removeAudioCallback(this);
    audioFileStream.getUnchecked(sampleID)->addAudioEffect(effectPosition, effectID);
    audioFileStream.getUnchecked(sampleID)->setTempo(m_fTempo);
    deviceManager.addAudioCallback(this);
}


void AudioMixerPlayer::removeAudioEffect(int sampleID, int effectPosition)
{
    deviceManager.removeAudioCallback(this);
    audioFileStream.getUnchecked(sampleID)->removeAudioEffect(effectPosition);
    deviceManager.addAudioCallback(this);
}



void AudioMixerPlayer::setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState)
{
    audioFileStream.getUnchecked(sampleID)->setAudioEffectBypassState(effectPosition, bypassState);
}






//==============================================================================
// Device Callback Methods
// !!! Audio Thread
//==============================================================================

void AudioMixerPlayer::audioDeviceIOCallback(const float** inputChannelData,
                                              int totalNumInputChannels,
                                              float** outputChannelData,
                                              int totalNumOutputChannels,
                                              int numSamples)

{
	audioSourcePlayer.audioDeviceIOCallback (inputChannelData, totalNumInputChannels, outputChannelData, totalNumOutputChannels, numSamples);
    
    
    if (m_bRecording)
    {
        for (int channel = 0; channel < totalNumOutputChannels; channel++)
        {
            FloatVectorOperations::multiply(outputChannelData[channel], 2.0f, numSamples);
        }
        
        m_pcAudioFileRecorder->writeBuffer(outputChannelData, numSamples);
        
        
        for (int channel = 0; channel < totalNumOutputChannels; channel++)
        {
            FloatVectorOperations::multiply(outputChannelData[channel], 0.5f, numSamples);
        }
    }
    
    m_pcLimiter->process(outputChannelData, numSamples);
    
//    std::cout << m_cTime.getCurrentTime().toMilliseconds() << std::endl;
//    std::cout << numSamples << std::endl;
}


void AudioMixerPlayer::audioDeviceAboutToStart (AudioIODevice* device)
{
	audioSourcePlayer.audioDeviceAboutToStart (device);
    m_pcAudioFileRecorder->audioDeviceAboutToStart(device);
    m_pcLimiter->prepareToPlay(device->getCurrentSampleRate());
}


void AudioMixerPlayer::audioDeviceStopped()
{
	audioSourcePlayer.audioDeviceStopped();
    m_pcAudioFileRecorder->audioDeviceStopped();
}


void AudioMixerPlayer::motionUpdate(float *motion)
{
    for (int i = 0; i < NUM_SAMPLE_SOURCES - 2; i++)
    {
        audioFileStream.getUnchecked(i)->motionUpdate(motion);
    }
}



//--- Metronome ---//

void AudioMixerPlayer::setTempo(float newTempo)
{
    m_fTempo = newTempo;
    for (int i = 0; i < NUM_SAMPLE_SOURCES - 2; i++)
    {
        audioFileStream.getUnchecked(i)->setTempo(newTempo);
    }
}

float AudioMixerPlayer::getTempo()
{
    return m_fTempo;
}

void AudioMixerPlayer::startClock()
{
    for (int i = 0; i < NUM_SAMPLE_SOURCES - 2; i++)
    {
        audioFileStream.getUnchecked(i)->startClock();
    }
}

void AudioMixerPlayer::stopClock()
{
    for (int i = 0; i < NUM_SAMPLE_SOURCES - 2; i++)
    {
        audioFileStream.getUnchecked(i)->stopClock();
    }
}





float AudioMixerPlayer::getSampleCurrentPlaybackTime(int sampleID)
{
    return audioFileStream.getUnchecked(sampleID)->getCurrentPlaybackTime();
}

bool AudioMixerPlayer::getSamplePlaybackStatus(int sampleID)
{
    return audioFileStream.getUnchecked(sampleID)->isPlaying();
}

float* AudioMixerPlayer::getSamplesToDrawWaveform(int sampleID)
{
    return audioFileStream.getUnchecked(sampleID)->getSamplesToDrawWaveform();
}


float AudioMixerPlayer::getMotionParameter(int sampleID, int effectPosition, int parameterID)
{
    return audioFileStream.getUnchecked(sampleID)->getMotionParameter(effectPosition, parameterID);
}


void AudioMixerPlayer::setPlayheadPosition(int sampleID, float position)
{
    audioFileStream.getUnchecked(sampleID)->setPlayheadPosition(position);
}
