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
    
    void setParameter(int sampleID, int effectPosition, int parameterID, float value);
    float getParameter(int sampleID, int effectPosition, int parameterID);
    int getEffectType(int sampleID, int effectPosition);
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void startRecordingAudioSample(int sampleID);
    void stopRecordingAudioSample(int sampleID);
    
private:
    
//    ScopedPointer<LiveAudioStream>  liveAudioStream;
    
    ScopedPointer<AudioFileRecord>      audioFileRecorder;
    ScopedPointer<AudioMixerPlayer>     audioMixer;
    
    Array<String>       recordingFilePathArray;
    Array<String>       playbackFilePathArray;
    
    
    String  currentRecordingPath;
    String  currentPlaybackPath;
    
    AudioDeviceManager sharedAudioDeviceManager;
    
    bool m_bLiveAudioThreadRunning;
    
    
};

#endif /* defined(__GestureController__AudioEngine__) */
