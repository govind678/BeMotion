//
//  Wah2.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/12/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#ifndef __BeatMotion__Wah2__
#define __BeatMotion__Wah2__

#include "Macros.h"
#include <math.h>

class Wah
{
    
public:
    
    Wah(int numChannels);
    ~Wah();
    
    
    void setParameter(int paramID, float value);
    float getParameter(int paramID);
    
    void prepareToPlay(float sampleRate);
	void finishPlaying();
	void process(float **audioBuffer, int numFrames);
    
    
private:
    
    void initializeWithDefaultParameters();
    
	float                   m_fSampleRate;
	int                     m_iNumChannels;
    
    //-- Parameters --//
	float                   m_fCenterFrequency;
	float                   m_fQ;
    float                   m_fBlend;
    
    float                   m_fMaxFreq;
    float                   m_fMinFreq;
    float                   m_fRange;
    
    //-- Coefficient --//
    float                   m_fAngularFrequency;

    //-- Sample Values --//
    float*                  m_pfHighpass;
    float*                  m_pfBandpass;
    float*                  m_pfLowpass;
    
};



#endif /* defined(__BeatMotion__Wah2__) */
