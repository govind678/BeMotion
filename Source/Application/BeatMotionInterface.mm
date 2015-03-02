//==============================================================================
//
//  BeatMotionInterface.mm
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================



#include "BeatMotionInterface.h"


BeatMotionInterface::BeatMotionInterface()
{
    audioEngine     =   new AudioEngine();
    m_bSettingsToggle   =   false;
}


BeatMotionInterface::~BeatMotionInterface()
{
    delete audioEngine;
}


int BeatMotionInterface::loadAudioFile(int sampleID, NSString *filepath)
{
    return (audioEngine->loadAudioFile(sampleID, String([filepath UTF8String])));
}

void BeatMotionInterface::loadUserRecordedFile(int sampleID, int index)
{
    audioEngine->loadUserRecordedFile(sampleID, index);
}


void BeatMotionInterface::setEffectParameter(int sampleID, int effectPosition, int parameterID, float value)
{
    audioEngine->setEffectParameter(sampleID, effectPosition, parameterID, value);
}

void BeatMotionInterface::setSampleParameter(int sampleID, int parameterID, float value)
{
    audioEngine->setSampleParameter(sampleID, parameterID, value);
}


void BeatMotionInterface::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    audioEngine->addAudioEffect(sampleID, effectPosition, effectID);
}


void BeatMotionInterface::removeAudioEffect(int sampleID, int effectPosition)
{
    audioEngine->removeAudioEffect(sampleID, effectPosition);
}

//void BeatMotionInterface::togglePlaybackRecordingFile(int sampleID, bool toggle)
//{
//    audioEngine->toggleRecordingPlaybackSample(sampleID, toggle);
//}


void BeatMotionInterface::setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle)
{
    audioEngine->setSampleGestureControlToggle(sampleID, parameterID, toggle);
}

void BeatMotionInterface::setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle)
{
    audioEngine->setEffectGestureControlToggle(sampleID, effectPosition, parameterID, toggle);
}



//==============================================================================
// Transport Controls
// Start/Stop Playback or Recording
//==============================================================================

void BeatMotionInterface::startPlayback(int sampleID)
{
    audioEngine->startPlayback(sampleID);
}


void BeatMotionInterface::stopPlayback(int sampleID)
{
    audioEngine->stopPlayback(sampleID);
}


void BeatMotionInterface::startRecording(int sampleID)
{
    audioEngine->startRecordingAudioSample(sampleID);
}


void BeatMotionInterface::stopRecording(int sampleID)
{
    audioEngine->stopRecordingAudioSample(sampleID);
}

void BeatMotionInterface::startRecordingOutput()
{
    audioEngine->startRecordingMaster();
}

void BeatMotionInterface::stopRecordingOutput()
{
    audioEngine->stopRecordingMaster();
}

void BeatMotionInterface::saveCurrentRecording(NSString* filename)
{
    audioEngine->saveCurrentRecording(String([filename UTF8String]));
}



void BeatMotionInterface::motionUpdate(float *motion)
{
    audioEngine->motionUpdate(motion);
}

void BeatMotionInterface::setCurrentSampleBank(NSString* presetBank)
{
    audioEngine->setCurrentPresetBank(String([presetBank UTF8String]));
}


int BeatMotionInterface::loadFXPreset(NSString *filepath)
{
    return (audioEngine->loadFXPreset(String([filepath UTF8String])));
}

void BeatMotionInterface::setSettingsToggle(bool toggle)
{
    m_bSettingsToggle = toggle;
}



//==============================================================================
// Metronome Methods
//==============================================================================

void BeatMotionInterface::beat(int beatNo)
{
    audioEngine->beat(beatNo);
}

void BeatMotionInterface::setTempo(float newTempo)
{
    audioEngine->setTempo(newTempo);
}

void BeatMotionInterface::startMetronome()
{
    audioEngine->startMetronome();
}

