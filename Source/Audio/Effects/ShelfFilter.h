//
//  ShelfFilter.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/12/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#ifndef __BeMotion__ShelfFilter__
#define __BeMotion__ShelfFilter__

#include <math.h>
#include "Macros.h"

class ShelfFilter
{
public:
    
    ShelfFilter(int numChannels);
    ~ShelfFilter();
    
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
    int     m_iType;        //0-> Low, 1-> High
    
    float   m_fV0;
    float   m_fH0;
    float   m_fC;
    
    float*  m_pfXh;
    float*  m_pfXhN;
    float*  m_pfAp_Y;
};

#endif /* defined(__BeMotion__ShelfFilter__) */
