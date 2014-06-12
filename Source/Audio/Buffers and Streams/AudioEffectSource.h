//==============================================================================
//
//  AudioEffectSource.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#ifndef __BeMotion__AudioEffectSource__
#define __BeMotion__AudioEffectSource__


#include "BeMotionHeader.h"
#include "Macros.h"
#include "Parameter.h"

//------- Effect Headers -------//
#include "Delay.h"
#include "Tremolo.h"
#include "Vibrato.h"
//#include "Wah.h"
#include "Wah2.h"
#include "Granularizer.h"
//------------------------------//


#define MAX_CLOCK_DIVISOR   8
#define NUM_QUANTIZATION_POINTS 8


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
    void process(float** audioBuffer, int blockSize);
    void audioDeviceStopped();
    
    void setTempo(float newTempo);
    
    void motionUpdate(float* motion);
    
private:
    
    ScopedPointer<CDelay>           m_pcDelay;
    ScopedPointer<CTremolo>         m_pcTremolo;
    ScopedPointer<CVibrato>         m_pcVibrato;
    ScopedPointer<Wah>              m_pcWah;
    ScopedPointer<CGranularizer>    m_pcGranularizer;
    
    OwnedArray<Parameter>           m_pcParameter;
    Array<bool>                     m_pbGestureControl;
    
    Array<float>                    m_pfRawParameter;
    int                             m_iTimeQuantizationPoints [NUM_QUANTIZATION_POINTS];
    
    float m_fTempo;
    float m_fSmallestTimeInterval;
    
    int m_iEffectID;
};

#endif /* defined(__BeMotion__AudioEffectSource__) */
