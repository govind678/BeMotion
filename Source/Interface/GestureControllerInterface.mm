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


void GestureControllerInterface::setMode(int sampleID, int mode)
{
    audioEngine->setButtonMode(sampleID, mode);
}

void GestureControllerInterface::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    audioEngine->addAudioEffect(sampleID, effectPosition, effectID);
}


void GestureControllerInterface::removeAudioEffect(int sampleID, int effectPosition)
{
    audioEngine->removeAudioEffect(sampleID, effectPosition);
}

void GestureControllerInterface::togglePlaybackRecordingFile(int sampleID, bool toggle)
{
    audioEngine->toggleRecordingPlaybackSample(sampleID, toggle);
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


//==============================================================================
// Get Methods to update GUI
// Get Effect Type
//==============================================================================

int GestureControllerInterface::getEffectType(int sampleID, int effectPosition)
{
    return audioEngine->getEffectType(sampleID, effectPosition);
}



//==============================================================================
// Get Methods to update GUI
// Get Parameter Value
//==============================================================================

float GestureControllerInterface::getParameter(int sampleID, int effectPosition, int parameterID)
{
    return audioEngine->getParameter(sampleID, effectPosition, parameterID);
}
