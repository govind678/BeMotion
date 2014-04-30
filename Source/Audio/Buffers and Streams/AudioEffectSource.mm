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
    m_pfRawParameter.clear();
    
    for (int i=0; i < NUM_EFFECTS_PARAMS; i++)
    {
        m_pcParameter.add(new Parameter());
        m_pcParameter.getUnchecked(i)->setSmoothingParameter(0.8);
        
        m_pfRawParameter.add(0.0f);
        
        m_pbGestureControl.add(false);
    }
    
    
    //--- Better Way To Generate This? ---//
    m_iTimeQuantizationPoints[0] = 1;
    m_iTimeQuantizationPoints[1] = 2;
    m_iTimeQuantizationPoints[2] = 3;
    m_iTimeQuantizationPoints[3] = 4;
    m_iTimeQuantizationPoints[4] = 6;
    m_iTimeQuantizationPoints[5] = 8;
    m_iTimeQuantizationPoints[6] = 12;
    m_iTimeQuantizationPoints[7] = 16;
    
    
    m_fTempo    =   0.0f;
    setTempo(DEFAULT_TEMPO);

    
    
    switch (effectID)
    {
        case EFFECT_TREMOLO:
        {
            m_pcTremolo         =   new CTremolo(numChannels);
            
            for (int i=0; i < NUM_EFFECTS_PARAMS; i++)
            {
                m_pfRawParameter.set(i, m_pcTremolo->getParam(i + 1));
            }
            
            break;
        }
          
        case EFFECT_DELAY:
        {
            m_pcDelay           =   new CDelay(numChannels);
            
            for (int i=0; i < NUM_EFFECTS_PARAMS; i++)
            {
                m_pfRawParameter.set(i, m_pcDelay->getParam(i + 1));
            }
            
            break;
        }
            
        case EFFECT_VIBRATO:
        {
            m_pcVibrato         =   new CVibrato(numChannels);
            
            for (int i=0; i < NUM_EFFECTS_PARAMS; i++)
            {
                m_pfRawParameter.set(i, m_pcVibrato->getParam(i + 1));
            }
            
            break;
        }
            
        case EFFECT_WAH:
        {
            m_pcWah             =   new CWah(numChannels);
            
            for (int i=0; i < NUM_EFFECTS_PARAMS; i++)
            {
                m_pfRawParameter.set(i, m_pcWah->getParam(i + 1));
            }
            
            break;
        }
            
        
        case EFFECT_GRANULAR:
        {
            m_pcGranularizer    =   new CGranularizer(numChannels);
            
            for (int i=0; i < NUM_EFFECTS_PARAMS; i++)
            {
                m_pfRawParameter.set(i, m_pcGranularizer->getParam(i + 1));
            }
            
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
    m_pfRawParameter.clear();
}


void AudioEffectSource::setSmoothing(int parameterID, float smoothing)
{
    m_pcParameter.getUnchecked(parameterID - 4)->setSmoothingParameter(smoothing);
}



void AudioEffectSource::setParameter(int parameterID, float value)
{
    m_pfRawParameter.set(parameterID - 1, value);
    
    int quantizedIndex = int(((1.0f - value) * (MAX_CLOCK_DIVISOR - 1)) + 0.5f);
    
    switch (m_iEffectID)
    {
        case EFFECT_TREMOLO:
            
            if (parameterID == PARAM_1)
            {
                m_pcTremolo->setParam(parameterID, 1 / (m_iTimeQuantizationPoints[quantizedIndex] * m_fSmallestTimeInterval));
            }
            
            else
            {
                m_pcTremolo->setParam(parameterID, value);
            }
            break;
        
            
        case EFFECT_DELAY:
            
            if (parameterID == PARAM_1)
            {
                m_pcDelay->setParam(parameterID, m_iTimeQuantizationPoints[quantizedIndex] * m_fSmallestTimeInterval);
            }
            
            else
            {
                m_pcDelay->setParam(parameterID, value);
            }
            
            break;
           
            
            
        case EFFECT_VIBRATO:
            
            if (parameterID == PARAM_1)
            {
                m_pcVibrato->setParam(parameterID, 1 / (m_iTimeQuantizationPoints[quantizedIndex] * m_fSmallestTimeInterval));
            }
            
            else
            {
                m_pcVibrato->setParam(parameterID, value);
            }
            
            break;
            
            
            
        case EFFECT_WAH:
            m_pcWah->setParam(parameterID, value);
            break;
            
            
            
        case EFFECT_GRANULAR:
            m_pcGranularizer->setParam(parameterID, value);
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



void AudioEffectSource::motionUpdate(float* motion)
{
    
    if (m_pbGestureControl.getUnchecked(PARAM_MOTION_PARAM1))
    {
        float param = m_pcParameter.getUnchecked(PARAM_MOTION_PARAM1)->process(motion[ATTITUDE_PITCH]);
        
        int quantizedIndex = int((param * (MAX_CLOCK_DIVISOR - 1)) + 0.5f);
        
        switch (m_iEffectID)
        {
            case EFFECT_TREMOLO:
                m_pcTremolo->setParam(PARAM_1, 1 / (m_iTimeQuantizationPoints[quantizedIndex] * m_fSmallestTimeInterval));
                break;
                
            case EFFECT_DELAY:
                m_pcDelay->setParam(PARAM_1, m_iTimeQuantizationPoints[quantizedIndex] * m_fSmallestTimeInterval);
                break;
                
            case EFFECT_VIBRATO:
                m_pcVibrato->setParam(PARAM_1, 1 / (m_iTimeQuantizationPoints[quantizedIndex] * m_fSmallestTimeInterval));
                break;
                
            case EFFECT_WAH:
                m_pcWah->setParam(PARAM_1, param);
                break;
                
            case EFFECT_GRANULAR:
                m_pcGranularizer->setParam(PARAM_1, param);
                break;
                
            default:
                break;
        
        }
    }
    
    
    
    if (m_pbGestureControl.getUnchecked(PARAM_MOTION_PARAM2))
    {
        switch (m_iEffectID)
        {
            case EFFECT_TREMOLO:
                m_pcTremolo->setParam(PARAM_2, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM2)->process(motion[ATTITUDE_ROLL]));
                break;
                
            case EFFECT_DELAY:
                m_pcDelay->setParam(PARAM_2, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM2)->process(motion[ATTITUDE_ROLL]));
                break;
                
            case EFFECT_VIBRATO:
                m_pcVibrato->setParam(PARAM_2, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM2)->process(motion[ATTITUDE_ROLL]));
                break;
                
            case EFFECT_WAH:
                m_pcWah->setParam(PARAM_2, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM2)->process(motion[ATTITUDE_ROLL]));
                break;
                
            case EFFECT_GRANULAR:
                m_pcGranularizer->setParam(PARAM_2, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM2)->process(motion[ATTITUDE_ROLL]));
                break;
                
            default:
                break;
                
        }
    }
    
    
    
    if (m_pbGestureControl.getUnchecked(PARAM_MOTION_PARAM3))
    {
        switch (m_iEffectID)
        {
            case EFFECT_TREMOLO:
                m_pcTremolo->setParam(PARAM_3, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM3)->process(motion[ATTITUDE_YAW]));
                break;
                
            case EFFECT_DELAY:
                m_pcDelay->setParam(PARAM_3, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM3)->process(motion[ATTITUDE_YAW]));
                break;
                
            case EFFECT_VIBRATO:
                m_pcVibrato->setParam(PARAM_3, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM3)->process(motion[ATTITUDE_YAW]));
                break;
                
            case EFFECT_WAH:
                m_pcWah->setParam(PARAM_3, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM3)->process(motion[ATTITUDE_YAW]));
                break;
                
            case EFFECT_GRANULAR:
                m_pcGranularizer->setParam(PARAM_3, m_pcParameter.getUnchecked(PARAM_MOTION_PARAM3)->process(motion[ATTITUDE_YAW]));
                break;
                
            default:
                break;
                
        }
    }
}



float AudioEffectSource::getParameter(int parameterID)
{
    return m_pfRawParameter.getUnchecked(parameterID - 1);
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



void AudioEffectSource::setTempo(float newTempo)
{
    m_fTempo = newTempo;
    m_fSmallestTimeInterval   =  60.0f / (m_fTempo * MAX_CLOCK_DIVISOR);
}