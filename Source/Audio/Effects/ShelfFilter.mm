//
//  ShelfFilter.cpp
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/12/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#include "ShelfFilter.h"

ShelfFilter::ShelfFilter(int numChannels)
{
    m_iNumChannels = numChannels;
    m_fSampleRate  = DEFAULT_SAMPLE_RATE;
    
    m_fNormFrequency   = 0.0f;
    m_fGain            = 0.0f;
    m_fV0              = 0.0f;
    m_fH0              = 0.0f;
   
    m_fC               = 0.0f;
    
    m_iType            = 0;
    m_pfXh             = new float[numChannels];
    m_pfXhN            = new float[numChannels];
    m_pfAp_Y           = new float[numChannels];
    
    for (int channel = 0; channel < numChannels; channel++)
    {
        m_pfXh[channel] = 0.0f;
        m_pfXhN[channel] = 0.0f;
        m_pfAp_Y[channel] = 0.0f;
    }
}


ShelfFilter::~ShelfFilter()
{
    delete [] m_pfAp_Y;
    delete [] m_pfXh;
    delete [] m_pfXhN;
}


void ShelfFilter::setParameter(int paramID, float value)
{
    switch (paramID)
    {
        case PARAM_1:
            m_fNormFrequency = value;
            calculateCoeffs();
            break;
            
        case PARAM_2:
            m_fGain = (value - 0.5f) * 24.0f;
            
            m_fV0   = powf(10.0f, (m_fGain / 20.0f));
            m_fH0   = m_fV0 - 1.0f;
            calculateCoeffs();
            break;
            
        case PARAM_3:
            if (value < 0.5f)
            {
                m_iType = 0;
            }
            
            else
            {
                m_iType = 1;
            }
            
        default:
            break;
    }
}


void ShelfFilter::calculateCoeffs()
{
    // Boost
    if (m_fGain >= 0.0f)
    {
        m_fC = (tanf(M_PI * m_fNormFrequency / 2.0f) - 1.0f) / (tanf(M_PI * m_fNormFrequency / 2.0f) + 1.0f);
    }
    
    // Cut
    else
    {
        m_fC = (tanf(M_PI * m_fNormFrequency / 2.0f) - m_fV0) / (tanf(M_PI * m_fNormFrequency / 2.0f) + m_fV0);
    }
}


void ShelfFilter::prepareToPlay(float sampleRate)
{
    m_fSampleRate = sampleRate;
    
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        m_pfXh[channel] = 0.0f;
        m_pfXhN[channel] = 0.0f;
        m_pfAp_Y[channel] = 0.0f;
    }

}


void ShelfFilter::process(float **audioBuffer, int numFrames)
{
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        for (int sample = 0; sample < numFrames; sample++)
        {
//            xh_new = x(n) - c*xh;
//            ap_y = c * xh_new + xh;
//            xh = xh_new;
//            y(n) = 0.5 * H0 * (x(n) + ap_y) + x(n);  % change to minus for HS
            
            
            m_pfXhN[channel] = audioBuffer[channel][sample] - (m_fC * m_pfXh[channel]);
            m_pfAp_Y[channel] = m_fC * m_pfXhN[channel] + m_pfXh[channel];
            m_pfXh[channel] = m_pfXhN[channel];
            
            if (m_iType == 0)
            {
                audioBuffer[channel][sample] = 0.5f * m_fH0 * (audioBuffer[channel][sample] + m_pfAp_Y[channel]) + audioBuffer[channel][sample];
            }
            
            else
            {
                audioBuffer[channel][sample] = 0.5f * m_fH0 * (audioBuffer[channel][sample] - m_pfAp_Y[channel]) - audioBuffer[channel][sample];
            }
            
        }
    }
}


void ShelfFilter::finishPlaying()
{
    
}