//==============================================================================
//
//  AudioEngine.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================



#include "AudioEngine.h"


AudioEngine::AudioEngine()
{
    sharedAudioDeviceManager.initialise(NUM_INPUT_CHANNELS, NUM_OUTPUT_CHANNELS, 0, true, String::empty, 0);
    sharedAudioDeviceManager.getAudioDeviceSetup(deviceSetup);
    
    m_bLiveAudioThreadRunning   =   false;
    m_iCurrentPresetBankLoaded  =   PRESET_BANK_1;
    
    audioFileRecorder   =   new AudioFileRecord(sharedAudioDeviceManager);
    audioMixer          =   new AudioMixerPlayer(sharedAudioDeviceManager);
//    liveAudioStream     =   new AudioStream();
    
    
    currentRecordingPath1       = File::getSpecialLocation(File::userDocumentsDirectory).getFullPathName() + "/Recording1_";
    currentRecordingPath2       = File::getSpecialLocation(File::userDocumentsDirectory).getFullPathName() + "/Recording2_";
    currentPlaybackPath         = File::getSpecialLocation(File::userDocumentsDirectory).getFullPathName() + "/Playback";
    
    recordingFilePathArray1.clear();
    recordingFilePathArray2.clear();
    playbackFilePathArray.clear();
    
    m_pbRecordingToggle.clear();
    
    
    
    for (int i = 0; i < NUM_SAMPLE_SOURCES; i++)
    {
        recordingFilePathArray1.add(currentRecordingPath1 + String(i) + ".wav");
//        recordingFilePathArray1.add(currentRecordingPath1 + String(i) + ".flac");
        recordingFilePathArray2.add(currentRecordingPath2 + String(i) + ".wav");
//        recordingFilePathArray2.add(currentRecordingPath2 + String(i) + ".flac");
        playbackFilePathArray.add(currentPlaybackPath + String(i) + ".wav");
//        playbackFilePathArray.add(currentPlaybackPath + String(i) + ".flac");
        m_pbRecordingToggle.add(false);
    }
}



AudioEngine::~AudioEngine()
{
    recordingFilePathArray1.clear();
    recordingFilePathArray2.clear();
    playbackFilePathArray.clear();
    m_pbRecordingToggle.clear();
    
    audioFileRecorder           =   nullptr;
    audioMixer                  =   nullptr;
//    liveAudioStream             =   nullptr;
}


void AudioEngine::setCurrentPresetBank(int presetBank)
{
    m_iCurrentPresetBankLoaded = presetBank;
}

int  AudioEngine::getCurrentPresetBank()
{
    return m_iCurrentPresetBankLoaded;
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




int AudioEngine::loadAudioFile(int sampleID, String filePath)
{
    playbackFilePathArray.set(sampleID, filePath);
    return (audioMixer->loadAudioFile(sampleID, filePath));
}


void AudioEngine::toggleRecordingPlaybackSample(int sampleID, bool toggle)
{
    if (toggle)
    {
        audioMixer->loadAudioFile(sampleID, recordingFilePathArray1.getReference(sampleID));
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

float AudioEngine::getSampleParameter(int sampleID, int parameterID)
{
    return audioMixer->getSampleParameter(sampleID, parameterID);
}


float AudioEngine::getEffectParameter(int sampleID, int effectPosition, int parameterID)
{
    return audioMixer->getEffectParameter(sampleID, effectPosition, parameterID);
}


int AudioEngine::getEffectType(int sampleID, int effectPosition)
{
    return audioMixer->getEffectType(sampleID, effectPosition);
}


void AudioEngine::startRecordingAudioSample(int sampleID)
{
    audioMixer->stopPlayback(sampleID);
    audioFileRecorder->startRecording(recordingFilePathArray1.getReference(sampleID), true);
}


void AudioEngine::stopRecordingAudioSample(int sampleID)
{
    audioFileRecorder->stopRecording();
    audioMixer->loadAudioFile(sampleID, recordingFilePathArray1.getReference(sampleID));
}


void AudioEngine::startRecordingMaster(int sampleID)
{
    if (m_pbRecordingToggle.getUnchecked(sampleID))
    {
        audioMixer->startRecordingOutput(recordingFilePathArray2.getReference(sampleID));
        m_pbRecordingToggle.set(sampleID, false);
    }
    
    else
    {
        audioMixer->startRecordingOutput(recordingFilePathArray1.getReference(sampleID));
        m_pbRecordingToggle.set(sampleID, true);
    }
}


void AudioEngine::stopRecordingMaster(int sampleID)
{
    audioMixer->stopRecordingOutput();
    
    if (m_pbRecordingToggle.getUnchecked(sampleID))
    {
        audioMixer->loadAudioFile(sampleID, recordingFilePathArray1.getReference(sampleID));
    }
    
    else
    {
        audioMixer->loadAudioFile(sampleID, recordingFilePathArray2.getReference(sampleID));
    }
    
}


void AudioEngine::startPlayback(int sampleID)
{
    audioMixer->startPlayback(sampleID);
}


void AudioEngine::stopPlayback(int sampleID)
{
    audioMixer->stopPlayback(sampleID);
}



void AudioEngine::setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle)
{
    audioMixer->setSampleGestureControlToggle(sampleID, parameterID, toggle);
}

void AudioEngine::setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle)
{
    audioMixer->setEffectGestureControlToggle(sampleID, effectPosition, parameterID, toggle);
}


bool AudioEngine::getSampleGestureControlToggle(int sampleID, int parameterID)
{
    return audioMixer->getSampleGestureControlToggle(sampleID, parameterID);
}

bool AudioEngine::getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID)
{
    return audioMixer->getEffectGestureControlToggle(sampleID, effectPosition, parameterID);
}


float AudioEngine::getSampleCurrentPlaybackTime(int sampleID)
{
    return audioMixer->getSampleCurrentPlaybackTime(sampleID);
}

bool AudioEngine::getSamplePlaybackStatus(int sampleID)
{
    return audioMixer->getSamplePlaybackStatus(sampleID);
}


void AudioEngine::beat(int beatNo)
{
    audioMixer->beat(beatNo);
}


void AudioEngine::motionUpdate(float *motion)
{
    audioMixer->motionUpdate(motion);
}

void AudioEngine::setTempo(float newTempo)
{
    audioMixer->setTempo(newTempo);
}

