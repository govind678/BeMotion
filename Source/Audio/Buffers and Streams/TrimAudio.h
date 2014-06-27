//==============================================================================
//
//  TrimAudio.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/9/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================

#ifndef __BeMotion__TrimAudio__
#define __BeMotion__TrimAudio__

#include "BeMotionHeader.h"
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


#endif /* defined(__BeMotion__TrimAudio__) */
