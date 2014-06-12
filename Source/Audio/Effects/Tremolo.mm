//==============================================================================
//
//  Tremolo.mm
//  BeMotion
//
//  Created by Cian O'Brien on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================

#include <stdio.h>
#include <iostream>
#include "Tremolo.h"

CTremolo::CTremolo(int numChannels)
{
	m_iNumChannels = numChannels;
    
    LFO = new CLFO(DEFAULT_SAMPLE_RATE);
    
	initDefaults();
}

void CTremolo::prepareToPlay(float sampleRate)
{
	m_fSampleRate	= sampleRate;
    LFO->setSampleRate(m_fSampleRate);
}

void CTremolo::initDefaults()
{
	m_fDepth	= 1.0;
	m_fRate		= 5.0;
    m_fShape    = 0.01f;
    LFO->setShape(m_fShape);
}



void CTremolo::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		case PARAM_1:
			m_fRate = (20.0 * value);
//            LFO->setFrequencyinHz(m_fRate);
            LFO->setFrequencyinHz(value);
		break;
            
		case PARAM_2:
            m_fDepth = value;
            break;
            
        case PARAM_3:
            m_fShape = value;
            LFO->setShape(m_fShape);
            break;
            
		default:
			break;
	}
}


void CTremolo::process(float **inputBuffer, int numFrames)
{
    // generate the LFO:
	LFO->generate(numFrames);
    
	// for each channel, for each sample:
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < m_iNumChannels; c++)
		{
			inputBuffer[c][i] = (1 + m_fDepth*LFO->getLFOSampleData(i))*(inputBuffer[c][i]);
		}
	}
}


float CTremolo::getParam(int type)
{
    switch(type)
	{
		case PARAM_1:
			return (m_fRate / 20.0f);
            break;
            
		case PARAM_2:
            return m_fDepth;
            break;
            
        case PARAM_3:
            
            return m_fShape;
            break;
            
		default:
            return 0.0f;
			break;
	}
}



CTremolo::~CTremolo()
{
    delete LFO;
}