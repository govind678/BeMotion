//==============================================================================
//
//  GestureControllerInterface.mm
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#include "GestureControllerInterface.h"
#include <stdio.h>
#include <iostream>


GestureControllerInterface::GestureControllerInterface()
{
    audioEngine     =   new AudioEngine();
}


GestureControllerInterface::~GestureControllerInterface()
{
    delete audioEngine;
}


void GestureControllerInterface::loadAudioFile(int sampleID, NSString *filepath)
{
    audioEngine->loadAudioFile(sampleID, String([filepath UTF8String]));
}

void GestureControllerInterface::setEffectParameter(int sampleID, int effectPosition, int parameterID, float value)
{
    audioEngine->setEffectParameter(sampleID, effectPosition, parameterID, value);
}

void GestureControllerInterface::setSampleParameter(int sampleID, int parameterID, float value)
{
    audioEngine->setSampleParameter(sampleID, parameterID, value);
}


void GestureControllerInterface::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    audioEngine->addAudioEffect(sampleID, effectPosition, effectID);
}


void GestureControllerInterface::removeAudioEffect(int sampleID, int effectPosition)
{
    audioEngine->removeAudioEffect(sampleID, effectPosition);
}

//void GestureControllerInterface::togglePlaybackRecordingFile(int sampleID, bool toggle)
//{
//    audioEngine->toggleRecordingPlaybackSample(sampleID, toggle);
//}


void GestureControllerInterface::setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle)
{
    audioEngine->setSampleGestureControlToggle(sampleID, parameterID, toggle);
}

void GestureControllerInterface::setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle)
{
    audioEngine->setEffectGestureControlToggle(sampleID, effectPosition, parameterID, toggle);
}



//==============================================================================
// Transport Controls
// Start/Stop Playback or Recording
//==============================================================================

void GestureControllerInterface::startPlayback(int sampleID)
{
    audioEngine->startPlayback(sampleID);
}


void GestureControllerInterface::stopPlayback(int sampleID)
{
    audioEngine->stopPlayback(sampleID);
}


void GestureControllerInterface::startRecording(int sampleID)
{
    audioEngine->startRecordingAudioSample(sampleID);
}


void GestureControllerInterface::stopRecording(int sampleID)
{
    audioEngine->stopRecordingAudioSample(sampleID);
}

void GestureControllerInterface::startRecordingOutput(int sampleID)
{
    audioEngine->startRecordingMaster(sampleID);
}

void GestureControllerInterface::stopRecordingOutput(int sampleID)
{
    audioEngine->stopRecordingMaster(sampleID);
}

void GestureControllerInterface::beat(int beatNo)
{
    audioEngine->beat(beatNo);
}

void GestureControllerInterface::setTempo(float newTempo)
{
    audioEngine->setTempo(newTempo);
}

void GestureControllerInterface::motionUpdate(float *motion)
{
    audioEngine->motionUpdate(motion);
}

void GestureControllerInterface::setCurrentPresetBank(int presetBank)
{
    audioEngine->setCurrentPresetBank(presetBank);
}
//==============================================================================
// Get Methods to update GUI
// Get Effect Type
//==============================================================================

int GestureControllerInterface::getEffectType(int sampleID, int effectPosition)
{
    return audioEngine->getEffectType(sampleID, effectPosition);
}

int GestureControllerInterface::getCurrentPresetBank()
{
    return audioEngine->getCurrentPresetBank();
}

//==============================================================================
// Get Methods to update GUI
// Get Parameter Value
//==============================================================================

float GestureControllerInterface::getEffectParameter(int sampleID, int effectPosition, int parameterID)
{
    float value = audioEngine->getEffectParameter(sampleID, effectPosition, parameterID);
    return value;
}

float GestureControllerInterface::getSampleParameter(int sampleID, int parameterID)
{
    return audioEngine->getSampleParameter(sampleID, parameterID);
}


bool GestureControllerInterface::getSampleGestureControlToggle(int sampleID, int parameterID)
{
    return audioEngine->getSampleGestureControlToggle(sampleID, parameterID);
}

bool GestureControllerInterface::getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID)
{
    return audioEngine->getEffectGestureControlToggle(sampleID, effectPosition, parameterID);
}

