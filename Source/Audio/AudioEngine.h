//==============================================================================
//
//  AudioEngine.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================



#ifndef __BeatMotion__AudioEngine__
#define __BeatMotion__AudioEngine__

#include "BeatMotionHeader.h"
#include "Macros.h"
//#include "LiveAudioStream.h"
#include "AudioFileRecord.h"
#include "AudioMixerPlayer.h"
#include "LoadPreset.h"
#include "Metronome2.h"
//#include "TrimAudio.h"

class AudioEngine
{
public:
    
    AudioEngine();
    ~AudioEngine();
    
    
//    void startLiveAudioStreaming();
//    void stopLiveAudioStreaming();
//    bool isLiveAudioRunning();
    
    int loadAudioFile(int sampleID, String filePath);
    void startPlayback(int sampleID);
    void stopPlayback(int sampleID);
    
    void setEffectParameter(int sampleID, int effectPosition, int parameterID, float value);
    float getEffectParameter(int sampleID, int effectPosition, int parameterID);
    int getEffectType(int sampleID, int effectPosition);
    
    void setSampleParameter(int sampleID, int parameterID, float value);
    float getSampleParameter(int sampleID, int parameterID);

    void setCurrentPresetBank(String presetBank);
    String  getCurrentPresetBank();
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void startRecordingAudioSample(int sampleID);
    void stopRecordingAudioSample(int sampleID);
    
    //--- Master Recording ---//
    void startRecordingMaster();
    void stopRecordingMaster();
    void saveCurrentRecording(String filename);
    int  getNumberOfUserRecordings();
    String getUserRecordingFileName(int index);
    void loadUserRecordedFile(int sampleID, int index);
    
    void toggleRecordingPlaybackSample(int sampleID, bool toggle);
    
    void setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle);
    void setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle);
    
    bool getSampleGestureControlToggle(int sampleID, int parameterID);
    bool getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID);
    
    float getSampleCurrentPlaybackTime(int sampleID);
    bool  getSamplePlaybackStatus(int sampleID);
    
    void beat(int beatNo);
    void setTempo(float newTempo);
    int getTempo();
    void startMetronome();
    void stopMetronome();
    bool getMetronomeStatus();
    
    void motionUpdate(float* motion);
    
    int loadFXPreset(String filepath);
    String getCurrentFXPack();
    
    float* getSamplesToDrawWaveform(int sampleID);
    
    void setButtonPagePosition(int sampleID, int position);
    int getButtonPagePosition(int sampleID);
    
    int getCurrentFXPackIndex();
    int getCurrentSampleBankIndex();
    int getCurrentSamplePackIndex();
    void setCurrentFXPackIndex(int index);
    void setCurrentSampleBankIndex(int index);
    
    float getMotionParameter(int sampleID, int effectPosition, int parameterID);
    
    void setPlayheadPosition(int sampleID, float position);
    
private:

    
//    ScopedPointer<LiveAudioStream>  liveAudioStream;
    
    ScopedPointer<AudioFileRecord>      audioFileRecorder;
    ScopedPointer<AudioMixerPlayer>     audioMixer;
    
    ScopedPointer<LoadPreset>           presetLoader;
//    ScopedPointer<TrimAudio>            audioTrimmer;
    
    ScopedPointer<Metronome2>           metronome;
    
    StringArray         recordingFilePathArray1;
    StringArray         recordingFilePathArray2;
    StringArray         playbackFilePathArray;
    Array<File>         userRecordingFiles;
    
    String              masterRecordingPath;
    String              userRecordingLibraryPath;
    String              currentRecordingPath1;
    String              currentRecordingPath2;
    String              currentPlaybackPath;
    
    bool                masterRecordingToggle;
    
    Array<int>         buttonPagePosition;
    
    
    AudioDeviceManager                      sharedAudioDeviceManager;
    AudioDeviceManager::AudioDeviceSetup    deviceSetup;
    
    bool m_bLiveAudioThreadRunning;
    
    String              currentPresetBank;
    String              currentFXPack;
    
    int                 m_iCurrentPresetBankLoaded;
    int                 m_iCurrentFXPackLoaded;
    
    
};

#endif /* defined(__BeatMotion__AudioEngine__) */
