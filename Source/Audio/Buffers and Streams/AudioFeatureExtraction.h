//
//  AudioFeatureExtraction.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/23/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#ifndef __BeMotion__AudioFeatureExtraction__
#define __BeMotion__AudioFeatureExtraction__

#include "BeMotionHeader.h"
#include "Macros.h"

class AudioFeatureExtraction
{
    
public:
    
    AudioFeatureExtraction();
    ~AudioFeatureExtraction();
    
    float detectFirstOnset(String filepath);
    
private:
    
    AudioFormatManager                      formatManager;
    ScopedPointer<AudioFormatReaderSource>  currentAudioFileSource;
    
    float                                   m_fSampleRate;
};

#endif /* defined(__BeMotion__AudioFeatureExtraction__) */
