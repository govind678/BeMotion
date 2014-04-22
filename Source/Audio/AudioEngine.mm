//==============================================================================
//
//  AudioEngine.cpp
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#include "AudioEngine.h"




AudioEngine::AudioEngine()
{
    sharedAudioDeviceManager.initialise(NUM_INPUT_CHANNELS, NUM_OUTPUT_CHANNELS, 0, true, String::empty, 0);
    
    m_bLiveAudioThreadRunning   =   false;
    
    audioFileRecorder   =   new AudioFileRecord(sharedAudioDeviceManager);
    audioMixer          =   new AudioMixerPlayer(sharedAudioDeviceManager);
//    liveAudioStream     =   new AudioStream();
    
    
    currentRecordingPath        = File::getSpecialLocation(File::userDocumentsDirectory).getFullPathName() + "/Recording";
    currentPlaybackPath         = File::getSpecialLocation(File::userDocumentsDirectory).getFullPathName() + "/Playback";
    
    recordingFilePathArray.clear();
    playbackFilePathArray.clear();

    
    
    
    for (int i = 0; i < NUM_SAMPLE_SOURCES; i++)
    {
        recordingFilePathArray.add(currentRecordingPath + String(i) + ".wav");
        playbackFilePathArray.add(currentPlaybackPath + String(i) + ".wav");
    }
}



AudioEngine::~AudioEngine()
{
    recordingFilePathArray.clear();
    playbackFilePathArray.clear();
    
    audioFileRecorder           =   nullptr;
    audioMixer                  =   nullptr;
//    liveAudioStream             =   nullptr;
}



void AudioEngine::startLiveAudioStreaming()
{
    m_bLiveAudioThreadRunning   =   true;
//    sharedAudioDeviceManager->addAudioCallback(liveAudioStream);
}


void AudioEngine::stopLiveAudioStreaming()
{
    m_bLiveAudioThreadRunning   =   false;
//    sharedAudioDeviceManager->removeAudioCallback(liveAudioStream);
}



void AudioEngine::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    audioMixer->addAudioEffect(sampleID, effectPosition, effectID);
}



void AudioEngine::removeAudioEffect(int sampleID, int effectPosition)
{
    audioMixer->removeAudioEffect(sampleID, effectPosition);
}


bool AudioEngine::isLiveAudioRunning()
{
    return m_bLiveAudioThreadRunning;
}




void AudioEngine::loadAudioFile(int sampleID, String filePath)
{
    audioMixer->loadAudioFile(sampleID, filePath);
    playbackFilePathArray.set(sampleID, filePath);
}


void AudioEngine::toggleRecordingPlaybackSample(int sampleID, bool toggle)
{
    if (toggle)
    {
        audioMixer->loadAudioFile(sampleID, recordingFilePathArray.getReference(sampleID));
    }
    
    else
    {
        audioMixer->loadAudioFile(sampleID, playbackFilePathArray.getReference(sampleID));
    }
}



void AudioEngine::setEffectParameter(int sampleID, int effectPosition, int parameterID, float value)
{
    // TODO: Implement Parameter Smoothing
    audioMixer->setEffectParameter(sampleID, effectPosition, parameterID, value);
}


void AudioEngine::setSampleParameter(int sampleID, int parameterID, float value)
{
    // TODO: Implement Parameter Smoothing
    audioMixer->setSampleParameter(sampleID, parameterID, value);
}



float AudioEngine::getParameter(int sampleID, int effectPosition, int parameterID)
{
    return audioMixer->getParameter(sampleID, effectPosition, parameterID);
}


int AudioEngine::getEffectType(int sampleID, int effectPosition)
{
    return audioMixer->getEffectType(sampleID, effectPosition);
}


void AudioEngine::startRecordingAudioSample(int sampleID)
{
    audioMixer->stopPlayback(sampleID);
    audioFileRecorder->startRecording(recordingFilePathArray.getReference(sampleID), true);
}


void AudioEngine::stopRecordingAudioSample(int sampleID)
{
    audioFileRecorder->stopRecording();
    audioMixer->loadAudioFile(sampleID, recordingFilePathArray.getReference(sampleID));
}


void AudioEngine::startRecordingMaster(int sampleID)
{
    audioMixer->startRecordingOutput(recordingFilePathArray.getReference(sampleID));
}

void AudioEngine::stopRecordingMaster(int sampleID)
{
    audioMixer->stopRecordingOutput();
    audioMixer->loadAudioFile(sampleID, recordingFilePathArray.getReference(sampleID));
}


void AudioEngine::startPlayback(int sampleID)
{
    audioMixer->startPlayback(sampleID);
}


void AudioEngine::stopPlayback(int sampleID)
{
    audioMixer->stopPlayback(sampleID);
}

void AudioEngine::setButtonMode(int sampleID, int mode)
{
    audioMixer->setButtonMode(sampleID, mode);
}

int AudioEngine::getButtonMode(int sampleID)
{
    return audioMixer->getButtonMode(sampleID);
}


void AudioEngine::beat(int beatNo)
{
    audioMixer->beat(beatNo);
}

