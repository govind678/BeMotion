//==============================================================================
//
//  Tremolo.cpp
//  GestureController
//
//  Created by Cian O'Brien on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================

#include <stdio.h>
#include <iostream>
#include "Tremolo.h"

CTremolo::CTremolo(int numChannels)
{
	m_iNumChannels = numChannels;
	initDefaults();
}

void CTremolo::prepareToPlay(float sampleRate)
{
	m_fSampleRate	= sampleRate;
	LFO = new CLFO(sampleRate);	
}

void CTremolo::initDefaults()
{
	m_fDepth	= 1.0;
	m_fRate		= 5.0;
}

void CTremolo::setType(CLFO::LFO_Type type)
{
	LFO->setLFOType(type);
}


void CTremolo::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		case PARAM_1:
			m_fRate = (20.0 * value);
            LFO->setFrequencyinHz(m_fRate);
		break;
            
		case PARAM_2:
            m_fDepth = value;
		break;
            
		default: 
			break;
	}
}

void CTremolo::process(float **inputBuffer, int numFrames, bool bypass)
{
    if (!bypass)
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

}


float CTremolo::getParam(int type)
{
    switch(type)
	{
		case PARAM_1:
			return m_fRate;
            break;
            
		case PARAM_2:
            return m_fDepth;
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