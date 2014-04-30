//==============================================================================
//
//  Limiter.cpp
//  GestureController
//
//  Created by Cian O'Brien on 4/22/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================

#include "Limiter.h"

CLimiter::CLimiter(int numChannels)
{
    
    m_iNumChannels  =   numChannels;
	m_fSampleRate   =   0.0f;

	m_fPeak		= new float [numChannels];
	m_fCoeff	= new float [numChannels];
	m_fGain		= new float [numChannels];

	m_ppRingBuffer = new CRingBuffer<float> *[numChannels];
	for (int n = 0; n < numChannels; n++)
	{
		m_ppRingBuffer[n]	= new CRingBuffer<float>((int)(LIMITER_MAX_SAMPLES));
		// set indices and buffer contents to zero:
		m_ppRingBuffer[n]->resetInstance();
	}

	initDefaults();
}

CLimiter::~CLimiter()
{
    delete [] m_ppRingBuffer;
	delete [] m_fPeak;
	delete [] m_fGain;
	delete [] m_fCoeff;
}

void CLimiter::initDefaults()
{  
	m_fSampleRate	= 0.0f;
	m_fThresh		= 1.0f;
	m_fAttackInSec	= 0.01f;
	m_fReleaseInSec	= 0.5f;
	m_fDelayInSec   = 0.01f;

	for (int n = 0; n < m_iNumChannels; n++)
	{
		m_fPeak[n]		= 0.0f;
		m_fGain[n]		= 1.0f;
		m_fCoeff[n]		= 0.0f;
	}
}

void CLimiter::prepareToPlay(float sampleRate)
{
    m_fSampleRate = sampleRate;
    
	// set the write index:
    for (int n = 0; n < m_iNumChannels; n++)
    {
        m_ppRingBuffer[n]->setWriteIdx(m_ppRingBuffer[n]->getReadIdx() + (int)(m_fDelayInSec * m_fSampleRate));
    }
}

void CLimiter::setParam(int type, float value)
{
	switch(type)
	{
		
		case PARAM_1:
			if (value > 0.0f)
            {
				m_fAttackInSec	= value;
            }
		break;
		            
		case PARAM_2:
			if (value >= 0.0f)
				m_fReleaseInSec = value;
		break;
		      
		case PARAM_3:
			if (value >= 0.0f)
				m_fThresh = value;
		break;
            
		default: break;
		
	
	}
}

void CLimiter::process(float** audioBuffer, int numFrames, bool bypass)
{
	if (!bypass)
    {
        for (int c = 0; c < m_iNumChannels; c++)
		{
			for (int i = 0; i < numFrames; i++)
			{	

				if (fabs(audioBuffer[c][i]) > m_fPeak[c])
				{
					m_fCoeff[c] = m_fAttackInSec;
				} else {
					m_fCoeff[c] = m_fReleaseInSec;
				}

				m_fPeak[c] = (1.0f-m_fCoeff[c]) * m_fPeak[c] + m_fCoeff[c] * fabs(audioBuffer[c][i]);

				if (std::min(1.0f, m_fThresh/m_fPeak[c]) < m_fGain[c])
				{
					m_fCoeff[c] = m_fAttackInSec;
				} else {
					m_fCoeff[c] = m_fReleaseInSec;
				}

				m_fGain[c] = (1.0f-m_fCoeff[c]) * m_fGain[c] + m_fCoeff[c] * (std::min(1.0f, m_fThresh/m_fPeak[c]));

				m_ppRingBuffer[c]->putPostInc(audioBuffer[c][i]);
				audioBuffer[c][i] = m_fGain[c] * m_ppRingBuffer[c]->getPostInc();
			
			}
		}   
    }
}

float CLimiter::getParam(int type)
{
    switch(type)
	{
		
		case PARAM_1:
            return m_fAttackInSec;
            break;
            
            
		case PARAM_2:
			return m_fReleaseInSec;
            break;
            
            
		case PARAM_3:
			return m_fThresh;
            break;
            
		default:
            return 0.0f;
            break;
		

	}

}
