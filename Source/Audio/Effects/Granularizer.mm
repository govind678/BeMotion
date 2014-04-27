//==============================================================================
//
//  Granularizer.cpp
//  GestureController
//
//  Created by Cian O'Brien on 4/22/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================

#include "Granularizer.h"
#include <iostream>

CGranularizer::CGranularizer(int numChannels)
{
    
    m_iNumChannels  =   numChannels;
	m_fSampleRate   =   0.0f;

	m_iNextGrain		= new int [numChannels];
	m_iNextGrainCount	= new int [numChannels];

	m_ppfDelayLine		= new CRingBuffer<float> *[numChannels];
	m_ppfGrainBuffer	= new CRingBuffer<float> *[numChannels];

	for (int n = 0; n < numChannels; n++)
	{
		m_ppfDelayLine[n]	= new CRingBuffer<float>(MAX_DELAY_SAMPLES);
		m_ppfGrainBuffer[n]	= new CRingBuffer<float>(MAX_DELAY_SAMPLES);

		// set indices and buffer contents to zero:
		m_ppfDelayLine[n]->resetInstance();
		m_ppfGrainBuffer[n]->resetInstance();
	}

	initDefaults();
}

CGranularizer::~CGranularizer()
{
    delete [] m_ppfDelayLine;
	delete [] m_ppfGrainBuffer;
	delete [] m_iNextGrain;
	delete [] m_iNextGrainCount;
}

void CGranularizer::initDefaults()
{  
	m_fSampleRate	= 0.0f;
	m_fGrainSize	= 0.8f;
	m_fGrainTime	= 1.0f;
	m_fPoolSize		= 0.0f;
	m_fOffset		= 0.0f;

	m_iCount		= 0;
	m_iGrainCount	= 0;
	
	for (int n = 0; n < m_iNumChannels; n++)
	{
		m_iNextGrain[n]			= 0;
		m_iNextGrainCount[n]	= 0;
	}
}

void CGranularizer::prepareToPlay(float sampleRate)
{
    m_fSampleRate = sampleRate;

	for (int c=0; c < m_iNumChannels; c++)
	{
		m_ppfDelayLine[c]->setWriteIdx(std::min((int)(10 * m_fSampleRate), MAX_DELAY_SAMPLES));
	}
}

void CGranularizer::setParam(int type, float value)
{
	switch(type)
	{
		
		case PARAM_1:
			if (0.0f <=value && value <= 1.0f)
            {
                std::cout << "Grain Size" << value << std::endl;
				m_fGrainSize	= value;
            }
		break;  

		case PARAM_2:
			if (value >= 0.05f)
            {
                std::cout << "Grain Interval" << value << std::endl;
				m_fGrainTime	= value;
            }
				//setParam(0, (value + getParam(0)) * 0.5);
		break;   

		case PARAM_3:
			if (0.0f <=value && value <= 1.0f)
            {
                std::cout << "Pool Size" << value << std::endl;
				m_fPoolSize		= value;
            }
		break;
            
		default: break;
	}
}

void CGranularizer::generateGrain(int chan)
{

	int currentIdx;

	currentIdx = m_ppfDelayLine[chan]->getReadIdx();

	m_fOffset = m_ppfDelayLine[chan]->getReadIdx() + (1.0f - m_fPoolSize) * (m_ppfDelayLine[chan]->getWriteIdx() - m_ppfDelayLine[chan]->getReadIdx() - m_fGrainTime * m_fSampleRate);
	// set the read index to a random starting point between the offset and the max value (which depends on the grain length):
	m_ppfDelayLine[chan]->setReadIdx( (int)floor(m_fOffset) + rand() % (m_ppfDelayLine[chan]->getWriteIdx() - (int)(2 * m_fGrainTime * m_fSampleRate) + 1));


	// fill the grain buffer from the delay line:
	m_ppfGrainBuffer[chan]->resetInstance();

	for (int i = 0; i < (int)(m_fGrainSize * m_fGrainTime * m_fSampleRate); i++)
	{
		if (i < (int)(0.4 * m_fGrainSize * m_fGrainTime * m_fSampleRate))
			m_ppfGrainBuffer[chan]->putPostInc((i/(int)(0.4 * m_fGrainSize * m_fGrainTime * m_fSampleRate)) * m_ppfDelayLine[chan]->getPostInc());
		else if (i >= (int)(0.4 * m_fGrainSize * m_fGrainTime * m_fSampleRate) && i < (int)(0.7 * m_fGrainSize * m_fGrainTime * m_fSampleRate))
			m_ppfGrainBuffer[chan]->putPostInc(m_ppfDelayLine[chan]->getPostInc());
		else if (i >= (int)(0.7 * m_fGrainSize * m_fGrainTime * m_fSampleRate))
			m_ppfGrainBuffer[chan]->putPostInc((((int)(m_fGrainSize * m_fGrainTime * m_fSampleRate)-i)/(int)(0.7 * m_fGrainSize * m_fGrainTime * m_fSampleRate))*m_ppfDelayLine[chan]->getPostInc());

	}
	
	// reset the read index:
	//m_ppfDelayLine[c]->setWriteIdx(m_ppfDelayLine[c]->getReadIdx() - MAX_DELAY_SAMPLES / 2);
	m_ppfDelayLine[chan]->setWriteIdx(currentIdx);

}

