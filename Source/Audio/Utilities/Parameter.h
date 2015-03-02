//==============================================================================
//
//  Parameter.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 4/8/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================

#ifndef __BeatMotion__Parameter__
#define __BeatMotion__Parameter__

#include "Macros.h"

class Parameter
{
    
public:
    
    Parameter();
    ~Parameter();
    
    struct Effect
    {
        float param1;
        float param2;
        float param3;
    };
    
    void setSmoothingParameter(float newAlpha);
    
    float process(float value);
    
    void setTempo(int newTempo);
    
    
    
    
    
private:
    
    float       m_fAlpha;
    float       m_fParameter;
    
    float       m_iTempo;
    
    Effect      m_sEffect;
    
};


#endif /* defined(__BeatMotion__Parameter__) */