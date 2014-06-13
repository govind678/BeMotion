//
//  Granularizer2.cpp
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/13/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#include "Granularizer2.h"
#include <stdio.h>
#include <iostream>

Granularizer2::Granularizer2(int numChannels)
{
    m_iNumChannels  = numChannels;
    m_fSampleRate   = DEFAULT_SAMPLE_RATE;
    
    
    m_ppcBuffer     = new CRingBuffer<float>* [m_iNumChannels];
    m_ppcGrain      = new CRingBuffer<float>* [m_iNumChannels];
    
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        m_ppcBuffer[channel]    = new CRingBuffer<float> (GRANULAR_MAX_SAMPLES);
        m_ppcGrain[channel]     = new CRingBuffer<float> (GRANULAR_MAX_SAMPLES * 0.5f);
    }
    
    m_fSize_per         =   0.0f;
    m_fRate_s           =   0.0f;
    m_iStartIndex       =   0;
    m_iSampleCount      =   0;
    m_iSamplesBuffered  =   0;
    m_iSizeSamples      =   0;
    m_iRateSamples      =   0;
    m_bBufferingToggle  =   false;
    m_bGrainToggle      =   false;
    
    initializeWithDefaultParameters();
}

Granularizer2::~Granularizer2()
{
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        delete m_ppcBuffer[channel];
        delete m_ppcGrain[channel];
    }
    
    delete [] m_ppcBuffer;
    delete [] m_ppcGrain;
}


void Granularizer2::initializeWithDefaultParameters()
{
    m_fRate_s   = 0.5f;
    m_fSize_per = 0.5;
    calculateParameters();
}


void Granularizer2::setParameter(int parameterID, float value)
{
    switch (parameterID)
    {
        case PARAM_1:
            m_fRate_s = value;
            calculateParameters();
            break;
            
        case PARAM_2:
            m_fSize_per = value;
            calculateParameters();
            break;
            
        default:
            break;
    }

    
}


float Granularizer2::getParameter(int parameterID)
{
    return 0.0f;
}


void Granularizer2::prepareToPlay(float sampleRate)
{
    m_fSampleRate = sampleRate;
    calculateParameters();
}


void Granularizer2::process(float **audioBuffer, int numFrames)
{
    for (int sample = 0; sample < numFrames; sample++)
    {
        m_iSampleCount--;
        
        if (m_iSampleCount <= 0)
        {
            generateGrain();
            m_iSampleCount = m_iRateSamples;
            m_bGrainToggle = true;
        }
        
        //--- Initially check number of samples buffered ---//
        if (!m_bBufferingToggle)
        {
            m_iSamplesBuffered++;
            
            if (m_iSamplesBuffered >= GRANULAR_MAX_SAMPLES)
            {
                m_bBufferingToggle = true;
            }
        }
        
        
        for (int channel = 0; channel < m_iNumChannels; channel++)
        {
            m_ppcBuffer[channel]->putPostInc(audioBuffer[channel][sample]);
            
            if (m_bGrainToggle)
            {
                audioBuffer[channel][sample] = m_ppcGrain[channel]->getPostInc();
            }
            
        }
    }
    
}


void Granularizer2::generateGrain()
{
    m_iStartIndex = ((double) rand() / (RAND_MAX)) * m_iSamplesBuffered;
//    std::cout << "Generate at " << m_iStartIndex << std::endl;
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
//        m_ppcGrain[channel]->resetInstance();
        m_ppcGrain[channel]->resetIndices();
        m_ppcBuffer[channel]->setReadIdx(m_iStartIndex);
        
        for (int sample = 0; sample < m_iSizeSamples; sample++)
        {
            m_ppcGrain[channel]->putPostInc(m_ppcBuffer[channel]->getPostInc());
        }
        
        for (int sample = m_iSizeSamples; sample < m_iRateSamples; sample++)
        {
            m_ppcGrain[channel]->putPostInc(0.0f);
        }
    }
    
}


void Granularizer2::calculateParameters()
{
    m_iRateSamples = m_fRate_s * m_fSampleRate;
    m_iSampleCount = m_iRateSamples;
    std::cout << "Rate: " << m_iRateSamples << std::endl;
    
    m_iSizeSamples = (((1.0f - m_fSize_per) * 0.99f) + 0.01f) * m_iRateSamples;
    std::cout << "Size: " << m_iSizeSamples << std::endl;
    
}


void Granularizer2::finishPlaying()
{
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        m_ppcGrain[channel]->resetInstance();
        m_ppcBuffer[channel]->resetInstance();
        m_bBufferingToggle = false;
        m_bGrainToggle     = false;
    }
}



