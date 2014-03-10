//==============================================================================
//
//  AudioEffectSource.cpp
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================

#include "AudioEffectSource.h"


AudioEffectSource::AudioEffectSource(int effectID, int numChannels)
{
    switch (effectID)
    {
        case EFFECT_TREMOLO:
        {
            tremoloEffect   =   new CTremolo(numChannels);
            break;
        }
          
        case EFFECT_DELAY:
        {
            delayEffect     =   new CDelay(numChannels);
            break;
        }
            
        case EFFECT_VIBRATO:
        {
            vibratoEffect   =   new CVibrato(numChannels);
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
    vibratoEffect   =   nullptr;
}


void AudioEffectSource::setParameter(int parameterID, float value)
{
    switch (m_iEffectID)
    {
        case EFFECT_TREMOLO:
            tremoloEffect->setParam(parameterID, value);
            break;
        
        case EFFECT_DELAY:
            delayEffect->setParam(parameterID, value);
            break;
           
        case EFFECT_VIBRATO:
            vibratoEffect->setParam(parameterID, value);
            break;
            
        default:
            break;
    }
    
}






float AudioEffectSource::getParameter(int parameterID)
{
    switch (m_iEffectID)
    {
        case EFFECT_TREMOLO:
            return tremoloEffect->getParam(parameterID);
            break;
            
        case EFFECT_DELAY:
            return delayEffect->getParam(parameterID);
            break;
            
        case EFFECT_VIBRATO:
            return vibratoEffect->getParam(parameterID);
            
        default:
            return 0.0f;
            break;
    }
}



int AudioEffectSource::getEffectType()
{
    return m_iEffectID;
}



void AudioEffectSource::audioDeviceAboutToStart(float sampleRate)
{
    switch (m_iEffectID)
    {
        
        case EFFECT_TREMOLO:
            tremoloEffect->prepareToPlay(sampleRate);
            break;
            
            
        case EFFECT_DELAY:
            delayEffect->prepareToPlay(sampleRate);
            break;
            
            
        case EFFECT_VIBRATO:
            vibratoEffect->prepareToPlay(sampleRate);
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
        
        case EFFECT_TREMOLO:
            tremoloEffect->process(audioBuffer, blockSize, bypassState);
            break;
           
            
        case EFFECT_DELAY:
            delayEffect->process(audioBuffer, blockSize, bypassState);
            break;
            
            
        case EFFECT_VIBRATO:
            vibratoEffect->process(audioBuffer, blockSize, bypassState);
            break;
            
        default:
            break;
    }
}