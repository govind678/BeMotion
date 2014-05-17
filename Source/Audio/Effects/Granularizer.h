//==============================================================================
//
//  Granularizer.h
//  BeMotion
//
//  Created by Cian O'Brien on 4/22/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#if !defined(__Granularizer_hdr__)
#define __Granularizer_hdr__

#include "RingBuffer.h"
#include <Math.h>
#include "Macros.h"
#include <algorithm>


/*	Granularizer
	----------------
	Paramaters:
		- Grain Inter-onset Time in sec
        - Grain Size as a proportion of Grain onset time
		- Grain Pool Size
*/

class CGranularizer
{
public:

	CGranularizer(int NumChannels);
	~CGranularizer ();

	// set:
	void setParam(int parameterID, float value);
	// get:
	float getParam(int parameterID);

	void prepareToPlay(float sampleRate);

	void initDefaults();

	// process:
	void process(float **inputBuffer, int numFrames, bool bypass);

private:

	void generateGrain(int chan);
	void generateWindow(CRingBuffer<float>* buffer, int length, float attack, float release);

	CRingBuffer<float> **m_ppfDelayLine;
	CRingBuffer<float> **m_ppfGrainBuffer;
	CRingBuffer<float> *m_ppfWindowBuffer;

	float m_fGrainSize;
	float m_fGrainTime;
	float m_fPoolSize;
	float m_fSampleRate;
	float m_fOffset;

	int   * m_iNextGrain;
	int   * m_iNextGrainCount;
	int   m_iNumChannels;
	int   m_iCount;
	int   m_iGrainCount;
	int	  m_iFramesLeft;

	int m_iRampUp;
	int m_iRampDown;

};

#endif
