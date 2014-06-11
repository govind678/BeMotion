//
//  Delay2.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/11/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#ifndef __BeMotion__Delay2__
#define __BeMotion__Delay2__

#include "RingBuffer.h"
#include "Macros.h"

class Delay2
{
    
public:
    
    Delay2(int numChannels);
    ~Delay2();
    
    void setParameter(int paramID, float value);
    float getParameter(int paramID);
    
    void prepareToPlay(float sampleRate);
	void finishPlaying();
	void process(float **audioBuffer, int numFrames);
    
    void finishPlayback();
    
private:
    
    void initializeWithDefaultParameters();
    
    CRingBuffer<float> **ringBuffer;
    
	float m_fSampleRate;
	int m_iNumChannels;
    
    //-- Parameters --//
	float m_fFeedBack;
	float m_fWetDry;
	float m_fDelayTime_s;
    
    float m_fFractionaDelay;
    int   m_iIntDelay;
    
};

#endif /* defined(__BeMotion__Delay2__) */
