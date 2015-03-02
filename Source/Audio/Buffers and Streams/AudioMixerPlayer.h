//==============================================================================
//
//  AudioMixerPlayer.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/9/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================


#ifndef __BeatMotion__AudioMixerPlayer__
#define __BeatMotion__AudioMixerPlayer__

#include "BeatMotionHeader.h"
#include "AudioFileStream.h"
#include "Limiter.h"
#include "AudioFileRecord.h"

class AudioMixerPlayer  :   public AudioIODeviceCallback
{
    
public:
    
    AudioMixerPlayer(AudioDeviceManager& sharedDeviceManager);
    ~AudioMixerPlayer();
    
    
    void audioDeviceIOCallback(const float** inputChannelData,
							   int totalNumInputChannels,
							   float** outputChannelData,
							   int totalNumOutputChannels,
							   int blockSize) override;
	
	void audioDeviceAboutToStart (AudioIODevice* device) override;
    void audioDeviceStopped() override;
    
    
    int loadAudioFile(int sampleID, String filePath);
    
    void startPlayback(int sampleID);
    void stopPlayback(int sampleID);
    
    void startRecordingOutput(String filePath);
    void stopRecordingOutput();
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void setEffectParameter(int sampleID, int effectPosition, int parameterID, float value);
    float getEffectParameter(int sampleID, int effectPosition, int parameterID);
    int getEffectType(int sampleID, int effectPosition);
    
    void setSampleParameter(int sampleID, int parameterID, float value);
    float getSampleParameter(int sampleID, int parameterID);
    
    void setSmoothing(int sampleID, int effectPosition, int parameterID, float smoothing);
    
    void setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState);
    
    
    void setSampleGestureControlToggle(int sampleID, int parameterID, bool toggle);
    void setEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID, bool toggle);
    
    bool getSampleGestureControlToggle(int sampleID, int parameterID);
    bool getEffectGestureControlToggle(int sampleID, int effectPosition, int parameterID);

    float getSampleCurrentPlaybackTime(int sampleID);
    bool  getSamplePlaybackStatus(int sampleID);
    
    float getMotionParameter(int sampleID, int effectPosition, int parameterID);
    
    void setPlayheadPosition(int sampleID, float position);
    
    
    void beat(int beatNo);
    
    void motionUpdate(float* motion);
    
    void setTempo(float newTempo);
    float getTempo();
    void startClock();
    void stopClock();
    
    float* getSamplesToDrawWaveform(int sampleID);
    
    
private:
    
    AudioDeviceManager&                 deviceManager;
    
    MixerAudioSource                    audioMixer;
    OwnedArray<AudioFileStream>         audioFileStream;
    AudioSourcePlayer                   audioSourcePlayer;
    
    ScopedPointer<CLimiter>             m_pcLimiter;
    
    ScopedPointer<AudioFileRecord>      m_pcAudioFileRecorder;
    
    bool                                m_bRecording;
    
    float                               m_fTempo;
    
    Time                                m_cTime;
};


#endif /* defined(__BeatMotion__AudioMixerPlayer__) */
