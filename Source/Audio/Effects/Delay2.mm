//
//  Delay2.cpp
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/11/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#include "Delay2.h"

Delay2::Delay2(int numChannels)
{
    m_iNumChannels  =   numChannels;
    m_fSampleRate   =   DEFAULT_SAMPLE_RATE;
    
    m_fFeedBack     =   0.0f;
	m_fWetDry       =   0.0f;
    m_fDelayTime_s  =   0.0f;
    
    
    ringBuffer = new CRingBuffer<float>* [numChannels];
	for (int n = 0; n < numChannels; n++)
	{
		ringBuffer[n]	= new CRingBuffer<float>((int)(DELAY_MAX_SAMPLES));
		// set indices and buffer contents to zero:
		ringBuffer[n]->resetInstance();
	}
    
    initializeWithDefaultParameters();
}


Delay2::~Delay2()
{
    delete [] ringBuffer;
}


void Delay2::initializeWithDefaultParameters()
{
    m_fFeedBack             =   0.5f;
    m_fWetDry               =   0.5f;
    m_fDelayTime_s          =   0.5f;
}


void Delay2::setParameter(int paramID, float value)
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
		case PARAM_1:
            
            m_fDelayTime_s = value;
            
            for (int n = 0; n < m_iNumChannels; n++)
            {
                ringBuffer[n]->setWriteIdx(ringBuffer[n]->getReadIdx() + (m_fDelayTime_s * m_fSampleRate));
            }
            
            break;
            
            
		case PARAM_2:
            
            m_fWetDry = value;
            
            break;
            
            
		case PARAM_3:
            
            m_fFeedBack = value;
            
            break;
            
		default: break;
	}
}

float Delay2::getParameter(int paramID)
{
    return 0.0f;
}



void Delay2::prepareToPlay(float sampleRate)
{
    
}


void Delay2::process(float **audioBuffer, int numFrames)
{
    
}


void Delay2::finishPlaying()
{
    
}


void Delay2::finishPlayback()
{
    
}