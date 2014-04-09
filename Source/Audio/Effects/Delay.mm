//==============================================================================
//
//  Delay.cpp
//  GestureController
//
//  Created by Cian O'Brien on 2/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#include "Delay.h"
#include <stdio.h>
#include <iostream>

CDelay::CDelay(int numChannels)
{
    
    m_iNumChannels  =   numChannels;
	m_fSampleRate   =   0.0f;
    
    m_fFeedBack     =   0.0f;
	m_fWetDry       =   0.0f;
    m_fDelayTime_s  =   0.0f;
    
    
	ringBuffer = new CRingBuffer<float> *[numChannels];

	for (int n = 0; n < numChannels; n++)
	{
		ringBuffer[n]	= new CRingBuffer<float>((int)(MAX_DELAY_SAMPLES));
		// set indices and buffer contents to zero:
		ringBuffer[n]->resetInstance();
	}

    
	initializeWithDefaultParameters();
}


CDelay::~CDelay()
{
    delete [] ringBuffer;
}


void CDelay::initializeWithDefaultParameters()
{
    m_fFeedBack             =   0.5f;
    m_fWetDry               =   0.5f;
    m_fDelayTime_s          =   2.0f;
}



void CDelay::prepareToPlay(float sampleRate)
{
    m_fSampleRate   =   sampleRate;
    
    for (int n = 0; n < m_iNumChannels; n++)
    {
        ringBuffer[n]->setWriteIdx(ringBuffer[n]->getReadIdx() + (m_fDelayTime_s * m_fSampleRate));
    }
    
}




void CDelay::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		case PARAM_1:
			// delayTime_target	= value;
			if (value > 0.0f)
            {
				m_fDelayTime_s = value;
            }
		break;
            
            
		case PARAM_2:
			// feedBack_target		= value;
			if (value >= 0 && value <= 1)
				m_fFeedBack = value;
		break;
            
            
		case PARAM_3:
			// wetDry_target		= value;
			if (abs(value) <= 1)
				m_fWetDry = value;
		break;
            
		default: break;
	}
}

void CDelay::process(float** audioBuffer, int numFrames, bool bypass)
{
	if (!bypass)
    {
        
    
	// for each channel, for each sample:
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < m_iNumChannels; c++)
		{	
			// ugly looking equation for fractional delay:
			audioBuffer[c][i] =
            
            (1 - m_fWetDry) * (audioBuffer[c][i])
            
            + m_fFeedBack * m_fWetDry *
            
            ((ringBuffer[c]->getPostInc()) * (m_fDelayTime_s * m_fSampleRate - (int)(m_fDelayTime_s * m_fSampleRate))
                                                             
            + (ringBuffer[c]->get()) * (1 - m_fDelayTime_s * m_fSampleRate + (int)(m_fDelayTime_s * m_fSampleRate)));

			// outputBuffer[c][i] =	(1-getWetDry())*(inputBuffer[c][i])
			//						 + 0.5*getWetDry()*(ringBuffer[c]->getPostInc());

			// add the output value to the ring buffer:
			ringBuffer[c]->putPostInc(audioBuffer[c][i]);
		}
	}
        
        
    }
}



float CDelay::getParam(int type)
{
    switch(type)
	{
		case PARAM_1:
            return m_fDelayTime_s;
            break;
            
            
		case PARAM_2:
			return m_fFeedBack;
            break;
            
            
		case PARAM_3:
			return	m_fWetDry;
            break;
            
		default:
            return 0.0f;
            break;
	}
}
