//==============================================================================
//
//  BeMotionInterface.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#include "BeMotionInterface.h"


BeMotionInterface::BeMotionInterface()
{
    audioEngine     =   new AudioEngine();
}


BeMotionInterface::~BeMotionInterface()
{
    delete audioEngine;
}


int BeMotionInterface::loadAudioFile(int sampleID, NSString *filepath)
{
    return (audioEngine->loadAudioFile(sampleID, String([filepath UTF8String])));
}

void BeMotionInterface::setEffectParameter(int sampleID, int effectPosition, int parameterID, float value)
{
    audioEngine->setEffectParameter(sampleID, effectPosition, parameterID, value);
}

void BeMotionInterface::setSampleParameter(int sampleID, int parameterID, float value)
{
    audioEngine->setSampleParameter(sampleID, parameterID, value);
}


void BeMotionInterface::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    audioEngine->addAudioEffect(sampleID, effectPosition, effectID);
}


void BeMotionInterface::removeAudioEffect(int sampleID, int effectPosition)
{
    audioEngine->removeAudioEffect(sampleID, effectPosition);
}

//void BeMotionInterface::togglePlaybackRecordingFile(int sampleID, bool toggle)
//{
//    audioEngine->toggleRecordingPlaybackSample(sampleID, toggle);
//}


void BeMotionInterface::setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle)
{
    audioEngine->setSampleGestureControlToggle(sampleID, parameterID, toggle);
}

void BeMotionInterface::setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle)
{
    audioEngine->setEffectGestureControlToggle(sampleID, effectPosition, parameterID, toggle);
}



//==============================================================================
// Transport Controls
// Start/Stop Playback or Recording
//==============================================================================

void BeMotionInterface::startPlayback(int sampleID)
{
    audioEngine->startPlayback(sampleID);
}


void BeMotionInterface::stopPlayback(int sampleID)
{
    audioEngine->stopPlayback(sampleID);
}


void BeMotionInterface::startRecording(int sampleID)
{
    audioEngine->startRecordingAudioSample(sampleID);
}


void BeMotionInterface::stopRecording(int sampleID)
{
    audioEngine->stopRecordingAudioSample(sampleID);
}

void BeMotionInterface::startRecordingOutput(int sampleID)
{
    audioEngine->startRecordingMaster(sampleID);
}

void BeMotionInterface::stopRecordingOutput(int sampleID)
{
    audioEngine->stopRecordingMaster(sampleID);
}

void BeMotionInterface::beat(int beatNo)
{
    audioEngine->beat(beatNo);
}

void BeMotionInterface::setTempo(float newTempo)
{
    audioEngine->setTempo(newTempo);
}

void BeMotionInterface::motionUpdate(float *motion)
{
    audioEngine->motionUpdate(motion);
}

void BeMotionInterface::setCurrentPresetBank(int presetBank)
{
    audioEngine->setCurrentPresetBank(presetBank);
}
//==============================================================================
// Get Methods to update GUI
// Get Effect Type
//==============================================================================

int BeMotionInterface::getEffectType(int sampleID, int effectPosition)
{
    return audioEngine->getEffectType(sampleID, effectPosition);
}

int BeMotionInterface::getCurrentPresetBank()
{
    return audioEngine->getCurrentPresetBank();
}

//==============================================================================
// Get Methods to update GUI
// Get Parameter Value
//==============================================================================

float BeMotionInterface::getEffectParameter(int sampleID, int effectPosition, int parameterID)
{
    float value = audioEngine->getEffectParameter(sampleID, effectPosition, parameterID);
    return value;
}

float BeMotionInterface::getSampleParameter(int sampleID, int parameterID)
{
    return audioEngine->getSampleParameter(sampleID, parameterID);
}


bool BeMotionInterface::getSampleGestureControlToggle(int sampleID, int parameterID)
{
    return audioEngine->getSampleGestureControlToggle(sampleID, parameterID);
}

bool BeMotionInterface::getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID)
{
    return audioEngine->getEffectGestureControlToggle(sampleID, effectPosition, parameterID);
}

float BeMotionInterface::getSampleCurrentPlaybackTime(int sampleID)
{
    return audioEngine->getSampleCurrentPlaybackTime(sampleID);
}

bool BeMotionInterface::getSamplePlaybackStatus(int sampleID)
{
    return audioEngine->getSamplePlaybackStatus(sampleID);
}

