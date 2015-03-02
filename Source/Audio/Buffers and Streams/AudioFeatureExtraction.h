//
//  AudioFeatureExtraction.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/23/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#ifndef __BeatMotion__AudioFeatureExtraction__
#define __BeatMotion__AudioFeatureExtraction__

#include "BeatMotionHeader.h"
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

#endif /* defined(__BeatMotion__AudioFeatureExtraction__) */
