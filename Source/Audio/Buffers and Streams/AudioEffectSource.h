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
#include "Parameter.h"

//------- Effect Headers -------//
#include "Delay.h"
#include "Tremolo.h"
#include "Vibrato.h"
#include "Wah.h"
#include "Granularizer.h"
//------------------------------//



class AudioEffectSource
{
public:
    
    AudioEffectSource(int effectID, int numChannels);
    ~AudioEffectSource();
    
    void setParameter(int parameterID, float value);
    void setSmoothing(int parameterID, float smoothing);
    
    float getParameter(int parameterID);
    int   getEffectType();
    
    void setGestureControlToggle(int parameterID, bool toggle);
    bool getGestureControlToggle(int parameterID);
    
    
    void audioDeviceAboutToStart(float sampleRate);
    void process(float** audioBuffer, int blockSize, bool bypassState);
    void audioDeviceStopped();
    
private:
    
    ScopedPointer<CDelay>           m_pcDelay;
    ScopedPointer<CTremolo>         m_pcTremolo;
    ScopedPointer<CVibrato>         m_pcVibrato;
    ScopedPointer<CWah>             m_pcWah;
    ScopedPointer<CGranularizer>    m_pcGranularizer;
    
    OwnedArray<Parameter>           m_pcParameter;
    Array<bool>                     m_pbGestureControl;
    
    int m_iEffectID;
};

#endif /* defined(__GestureController__AudioEffectSource__) */
