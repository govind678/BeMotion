//
//  AudioEffectSource.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__AudioEffectSource__
#define __SharedLibrary__AudioEffectSource__

#include "SharedLibraryHeader.h"
#include "Delay.h"
#include "Tremolo.h"
// Add Effect Header Here


class AudioEffectSource
{
public:
    
    AudioEffectSource(int effectID, int numChannels);
    ~AudioEffectSource();
    
    void setParameter(int parameterID, float value);
    
    void audioDeviceAboutToStart(float sampleRate);
    void process(float** audioBuffer, int blockSize, bool bypassState);
    void audioDeviceStopped();
    
private:
    
    ScopedPointer<CDelay>   delayEffect;
    ScopedPointer<CTremolo> tremoloEffect;
    
    int m_iEffectID;
};

#endif /* defined(__SharedLibrary__AudioEffectSource__) */
