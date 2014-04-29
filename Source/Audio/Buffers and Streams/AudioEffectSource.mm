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
    m_pcTremolo         =   nullptr;
    m_pcDelay           =   nullptr;
    m_pcVibrato         =   nullptr;
    m_pcWah             =   nullptr;
    m_pcGranularizer    =   nullptr;
    
    
    m_pcParameter.clear();
    m_pbGestureControl.clear();
    
    for (int i=0; i < NUM_EFFECTS_PARAMS; i++)
    {
        m_pcParameter.add(new Parameter());
        m_pcParameter.getUnchecked(i)->setSmoothingParameter(0.5);
        
        m_pbGestureControl.add(false);
    }
    
    
    switch (effectID)
    {
        case EFFECT_TREMOLO:
        {
            m_pcTremolo         =   new CTremolo(numChannels);
            break;
        }
          
        case EFFECT_DELAY:
        {
            m_pcDelay           =   new CDelay(numChannels);
            break;
        }
            
        case EFFECT_VIBRATO:
        {
            m_pcVibrato         =   new CVibrato(numChannels);
            break;
        }
            
        case EFFECT_WAH:
        {
            m_pcWah             =   new CWah(numChannels);
            break;
        }
            
        
        case EFFECT_GRANULAR:
        {
            m_pcGranularizer    =   new CGranularizer(numChannels);
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
    m_pcTremolo         =   nullptr;
    m_pcDelay           =   nullptr;
    m_pcVibrato         =   nullptr;
    m_pcWah             =   nullptr;
    m_pcGranularizer    =   nullptr;

    m_pcParameter.clear();
    m_pbGestureControl.clear();
}


void AudioEffectSource::setSmoothing(int parameterID, float smoothing)
{
    m_pcParameter.getUnchecked(parameterID - 4)->setSmoothingParameter(smoothing);
}



void AudioEffectSource::setParameter(int parameterID, float value)
{
    switch (m_iEffectID)
    {
        case EFFECT_TREMOLO:
            m_pcTremolo->setParam(parameterID, m_pcParameter.getUnchecked(parameterID - 1)->process(value));
            break;
        
        case EFFECT_DELAY:
            m_pcDelay->setParam(parameterID, m_pcParameter.getUnchecked(parameterID - 1)->process(value));
            break;
           
        case EFFECT_VIBRATO:
            m_pcVibrato->setParam(parameterID, m_pcParameter.getUnchecked(parameterID - 1)->process(value));
            break;
            
        case EFFECT_WAH:
            m_pcWah->setParam(parameterID, m_pcParameter.getUnchecked(parameterID - 1)->process(value));
            break;
            
        case EFFECT_GRANULAR:
            m_pcGranularizer->setParam(parameterID, m_pcParameter.getUnchecked(parameterID - 1)->process(value));
            break;
            
        default:
            break;
    }
    
}


void AudioEffectSource::setGestureControlToggle(int parameterID, bool toggle)
{
    m_pbGestureControl.set(parameterID, toggle);
}

bool AudioEffectSource::getGestureControlToggle(int parameterID)
{
    return m_pbGestureControl.getUnchecked(parameterID);
}




float AudioEffectSource::getParameter(int parameterID)
{
    switch (m_iEffectID)
    {
        case EFFECT_TREMOLO:
            return m_pcTremolo->getParam(parameterID - 1);
            break;
            
        case EFFECT_DELAY:
            return m_pcDelay->getParam(parameterID - 1);
            break;
            
        case EFFECT_VIBRATO:
            return m_pcVibrato->getParam(parameterID - 1);
            
        case EFFECT_WAH:
            return m_pcWah->getParam(parameterID - 1);
            break;
            
        case EFFECT_GRANULAR:
            return m_pcGranularizer->getParam(parameterID - 1);
            break;
            
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
            m_pcTremolo->prepareToPlay(sampleRate);
            break;
            
            
        case EFFECT_DELAY:
            m_pcDelay->prepareToPlay(sampleRate);
            break;
            
            
        case EFFECT_VIBRATO:
            m_pcVibrato->prepareToPlay(sampleRate);
            break;
            
        case EFFECT_WAH:
            m_pcWah->prepareToPlay(sampleRate);
            break;
            
        case EFFECT_GRANULAR:
            m_pcGranularizer->prepareToPlay(sampleRate);
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
            m_pcTremolo->process(audioBuffer, blockSize, bypassState);
            break;
           
            
        case EFFECT_DELAY:
            m_pcDelay->process(audioBuffer, blockSize, bypassState);
            break;
            
            
        case EFFECT_VIBRATO:
            m_pcVibrato->process(audioBuffer, blockSize, bypassState);
            break;
        
            
        case EFFECT_WAH:
            m_pcWah->process(audioBuffer, blockSize, bypassState);
            break;
            
            
        case EFFECT_GRANULAR:
            m_pcGranularizer->process(audioBuffer, blockSize, bypassState);
            break;
         
            
        default:
            break;
    }
}