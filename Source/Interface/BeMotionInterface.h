//==============================================================================
//
//  BeMotionInterface.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#ifndef __BeMotion__BeMotionInterface__
#define __BeMotion__BeMotionInterface__


#include "AudioEngine.h"

class BeMotionInterface
{
public:
    
    BeMotionInterface();
    ~BeMotionInterface();
    
    
    //============== GUI to Backend Methods ==================
    int loadAudioFile(int sampleID, NSString* filepath);
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void setEffectParameter(int sampleID, int effectPosition, int parameterID, float value);
    void setSampleParameter(int sampleID, int parameterID, float value);
    
    void startPlayback(int sampleID);
    void stopPlayback(int sampleID);
    
    void startRecording(int sampleID);
    void stopRecording(int sampleID);
    
    void startRecordingOutput(int sampleID);
    void stopRecordingOutput(int sampleID);
    
    void setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle);
    void setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle);
    
    void beat(int beatNo);
    void setTempo(float newTempo);
    void startMetronome();
    void stopMetronome();
    
    void setCurrentSampleBank(NSString* presetBank);
    
    void motionUpdate(float* motion);
    
    int loadFXPreset(NSString* filepath);
    
    void setSettingsToggle(bool toggle);
    //========================================================
    

    //============== Backend to GUI Methods ==================
    int getEffectType(int sampleID, int effectPosition);
    
    NSString* getCurrentSampleBank();
    NSString* getCurrentFXPack();
    
    float getEffectParameter(int sampleID, int effectPosition, int parameterID);
    float getSampleParameter(int sampleID, int parameterID);
    
    bool getSampleGestureControlToggle(int sampleID, int parameterID);
    bool getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID);
    
    float getSampleCurrentPlaybackTime(int sampleID);
    bool  getSamplePlaybackStatus(int sampleID);
    
    bool getSettingsToggle();
    
    float* getSamplesToDrawWaveform(int sampleID);
    
    bool getMetronomeStatus();
    //========================================================
    
    
    // TODO: Implement Parameter Scaling
    
    
    
private:
    
    AudioEngine*    audioEngine;
    
    bool            m_bSettingsToggle;
    
};

#endif /* defined(__BeMotion__BeMotionInterface__) */
