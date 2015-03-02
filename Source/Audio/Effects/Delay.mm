//==============================================================================
//
//  Delay.mm
//  BeatMotion
//
//  Created by Cian O'Brien on 2/8/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================


#include "Delay.h"


CDelay::CDelay(int numChannels)
{
    
    m_iNumChannels      =   numChannels;
	m_fSampleRate       =   DEFAULT_SAMPLE_RATE;
    
    m_fFeedBack         =   0.0f;
	m_fWetDry           =   0.0f;
    m_fDelayTime_s      =   0.0f;
    
//	ringBuffer = new CRingBuffer<float> *[numChannels];
    wetSignal  = new CRingBuffer<float>* [numChannels];
//    delayLine  = new CRingBuffer<float>* [numChannels];

	for (int n = 0; n < numChannels; n++)
	{
//		ringBuffer[n]	= new CRingBuffer<float>(DELAY_MAX_SAMPLES);
        wetSignal[n]    = new CRingBuffer<float> (DELAY_MAX_SAMPLES);
//        delayLine[n]    = new CRingBuffer<float> (DELAY_MAX_SAMPLES);
		// set indices and buffer contents to zero:
//		ringBuffer[n]->resetInstance();
        wetSignal[n]->resetInstance();
//        delayLine[n]->resetInstance();
	}

    
	initializeWithDefaultParameters();
}


CDelay::~CDelay()
{
    for (int n = 0; n < m_iNumChannels; n++)
    {
//        delete ringBuffer[n];
        delete wetSignal[n];
//        delete delayLine[n];
    }
    
//    delete [] ringBuffer;
    delete [] wetSignal;
//    delete [] delayLine;
}


void CDelay::initializeWithDefaultParameters()
{
    m_fFeedBack             =   0.5f;
    m_fWetDry               =   0.5f;
    m_fDelayTime_s          =   0.5f;
}



void CDelay::prepareToPlay(float sampleRate)
{
    m_fSampleRate   =   sampleRate;
    
    for (int n = 0; n < m_iNumChannels; n++)
    {
        wetSignal[n]->setWriteIdx(wetSignal[n]->getReadIdx() + (m_fDelayTime_s * m_fSampleRate));
//        ringBuffer[n]->setWriteIdx(ringBuffer[n]->getReadIdx() + (m_fDelayTime_s * m_fSampleRate));
    }
    
}




void CDelay::setParam(/*hFile::enumType type*/ int type, float value)
{
    if (value < 0.0f)
    {
        value = 0.0f;
    }
    
    else if (value > 1.0f)
    {
        value = 1.0f;
    }
    
    
	switch(type)
	{
		case PARAM_1:
            
            m_fDelayTime_s = value;
            
            for (int n = 0; n < m_iNumChannels; n++)
            {
//                ringBuffer[n]->setWriteIdx(ringBuffer[n]->getReadIdx() + (m_fDelayTime_s * m_fSampleRate));
                wetSignal[n]->setWriteIdx(wetSignal[n]->getReadIdx() + (m_fDelayTime_s * m_fSampleRate));
//                delayLine[n]->setWriteIdx(delayLine[n]->getReadIdx() + (m_fDelayTime_s * m_fSampleRate));
            }
            
		break;
            
            
		case PARAM_2:
            
            m_fWetDry = value;
            
            if (m_fWetDry < 0.05f)
            {
                for (int channel = 0; channel < m_iNumChannels; channel++)
                {
                    wetSignal[channel]->flushBuffer();
                }
            }
            
		break;
            
            
		case PARAM_3:
            
            if (value < 0.0f)
            {
                m_fFeedBack = 0.0f;
            }
            
            else if (value >= 0.95f)
            {
                m_fFeedBack = 0.95f;
            }
            
            else
            {
                m_fFeedBack = value;
            }
            
		break;
            
		default: break;
	}
}

void CDelay::process(float** audioBuffer, int numFrames)
{
    
    // for each channel, for each sample:
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < m_iNumChannels; c++)
		{
            // Create Delay Line
//            wetSignal[c]->putPostInc( audioBuffer[c][i] + (m_fFeedBack *
//                            (
//                              (wetSignal[c]->get() * (m_fDelayTime_s * m_fSampleRate - (int)(m_fDelayTime_s * m_fSampleRate))) +
//                              (wetSignal[c]->get() * (1 - m_fDelayTime_s * m_fSampleRate + (int)(m_fDelayTime_s * m_fSampleRate)))
//                            )
//                        ));
            
            wetSignal[c]->putPostInc(audioBuffer[c][i] + (m_fFeedBack * wetSignal[c]->get()));
            
            if (m_fWetDry <= 0.5f)
            {
                audioBuffer[c][i] = audioBuffer[c][i] + (2 * m_fWetDry * wetSignal[c]->getPostInc());
            }
            
            else
            {
                audioBuffer[c][i] = (((2.0f * (1.0f - m_fWetDry)) * audioBuffer[c][i])) + (m_fWetDry * wetSignal[c]->getPostInc());
            }
            
			// ugly looking equation for fractional delay:
            
            
//            if (m_fWetDry <= 0.5f)
//            {
//                audioBuffer[c][i] =
//            
//                (audioBuffer[c][i])

//                 + m_fFeedBack * 2.0f * m_fWetDry *
//            
//                 (
//                  (ringBuffer[c]->getPostInc()) * (m_fDelayTime_s * m_fSampleRate - (int)(m_fDelayTime_s * m_fSampleRate))
//                  +
//                  (ringBuffer[c]->get()) * (1 - m_fDelayTime_s * m_fSampleRate + (int)(m_fDelayTime_s * m_fSampleRate))
//                 );
//
//                // outputBuffer[c][i] =	(1-getWetDry())*(inputBuffer[c][i])
//                //						 + 0.5*getWetDry()*(ringBuffer[c]->getPostInc());
//                
//                // add the output value to the ring buffer:
//                ringBuffer[c]->putPostInc(audioBuffer[c][i]);
//            }
//            
//            
//            else
//            {
//                audioBuffer[c][i] =
//                
//                (2.0f * (1.0f - m_fWetDry)) * (audioBuffer[c][i])
//                
//                + m_fFeedBack * m_fWetDry *
//                
//                ((ringBuffer[c]->getPostInc()) * (m_fDelayTime_s * m_fSampleRate - (int)(m_fDelayTime_s * m_fSampleRate))
//                 
//                 + (ringBuffer[c]->get()) * (1 - m_fDelayTime_s * m_fSampleRate + (int)(m_fDelayTime_s * m_fSampleRate)));
//                
//                // outputBuffer[c][i] =	(1-getWetDry())*(inputBuffer[c][i])
//                //						 + 0.5*getWetDry()*(ringBuffer[c]->getPostInc());
//                
//                // add the output value to the ring buffer:
//                ringBuffer[c]->putPostInc(audioBuffer[c][i]);
//            }
			
		}
	}
}

void CDelay::finishPlayback()
{
	 for (int n = 0; n < m_iNumChannels; n++)
    {
//        ringBuffer[n]->resetInstance();
        wetSignal[n]->resetInstance();
//        delayLine[n]->resetInstance();
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
