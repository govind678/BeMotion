//==============================================================================
//
//  LiveAudioStream.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/7/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#ifndef __BeMotion__AudioStream__
#define __BeMotion__AudioStream__

#include "BeMotionHeader.h"
#include "AudioEffectSource.h"

class LiveAudioStream   :   public AudioIODeviceCallback
{
    
public:
    
    
    LiveAudioStream(AudioDeviceManager& sharedDeviceManager);
    ~LiveAudioStream();
    
    
    void audioDeviceIOCallback(const float** inputChannelData,
							   int totalNumInputChannels,
							   float** outputChannelData,
							   int totalNumOutputChannels,
							   int blockSize) override;
	
	void audioDeviceAboutToStart (AudioIODevice* device) override;
    void audioDeviceStopped() override;
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    void setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState);
    
    void setParameter(int sampleID, int effectID, int parameterID, float value);
    
private:
    
    AudioDeviceManager&                         deviceManager;
    AudioDeviceManager::AudioDeviceSetup        deviceSetup;
    
    OwnedArray<AudioEffectSource>   audioEffectSource;
    Array<bool>                     m_pbBypassStateArray;
    

};

#endif /* defined(__BeMotion__LiveAudioStream__) */
