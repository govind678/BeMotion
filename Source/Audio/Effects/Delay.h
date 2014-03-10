//==============================================================================
//
//  Delay.h
//  GestureController
//
//  Created by Cian O'Brien on 2/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#if !defined(__CDelay_hdr__)
#define __CDelay_hdr__

#include "RingBuffer.h"
#include "Macros.h"

#define MAX_DELAY_SAMPLES 100000

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
	void process(float **audioBuffer, int numFrames, bool bypass);

	
    
	
private:
    
    void initializeWithDefaultParameters();

	CRingBuffer<float> **ringBuffer;

    
    
	float m_fSampleRate;
	int m_iNumChannels;

	float m_fFeedBack;
	float m_fWetDry;
	float m_fDelayTime_s;
    
    
    float m_fFractionaDelay;
    int   m_iIntDelay;

};

#endif