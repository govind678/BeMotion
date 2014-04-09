//==============================================================================
//
//  GestureControllerInterface.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#ifndef __GestureController__GestureControllerInterface__
#define __GestureController__GestureControllerInterface__


#include "AudioEngine.h"

class GestureControllerInterface
{
public:
    
    GestureControllerInterface();
    ~GestureControllerInterface();
    
    
    //============== GUI to Backend Methods ==================
    void loadAudioFile(int sampleID, NSString* filepath);
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void setParameter(int sampleID, int effectPosition, int parameterID, float value);
    
    void startPlayback(int sampleID);
    void stopPlayback(int sampleID);
    
    void startRecording(int sampleID);
    void stopRecording(int sampleID);
    
    void beat(int beatNo);
    //========================================================
    

    //============== Backend to GUI Methods ==================
    int getEffectType(int sampleID, int effectPosition);
    float getParameter(int sampleID, int effectPosition, int parameterID);
    //========================================================
    
    
    // TODO: Implement Parameter Scaling
    
    
    
private:
    
    AudioEngine*    audioEngine;
    
};

#endif /* defined(__GestureController__GestureControllerInterface__) */
