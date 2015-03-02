//==============================================================================
//
//  BeatMotionInterface.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================



#ifndef __BeatMotion__BeatMotionInterface__
#define __BeatMotion__BeatMotionInterface__


#include "AudioEngine.h"

class BeatMotionInterface
{
public:
    
    BeatMotionInterface();
    ~BeatMotionInterface();
    
    
    //============== GUI to Backend Methods ==================
    int loadAudioFile(int sampleID, NSString* filepath);
    void loadUserRecordedFile(int sampleID, int index);
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void setEffectParameter(int sampleID, int effectPosition, int parameterID, float value);
    void setSampleParameter(int sampleID, int parameterID, float value);
    
    void startPlayback(int sampleID);
    void stopPlayback(int sampleID);
    
    void startRecording(int sampleID);
    void stopRecording(int sampleID);
    
    void startRecordingOutput();
    void stopRecordingOutput();
    void saveCurrentRecording(NSString* filename);
    
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
    void setButtonPagePosition(int sampleID, int position);
    
    void setPlayheadPosition(int sampleID, float position);
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
    
    int getNumberOfUserRecordings();
    NSString* getUserRecordingFileName(int index);
    
    bool getMetronomeStatus();
    int  getTempo();
    
    int getButtonPagePosition(int sampleID);
    
    float getMotionParameter(int sampleID, int effectPosition, int parameterID);
    //========================================================
    
    
    // TODO: Implement Parameter Scaling
    int getCurrentFXPackIndex();
    int getCurrentSampleBankIndex();
    void setCurrentFXPackIndex(int index);
    void setCurrentSampleBankIndex(int index);
    
    
private:
    
    AudioEngine*    audioEngine;
    
    bool            m_bSettingsToggle;
    
};

#endif /* defined(__BeatMotion__BeatMotionInterface__) */
