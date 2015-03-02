//==============================================================================
//
//  TrimAudio.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/9/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================

#ifndef __BeatMotion__TrimAudio__
#define __BeatMotion__TrimAudio__

#include "BeatMotionHeader.h"
#include "Macros.h"


class TrimAudio
{
    
public:
    
    TrimAudio();
    ~TrimAudio();
    
    void setSamplingRate(float samplingRate);
    void cropAudioFile(String filepath, float startTime_s, float stopTime_s);
    void trimAudioFile(String filepath);
    
private:
    
    float                                       m_fSampleRate;
    
    File                                        workingFile;
    AudioFormatManager                          formatManager;
    WavAudioFormat                              wavAudioFormat;
    ScopedPointer<AudioFormatReaderSource>      currentAudioFileSource;
    
};


#endif /* defined(__BeatMotion__TrimAudio__) */
