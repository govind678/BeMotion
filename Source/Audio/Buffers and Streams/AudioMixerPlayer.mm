//==============================================================================
//
//  AudioMixerPlayer.cpp
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#include "AudioMixerPlayer.h"


AudioMixerPlayer::AudioMixerPlayer(AudioDeviceManager& sharedDeviceManager)   :   deviceManager(sharedDeviceManager)
{
    audioFileStream.clear(true);
    buttonModes.clear();
    buttonStates.clear();
    
    
    for (int sampleNo = 0; sampleNo < NUM_SAMPLE_SOURCES;   sampleNo++)
    {
        audioFileStream.add(new AudioFileStream(sampleNo, deviceManager));
        buttonModes.add(Loop);
        buttonStates.add(false);
    }
    buttonModes.set(NUM_SAMPLE_SOURCES - 1, Trigger);
    
    
    // TODO: Debug Remove
    buttonModes.set(2, BeatRepeat);
    
    
    
    audioSourcePlayer.setSource(&audioMixer);
    
    deviceManager.addAudioCallback(this);
}


AudioMixerPlayer::~AudioMixerPlayer()
{
    deviceManager.removeAudioCallback(this);
    buttonModes.clear();
    audioFileStream.clear(true);
    audioSourcePlayer.setSource(0);
    
    audioFileStream.clear();
    
    audioMixer.removeAllInputs();
}




void AudioMixerPlayer::loadAudioFile(int sampleID, String filePath)
{
    if (audioFileStream.getUnchecked(sampleID) != nullptr)
    {
        audioMixer.removeInputSource(audioFileStream.getUnchecked(sampleID));
    }
    
    audioFileStream.getUnchecked(sampleID)->loadAudioFile(filePath);
    audioMixer.addInputSource(audioFileStream.getUnchecked(sampleID), true);
}



void AudioMixerPlayer::startPlayback(int sampleID)
{
    if (buttonModes.getUnchecked(sampleID) != BeatRepeat)
    {
        audioFileStream.getUnchecked(sampleID)->startPlayback();
    }
    
    buttonStates.set(sampleID, true);
    
}



void AudioMixerPlayer::stopPlayback(int sampleID)
{
    audioFileStream.getUnchecked(sampleID)->stopPlayback();
    buttonStates.set(sampleID, false);
}


void AudioMixerPlayer::setParameter(int sampleID, int effectPosition, int parameterID, float value)
{
    audioFileStream.getUnchecked(sampleID)->setParameter(effectPosition, parameterID, value);
}


float AudioMixerPlayer::getParameter(int sampleID, int effectPosition, int parameterID)
{
    return audioFileStream.getUnchecked(sampleID)->getParameter(effectPosition, parameterID);
}

int AudioMixerPlayer::getEffectType(int sampleID, int effectPosition)
{
    return audioFileStream.getUnchecked(sampleID)->getEffectType(effectPosition);
}


void AudioMixerPlayer::setSmoothing(int sampleID, int effectPosition, int parameterID, float smoothing)
{
    audioFileStream.getUnchecked(sampleID)->setSmoothing(effectPosition, parameterID, smoothing);
}


void AudioMixerPlayer::setButtonMode(int sampleID, ButtonMode mode)
{
    audioFileStream.getUnchecked(sampleID)->setMode(mode);
}

ButtonMode AudioMixerPlayer::getButtonMode(int sampleID)
{
    return audioFileStream.getUnchecked(sampleID)->getMode();
}



void AudioMixerPlayer::beat(int beatNo)
{
    for (int i=0; i < NUM_SAMPLE_SOURCES - 1; i++)
    {
        if (buttonModes.getUnchecked(i) == BeatRepeat)
        {
            if (buttonStates.getUnchecked(i))
            {
                audioFileStream.getUnchecked(i)->startPlayback();
            }
        }
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
}


void AudioMixerPlayer::audioDeviceAboutToStart (AudioIODevice* device)
{
	audioSourcePlayer.audioDeviceAboutToStart (device);
}


void AudioMixerPlayer::audioDeviceStopped()
{
	audioSourcePlayer.audioDeviceStopped();
}