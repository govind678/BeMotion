//
//  Granularizer2.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/13/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#ifndef __BeMotion__Granularizer2__
#define __BeMotion__Granularizer2__

#include "Macros.h"
#include "RingBuffer.h"
#include "LFO.h"
#include <math.h>

#define NUM_PITCHES 15
#define ENVELOPE_SAMPLES  20

class Granularizer2
{
    
public:
    
    Granularizer2(int numChannels);
    ~Granularizer2();
    
    // set:
	void setParameter(int parameterID, float value);
    // get:
	float getParameter(int parameterID);
    
	void prepareToPlay(float sampleRate);
	void finishPlaying();
	void process(float **audioBuffer, int numFrames);
    
    void setTempo(float tempo);
    
    
private:
    
    void initializeWithDefaultParameters();
    void generateGrain();
    void calculateParameters();
    
    CRingBuffer<float>**    m_ppcBuffer;
    CRingBuffer<float>**    m_ppcGrain;
    
    float                   m_fEnvelope[ENVELOPE_SAMPLES];
    
    int                     m_iNumChannels;
    float                   m_fSampleRate;
    
    //-- Parameters --//
    float                   m_fRate_s;
    float                   m_fSize_per;
    float                   m_fPitchRandomness;
    
    int                     m_iRateSamples;
    int                     m_iSizeSamples;
    
    int                     m_iStartIndex;
    int                     m_iSampleCount;
    float                   m_fPitch;
    float                   m_fFloatIndex;
    float                   m_fPitchArray [NUM_PITCHES];
    float                   m_fTempo;
    int                     m_iQuantizationInterval;
    
    int                     m_iSamplesBuffered;
    bool                    m_bBufferingToggle;
    bool                    m_bGrainToggle;
};

#endif /* defined(__BeMotion__Granularizer2__) */
