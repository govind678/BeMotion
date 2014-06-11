//==============================================================================
//
//  Granularizer.mm
//  BeMotion
//
//  Created by Cian O'Brien on 4/22/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================

#include "Granularizer.h"

CGranularizer::CGranularizer(int numChannels)
{
    
    m_iNumChannels  =   numChannels;
	m_fSampleRate   =   0.0f;

	m_iNextGrain		= new int [numChannels];
	m_iNextGrainCount	= new int [numChannels];

	m_ppfDelayLine		= new CRingBuffer<float> *[numChannels];
	m_ppfGrainBuffer	= new CRingBuffer<float> *[numChannels];

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
	m_fGrainSize	= 0.5f;
	m_fGrainTime	= 0.5f;
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

	m_ppfWindowBuffer = new CRingBuffer<float>(sampleRate);

	for (int c=0; c < m_iNumChannels; c++)
	{
		m_ppfDelayLine[c]	= new CRingBuffer<float>((int)floor(std::min(GRANULAR_MAX_SAMPLES, 5.0 * m_fSampleRate)));
		m_ppfGrainBuffer[c]	= new CRingBuffer<float>((int)floor(m_fSampleRate));

		m_ppfDelayLine[c]->resetInstance();
		m_ppfGrainBuffer[c]->resetInstance();
	}
}

void CGranularizer::setParam(int type, float value)
{
	switch(type)
	{
		
		case PARAM_1:
			if (0.1f <= value && value < 0.97f)
            {

				m_fGrainTime	= value;
				m_fGrainSize    = (1.0 - m_fGrainTime) * 0.2 + m_fGrainTime;
            }
			if (value <= 0.03)
			{
				m_fGrainTime	= 0.0;
				m_fGrainSize    = (1.0 - m_fGrainTime) * 0.2 + m_fGrainTime;
            }
			if (value >= 0.97)
			{
				m_fGrainTime	= 0.97;
				m_fGrainSize    = (1.0 - m_fGrainTime) * 0.2 + m_fGrainTime;
            }
		break;  

		case PARAM_2:
		break;   

		case PARAM_3:	
		break;
            
		default: break;
	}
}

void CGranularizer::generateGrain(int chan)
{

	m_ppfGrainBuffer[chan]->resetInstance();

	int currReadIdx;
	int maxReadIdx;

	currReadIdx = m_ppfDelayLine[chan]->getReadIdx();
	maxReadIdx  = m_ppfDelayLine[chan]->getWriteIdx() - (int)floorf((m_fGrainTime * m_fGrainSize * m_fSampleRate));
	
	srand(currReadIdx + 1);

	m_ppfDelayLine[chan]->setReadIdx(
		currReadIdx + (int)((1.0 - m_fPoolSize)*( std::min(GRANULAR_MAX_SAMPLES, 5.0 * m_fSampleRate) * rand() / RAND_MAX))
		);

	// envelope: buffer, length, attack time, release time,
	generateWindow(m_ppfWindowBuffer, (int)floorf((m_fGrainTime * m_fGrainSize * m_fSampleRate)),0.45 - m_fGrainTime*(0.44), 0.55 + m_fGrainTime*(0.44));

	for (int i=0; i < (int)floorf((m_fGrainTime * m_fGrainSize * m_fSampleRate)); i++){
		m_ppfGrainBuffer[chan]->putPostInc(
			m_ppfWindowBuffer->getPostInc() * m_ppfDelayLine[chan]->getPostInc()
			);
	}

	m_ppfDelayLine[chan]->setReadIdx(currReadIdx);
}

void CGranularizer::generateWindow(CRingBuffer<float>* buffer, int length, float attack, float release)
{

	buffer->resetInstance();

	m_iRampUp	= (int)floor(length * attack);
	m_iRampDown = std::max((int)floor(length * release), m_iRampUp + 1);

	for (int i=0; i < m_iRampUp; i++)
	{
		buffer->putPostInc( (float)(i/m_iRampUp) );
	}
	for (int i=m_iRampUp; i < m_iRampDown; i++)
	{
		buffer->putPostInc( 1.0 );
	}
	for (int i=m_iRampDown; i < length; i++)
	{
		buffer->putPostInc( (float)((m_iRampDown - i) / (m_iRampDown - length)) );
	}
}


void CGranularizer::process(float** audioBuffer, int numFrames)
{
    for (int c = 0; c < m_iNumChannels; c++)
    {
        m_iCount = 0;
        
        while (m_iCount < numFrames)
        {
            if (m_iNextGrainCount[c] == 0)
                m_ppfGrainBuffer[c]->resetInstance();
            
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
            
            if (m_iNextGrainCount[c] == 0)
            {
                // samples until next grain:
                m_iNextGrainCount[c] = (int)(floorf(m_fGrainTime * m_fSampleRate));
                generateGrain(c);
                
                // output the contents of the grain buffer:
                m_iGrainCount = 0;
                m_iFramesLeft = numFrames - m_iCount;
                
                while (m_iGrainCount < std::min(m_ppfGrainBuffer[c]->getWriteIdx() - m_ppfGrainBuffer[c]->getReadIdx(), m_iFramesLeft)
                       && m_iNextGrainCount[c] > 0)
                {
					
                    m_ppfDelayLine[c]->getPostInc();
                    m_ppfDelayLine[c]->putPostInc(audioBuffer[c][m_iCount]);
                    
                    audioBuffer[c][m_iCount] = m_ppfGrainBuffer[c]->getPostInc();						
                    
                    m_iGrainCount			= std::min(m_iGrainCount + 1,(int)floorf((m_fGrainTime * m_fSampleRate)));
                    m_iCount				= m_iCount + 1;
                    m_iNextGrainCount[c]	= m_iNextGrainCount[c] - 1;
                }
                // samples until next grain:
                m_iNextGrainCount[c] = std::max((int)floorf((m_fGrainTime * m_fSampleRate)) - m_iGrainCount, 0);
                
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
