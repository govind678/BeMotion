//==============================================================================
//
//  Limiter.h
//  BeMotion
//
//  Created by Cian O'Brien on 4/22/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================



#if !defined(__Limiter_hdr__)
#define __Limiter_hdr__

#include "RingBuffer.h"
#include <Math.h>
#include <stdio.h>
#include "Macros.h"
#include <algorithm>


/*	Limiter
	----------------
	Paramaters:	
		- Attack Time
		- Release Time
		- Threshold
*/

class CLimiter
{
public:

	CLimiter(int NumChannels);
	~CLimiter ();

	// set:
	void setParam(int parameterID, float value);
	// get:
	float getParam(int parameterID);

	void prepareToPlay(float sampleRate);

	void initDefaults();

	// process:
	void process(float **inputBuffer, int numFrames);

private:

	CRingBuffer<float> **m_ppRingBuffer;

	float m_fAttackInSec;
	float m_fReleaseInSec;
	float m_fDelayInSec;
	float m_fThresh;

	float * m_fPeak;
	float * m_fCoeff;
	float * m_fGain;

	float m_fSampleRate;
	int   m_iNumChannels;

};

#endif
