//==============================================================================
//
//  AudioMixerPlayer.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#ifndef __GestureController__AudioMixerPlayer__
#define __GestureController__AudioMixerPlayer__

#include "GestureControllerHeader.h"
#include "AudioFileStream.h"

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
    
    
    void loadAudioFile(int sampleID, String filePath);
    
    void setButtonMode(int sampleID, ButtonMode mode);
    ButtonMode getButtonMode(int sampleID);
    
    void startPlayback(int sampleID);
    void stopPlayback(int sampleID);
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void setParameter(int sampleID, int effectPosition, int parameterID, float value);
    float getParameter(int sampleID, int effectPosition, int parameterID);
    int getEffectType(int sampleID, int effectPosition);
    
    void setSmoothing(int sampleID, int effectPosition, int parameterID, float smoothing);
    
    void setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState);
    
    void beat(int beatNo);
    
    
    
private:
    
    AudioDeviceManager&                 deviceManager;
    
    MixerAudioSource                    audioMixer;
    OwnedArray<AudioFileStream>         audioFileStream;
    AudioSourcePlayer                   audioSourcePlayer;
    
    Array<ButtonMode>                   buttonModes;
    Array<bool>                         buttonStates;
    
};


#endif /* defined(__GestureController__AudioMixerPlayer__) */
