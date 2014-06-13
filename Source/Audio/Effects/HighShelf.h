//
//  HighShelf.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/12/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#ifndef __BeMotion__HighShelf__
#define __BeMotion__HighShelf__

#include <math.h>
#include "Macros.h"

class HighShelf
{
public:
    
    HighShelf(int numChannels);
    ~HighShelf();
    
    void prepareToPlay(float sampleRate);
	void finishPlaying();
	void process(float **audioBuffer, int numFrames);
    
    void setParameter(int paramID, float value);
    
    
private:
    
    void calculateCoeffs();
    
    float   m_fSampleRate;
    int     m_iNumChannels;
    
    float   m_fNormFrequency;
    float   m_fGain;
    float   m_fV0;
    float   m_fH0;
    float   m_fC;
    
    float*  m_pfXh;
    float*  m_pfXhN;
    float*  m_pfAp_Y;
};

#endif /* defined(__BeMotion__HighShelf__) */
