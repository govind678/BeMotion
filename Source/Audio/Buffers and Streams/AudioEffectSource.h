//==============================================================================
//
//  AudioEffectSource.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#ifndef __GestureController__AudioEffectSource__
#define __GestureController__AudioEffectSource__


#include "GestureControllerHeader.h"
#include "Macros.h"

//------- Effect Headers -------//
#include "Delay.h"
#include "Tremolo.h"

//------------------------------//



class AudioEffectSource
{
public:
    
    AudioEffectSource(int effectID, int numChannels);
    ~AudioEffectSource();
    
    void setParameter(int parameterID, float value);
    
    float getParameter(int parameterID);
    int   getEffectType();
    
    void audioDeviceAboutToStart(float sampleRate);
    void process(float** audioBuffer, int blockSize, bool bypassState);
    void audioDeviceStopped();
    
private:
    
    ScopedPointer<CDelay>   delayEffect;
    ScopedPointer<CTremolo> tremoloEffect;
    
    int m_iEffectID;
};

#endif /* defined(__GestureController__AudioEffectSource__) */
