//
//  Wah2.cpp
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/12/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#include "Wah2.h"

Wah::Wah(int numChannels)
{
    m_iNumChannels = numChannels;
    m_fSampleRate  = DEFAULT_SAMPLE_RATE;
    
    m_pfHighpass = new float[m_iNumChannels];
    m_pfBandpass = new float[m_iNumChannels];
    m_pfLowpass  = new float[m_iNumChannels];
    
    for (int channel=0; channel < m_iNumChannels; channel++)
    {
        m_pfHighpass[channel] = 0.0f;
        m_pfBandpass[channel] = 0.0f;
        m_pfLowpass[channel]  = 0.0f;
    }
    
    initializeWithDefaultParameters();
}

Wah::~Wah()
{
    delete [] m_pfBandpass;
    delete [] m_pfHighpass;
    delete [] m_pfLowpass;
}


void Wah::initializeWithDefaultParameters()
{
    m_fCenterFrequency  =   1000.0f;
    m_fQ                =   0.1f;
    m_fMinFreq          =   200.0f;
    m_fMaxFreq          =   1600.0f;
    m_fRange            =   1.0f;
    m_fBlend            =   0.5;    // 60% Wet, 40% Dry
    
    m_fAngularFrequency = 2 * sinf((M_PI * m_fCenterFrequency) / m_fSampleRate);
    
}


void Wah::setParameter(int paramID, float value)
{
    if (value < 0.0f)
    {
        value = 0.0f;
    }
    
    else if (value > 1.0f)
    {
        value = 1.0f;
    }
    
    
    switch(paramID)
	{
        // Center Frequency
		case PARAM_1:
            
            m_fCenterFrequency = (value * (m_fMaxFreq - m_fMinFreq)) + m_fMinFreq;
            m_fAngularFrequency = 2 * sinf((M_PI * m_fCenterFrequency) / m_fSampleRate);
            break;
           
            
        // Bandwidth 'Q'
		case PARAM_2:
            
            m_fQ = 1.0f - value;
            
            if (m_fQ < 0.1f)
            {
                m_fQ = 0.1f;
            }
            
            break;
           
        // Frequency Range - TODO: Changed from Frequency range to Blend
		case PARAM_3:
            m_fBlend   = value;
//            m_fRange   = value;
//            m_fMinFreq = ((1.0f - value) * 600.0f) + 200.0f;
//            m_fMaxFreq = (value * 600.0f) + 1200.0f;
            break;
            
		default: 
			break;
	}
}


float Wah::getParameter(int paramID)
{
    switch (paramID)
    {
        case PARAM_1:
            return ((m_fCenterFrequency - m_fMinFreq) / (m_fMaxFreq - m_fMinFreq));
            break;
            
        case PARAM_2:
            return (1.0f - m_fQ);
            break;
            
        case PARAM_3:
            return m_fRange;
            break;
            
        default:
            return 0.0f;
            break;
    }
}


void Wah::prepareToPlay(float sampleRate)
{
    m_fSampleRate = sampleRate;
    m_fAngularFrequency = 2 * sinf((M_PI * m_fCenterFrequency) / m_fSampleRate);
}


void Wah::process(float **audioBuffer, int numFrames)
{
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        for (int sample = 0; sample < numFrames; sample++)
        {
            m_pfHighpass[channel] = audioBuffer[channel][sample] - m_pfLowpass[channel] - (m_fQ * m_pfBandpass[channel]);
            m_pfBandpass[channel] = (m_fAngularFrequency * m_pfHighpass[channel]) + m_pfBandpass[channel];
            m_pfLowpass[channel]  = (m_fAngularFrequency * m_pfBandpass[channel]) + m_pfLowpass[channel];
            
            audioBuffer[channel][sample] = (m_fBlend * m_pfBandpass[channel]) + ((1 - m_fBlend) * audioBuffer[channel][sample]);
        }
    }
    
}


void Wah::finishPlaying()
{
    
}







