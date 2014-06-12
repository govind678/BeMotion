//==============================================================================
//
//  Delay.h
//  BeMotion
//
//  Created by Cian O'Brien on 2/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#if !defined(__CDelay_hdr__)
#define __CDelay_hdr__

#include "RingBuffer.h"
#include "Macros.h"


/*	Fractional Delay
	----------------
	Paramaters:	
		- Delay time
		- Feedback
		- Wet/Dry Mix
*/

class CDelay
{
public:

	CDelay(int numChannels);
    ~CDelay ();

	// set:
	void setParam(int parameterID, float value);
    // get:
	float getParam(int parameterID);

	void prepareToPlay(float sampleRate);
	void finishPlaying();
	void process(float **audioBuffer, int numFrames);

	void finishPlayback();
    
	
private:
    
    void initializeWithDefaultParameters();
    
    void setDelayTime(int time);

//	CRingBuffer<float>** ringBuffer;
    CRingBuffer<float>** wetSignal;
//    CRingBuffer<float>** delayLine;

    
    
	float m_fSampleRate;
	int m_iNumChannels;

	float m_fFeedBack;
	float m_fWetDry;
	float m_fDelayTime_s;
    
    float m_fFractionalDelay;
    float m_fIntegralDelay;

};

#endif
