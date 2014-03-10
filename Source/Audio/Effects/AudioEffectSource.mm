//
//  AudioEffectSource.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioEffectSource.h"


AudioEffectSource::AudioEffectSource(int effectID, int numChannels)
{
    switch (effectID)
    {
        // Tremolo
        case 0:
        {
            tremoloEffect   =   new CTremolo(numChannels);
            break;
        }
          
        // Delay
        case 1:
        {
            delayEffect     =   new CDelay(numChannels);
            break;
        }
            
        
        default:
        {
            break;
        }
            
    }
    
    m_iEffectID  = effectID;
}


AudioEffectSource::~AudioEffectSource()
{
    delayEffect     =   nullptr;
    tremoloEffect   =   nullptr;
}


void AudioEffectSource::setParameter(int parameterID, float value)
{
    switch (m_iEffectID)
    {
        // Tremolo
        case 0:
            tremoloEffect->setParam(parameterID, value);
            break;
        
        
        // Delay
        case 1:
            delayEffect->setParam(parameterID, value);
            break;
           
            
        default:
            break;
    }
    
}



void AudioEffectSource::audioDeviceAboutToStart(float sampleRate)
{
    switch (m_iEffectID) {
        case 0:
            tremoloEffect->prepareToPlay(sampleRate);
            break;
            
        case 1:
            delayEffect->prepareToPlay(sampleRate);
            break;
            
        default:
            break;
    }
}



void AudioEffectSource::audioDeviceStopped()
{
    
}


void AudioEffectSource::process(float **audioBuffer, int blockSize, bool bypassState)
{
    switch (m_iEffectID)
    {
        // Tremolo
        case 0:
            tremoloEffect->process(audioBuffer, blockSize, bypassState);
            break;
           
        // Delay
        case 1:
            delayEffect->process(audioBuffer, blockSize, bypassState);
            break;
            
            
        default:
            break;
    }
}