void BeatMotionInterface::stopMetronome()
{
    audioEngine->stopMetronome();
}






//==============================================================================
// Get Methods to update GUI
// Get Effect Type
//==============================================================================

int BeatMotionInterface::getEffectType(int sampleID, int effectPosition)
{
    return audioEngine->getEffectType(sampleID, effectPosition);
}

NSString* BeatMotionInterface::getCurrentSampleBank()
{
    NSString* string = [NSString stringWithUTF8String:audioEngine->getCurrentPresetBank().toRawUTF8()];
    return string;
}

void BeatMotionInterface::setPlayheadPosition(int sampleID, float position)
{
    audioEngine->setPlayheadPosition(sampleID, position);
}

//==============================================================================
// Get Methods to update GUI
// Get Parameter Value
//==============================================================================

float BeatMotionInterface::getEffectParameter(int sampleID, int effectPosition, int parameterID)
{
    float value = audioEngine->getEffectParameter(sampleID, effectPosition, parameterID);
    return value;
}

float BeatMotionInterface::getSampleParameter(int sampleID, int parameterID)
{
    return audioEngine->getSampleParameter(sampleID, parameterID);
}


bool BeatMotionInterface::getSampleGestureControlToggle(int sampleID, int parameterID)
{
    return audioEngine->getSampleGestureControlToggle(sampleID, parameterID);
}

bool BeatMotionInterface::getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID)
{
    return audioEngine->getEffectGestureControlToggle(sampleID, effectPosition, parameterID);
}

float BeatMotionInterface::getSampleCurrentPlaybackTime(int sampleID)
{
    return audioEngine->getSampleCurrentPlaybackTime(sampleID);
}

bool BeatMotionInterface::getSamplePlaybackStatus(int sampleID)
{
    return audioEngine->getSamplePlaybackStatus(sampleID);
}

NSString* BeatMotionInterface::getCurrentFXPack()
{
    NSString* string = [NSString stringWithUTF8String:audioEngine->getCurrentFXPack().toRawUTF8()];
    return string;
}

bool BeatMotionInterface::getSettingsToggle()
{
    return m_bSettingsToggle;
}

float* BeatMotionInterface::getSamplesToDrawWaveform(int sampleID)
{
    return audioEngine->getSamplesToDrawWaveform(sampleID);
}

bool BeatMotionInterface::getMetronomeStatus()
{
    return audioEngine->getMetronomeStatus();
}

int BeatMotionInterface::getTempo()
{
    return audioEngine->getTempo();
}


int BeatMotionInterface::getNumberOfUserRecordings()
{
    return audioEngine->getNumberOfUserRecordings();
}


NSString* BeatMotionInterface::getUserRecordingFileName(int index)
{
    NSString* returnString = [NSString stringWithUTF8String:audioEngine->getUserRecordingFileName(index).toRawUTF8()];
    return returnString;
}




void BeatMotionInterface::setButtonPagePosition(int sampleID, int position)
{
    audioEngine->setButtonPagePosition(sampleID, position);
}

int BeatMotionInterface::getButtonPagePosition(int sampleID)
{
    return audioEngine->getButtonPagePosition(sampleID);
}


int BeatMotionInterface::getCurrentFXPackIndex()
{
    return audioEngine->getCurrentFXPackIndex();
}

int BeatMotionInterface::getCurrentSampleBankIndex()
{
    return audioEngine->getCurrentSampleBankIndex();
}
void BeatMotionInterface::setCurrentFXPackIndex(int index)
{
    audioEngine->setCurrentFXPackIndex(index);
}
void BeatMotionInterface::setCurrentSampleBankIndex(int index)
{
    audioEngine->setCurrentSampleBankIndex(index);
}


float BeatMotionInterface::getMotionParameter(int sampleID, int effectPosition, int parameterID)
{
    return audioEngine->getMotionParameter(sampleID, effectPosition, parameterID);
}