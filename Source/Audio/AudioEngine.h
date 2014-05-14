//==============================================================================
//
//  AudioEngine.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#ifndef __GestureController__AudioEngine__
#define __GestureController__AudioEngine__

#include "GestureControllerHeader.h"
#include "Macros.h"
#include "LiveAudioStream.h"
#include "AudioFileRecord.h"
#include "AudioMixerPlayer.h"

class AudioEngine
{
public:
    
    AudioEngine();
    ~AudioEngine();
    
    
    void startLiveAudioStreaming();
    void stopLiveAudioStreaming();
    bool isLiveAudioRunning();
    
    void loadAudioFile(int sampleID, String filePath);
    void startPlayback(int sampleID);
    void stopPlayback(int sampleID);
    
    void setEffectParameter(int sampleID, int effectPosition, int parameterID, float value);
    float getEffectParameter(int sampleID, int effectPosition, int parameterID);
    int getEffectType(int sampleID, int effectPosition);
    
    void setSampleParameter(int sampleID, int parameterID, float value);
    float getSampleParameter(int sampleID, int parameterID);

    void setCurrentPresetBank(int presetBank);
    int  getCurrentPresetBank();
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void startRecordingAudioSample(int sampleID);
    void stopRecordingAudioSample(int sampleID);
    
    void startRecordingMaster(int sampleID);
    void stopRecordingMaster(int sampleID);
    
    void toggleRecordingPlaybackSample(int sampleID, bool toggle);
    
    void setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle);
    void setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle);
    
    bool getSampleGestureControlToggle(int sampleID, int parameterID);
    bool getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID);
    
    float getSampleCurrentPlaybackTime(int sampleID);
    bool  getSamplePlaybackStatus(int sampleID);
    
    void beat(int beatNo);
    void setTempo(float newTempo);
    
    void motionUpdate(float* motion);
    
    
private:

    
//    ScopedPointer<LiveAudioStream>  liveAudioStream;
    
    ScopedPointer<AudioFileRecord>      audioFileRecorder;
    ScopedPointer<AudioMixerPlayer>     audioMixer;
    
    StringArray         recordingFilePathArray1;
    StringArray         recordingFilePathArray2;
    StringArray         playbackFilePathArray;
    
    
    String              currentRecordingPath1;
    String              currentRecordingPath2;
    String              currentPlaybackPath;
    
    Array<bool>         m_pbRecordingToggle;
    
    
    AudioDeviceManager sharedAudioDeviceManager;
    
    bool m_bLiveAudioThreadRunning;
    int  m_iCurrentPresetBankLoaded;
    
};

#endif /* defined(__GestureController__AudioEngine__) */
