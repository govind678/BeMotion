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
    
    
    m_fSize_per             =   0.0f;
    m_fRate_s               =   0.0f;
    m_iStartIndex           =   0;
    m_iSampleCount          =   0;
    m_iSamplesBuffered      =   0;
    m_iSizeSamples          =   0;
    m_iRateSamples          =   0;
    m_fPitch                =   0.0f;
    m_fPitchRandomness      =   0.0f;
    m_fFloatIndex           =   0.0f;
    m_bBufferingToggle      =   false;
    m_bGrainToggle          =   false;
    m_fTempo                =   0.0f;
    m_iQuantizationInterval =   0;
    
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
    m_fPitchRandomness  =   1.0f;
    calculateParameters();
    
    m_iSampleCount  =   m_iRateSamples;
    
    m_fPitchArray[0]    = powf(2.0f, (0.0f / 12.0));
    m_fPitchArray[1]    = powf(2.0f, (-2.0f / 12.0));
    m_fPitchArray[2]    = powf(2.0f, (3.0f / 12.0));
    m_fPitchArray[3]    = powf(2.0f, (5.0f / 12.0));
    m_fPitchArray[4]    = powf(2.0f, (7.0f / 12.0));
    m_fPitchArray[5]    = powf(2.0f, (-4.0f / 12.0));
    m_fPitchArray[6]    = powf(2.0f, (-5.0f / 12.0));
    m_fPitchArray[7]    = powf(2.0f, (-7.0f / 12.0));
    m_fPitchArray[8]    = powf(2.0f, (8.0f / 12.0));
    m_fPitchArray[9]    = powf(2.0f, (10.0f / 12.0));
    m_fPitchArray[10]    = powf(2.0f, (12.0f / 12.0));
    m_fPitchArray[11]    = powf(2.0f, (-9.0f / 12.0));
    m_fPitchArray[12]    = powf(2.0f, (-12.0f / 12.0));
    m_fPitchArray[13]    = powf(2.0f, (2.0f / 12.0));
    m_fPitchArray[14]    = powf(2.0f, (-10.0f / 12.0));
    
    
    for (int i=0; i < ENVELOPE_SAMPLES; i++)
    {
        m_fEnvelope[i] = tanhf(i / 4.0f);
    }
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
            m_fSize_per = (1.0f - value);
            calculateParameters();
            break;
            
        case PARAM_3:
            m_fPitchRandomness = (1.0f - value);
            break;
            
        default:
            break;
    }

    
}


float Granularizer2::getParameter(int parameterID)
{
    switch (parameterID)
    {
        case PARAM_1:
            return m_fRate_s;
            break;
            
        case PARAM_2:
            return (1.0f - m_fSize_per);
            break;
            
        case PARAM_3:
            return (1.0f - m_fPitchRandomness);
            break;
            
        default:
            return 0.0f;
            break;
    }
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
    int randomIndex = ((double) rand() / (RAND_MAX)) * m_iSamplesBuffered;
    m_iStartIndex = randomIndex - (randomIndex % m_iQuantizationInterval);
    if (m_iStartIndex < 0)
    {
        m_iStartIndex = 0;
    }
    
    int index = 0;
    float random = (double) rand() / (RAND_MAX);
    if( random > (m_fPitchRandomness + 0.1f))
    {
        index = int( (double(rand()) / RAND_MAX) * NUM_PITCHES );
        m_fPitch = m_fPitchArray[index];
    }
    
    else
    {
        m_fPitch = 1.0f;
    }
    
//    std::cout << "Pitch: " << m_fPitch << "\t Randomness: " << random << "\tPR: " << m_fPitchRandomness << std::endl;
//    std::cout << "Start: " << m_iStartIndex << "\t Random: " << randomIndex << std::endl;
    
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        m_ppcGrain[channel]->resetIndices();
        
        for (int sample = 0; sample < (m_iSizeSamples / m_fPitch); sample++)
        {
            m_fFloatIndex = m_iStartIndex + (sample * m_fPitch);
            
            if (sample < ENVELOPE_SAMPLES)
            {
                m_ppcGrain[channel]->putPostInc(m_ppcBuffer[channel]->getAtFloatIdx(m_fFloatIndex) * m_fEnvelope[sample]);
            }
            
            else
            {
                m_ppcGrain[channel]->putPostInc(m_ppcBuffer[channel]->getAtFloatIdx(m_fFloatIndex));
            }
            
        }
        
        for (int sample = 0; sample < m_iRateSamples - (m_iSizeSamples / m_fPitch); sample++)
        {
             m_ppcGrain[channel]->putPostInc(0.0f);
        }
    }
    
}


void Granularizer2::calculateParameters()
{
    m_iRateSamples = m_fRate_s * m_fSampleRate;
//    m_iSampleCount = 0;
//    std::cout << "Rate: " << m_iRateSamples << std::endl;
    
    m_iSizeSamples = (((1.0f - m_fSize_per) * 0.99f) + 0.01f) * m_iRateSamples;
//    std::cout << "Size: " << m_iSizeSamples << std::endl;
    
}


void Granularizer2::finishPlaying()
{
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        m_ppcGrain[channel]->resetInstance();
        m_ppcBuffer[channel]->resetInstance();
        m_bBufferingToggle = false;
        m_bGrainToggle     = false;
        m_iSamplesBuffered = 0;
    }
}


void Granularizer2::setTempo(float tempo)
{
    m_fTempo = tempo;
    m_iQuantizationInterval = (60.0f / (m_fTempo * 4)) * m_fSampleRate;
//    std::cout << "Quant: " << m_iQuantizationInterval << std::endl;
    
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        m_ppcBuffer[channel]->setWrapPoint(GRANULAR_MAX_SAMPLES - (GRANULAR_MAX_SAMPLES % m_iQuantizationInterval));
    }
}