void CGranularizer::process(float** audioBuffer, int numFrames, bool bypass)
{
	if (!bypass)
    {
        for (int c = 0; c < m_iNumChannels; c++)
		{
			m_iCount = 0;

			while (m_iCount < numFrames)
			{

				// check if we still have samples from the grain buffer to read:
				if (m_ppfGrainBuffer[c]->getReadIdx() != m_ppfGrainBuffer[c]->getWriteIdx())
				{
					m_iFramesLeft = numFrames - m_iCount;

					m_iGrainCount = 0;
					while (m_iGrainCount < std::min(m_ppfGrainBuffer[c]->getWriteIdx() - m_ppfGrainBuffer[c]->getReadIdx(), m_iFramesLeft))
					{
						m_ppfDelayLine[c]->getPostInc();
						m_ppfDelayLine[c]->putPostInc(audioBuffer[c][m_iCount]);

						audioBuffer[c][m_iCount] = m_ppfGrainBuffer[c]->getPostInc();
								
						m_iGrainCount			= m_iGrainCount + 1;
						m_iCount				= m_iCount + 1;
						m_iNextGrainCount[c]	= m_iNextGrainCount[c] - 1;
					}
				}
				
				// output zeros until we get to the index where the next grain should start:
				while((m_iNextGrainCount[c] > 0) && (m_iCount < numFrames))
				{
					m_ppfDelayLine[c]->getPostInc();
					m_ppfDelayLine[c]->putPostInc(audioBuffer[c][m_iCount]);

					audioBuffer[c][m_iCount] = 0.0f;

					m_iCount				= m_iCount + 1;
					m_iNextGrainCount[c]	= m_iNextGrainCount[c] - 1;
				}

				// output the contents of the grain buffer:
				m_iGrainCount = 0;
				m_iFramesLeft = numFrames - m_iCount;

				while (m_iGrainCount < std::min((int)(m_fGrainSize * m_fGrainTime * m_fSampleRate), m_iFramesLeft))
				{
					if (m_iNextGrainCount[c] == 0)
					{
						// samples until next grain:
						m_iNextGrainCount[c] = (int)(m_fGrainTime * m_fSampleRate);
						generateGrain(c);
					}

					m_ppfDelayLine[c]->getPostInc();
					m_ppfDelayLine[c]->putPostInc(audioBuffer[c][m_iCount]);

					audioBuffer[c][m_iCount] = m_ppfGrainBuffer[c]->getPostInc();						

					m_iGrainCount			= m_iGrainCount + 1;
					m_iCount				= m_iCount + 1;
					m_iNextGrainCount[c]	= m_iNextGrainCount[c] - 1;
				}
			}
		}   
    }
}

float CGranularizer::getParam(int type)
{
    switch(type)
	{
		
		case PARAM_1:
            return m_fGrainSize;
            break;
            
            
		case PARAM_2:
			return m_fGrainTime;
            break;
            
            
		case PARAM_3:
			return m_fPoolSize;
            break;
            
		default:
            return 0.0f;
            break;
		
	}
}
