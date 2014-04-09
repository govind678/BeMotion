//==============================================================================
//
//  AudioFileStream.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================

#ifndef __GestureController__AudioFileStream__
#define __GestureController__AudioFileStream__

#include "GestureControllerHeader.h"
#include "Macros.h"

#include "AudioEffectSource.h"


class AudioFileStream        :   public AudioSource
{
    
public:
    
    AudioFileStream(int sampleID, AudioDeviceManager& deviceManager);
    ~AudioFileStream();
    
    
    void loadAudioFile(String audioFilePath);
    
    void prepareToPlay(int samplesPerBlockExpected, double sampleRate) override;
    void getNextAudioBlock (const AudioSourceChannelInfo& audioSourceChannelInfo) override;
    void releaseResources() override;
    
    void processAudioBlock(float** audioBuffer, int numSamples);
    
    
    void startPlayback();
    void stopPlayback();
    void setLooping(bool looping);
    
    bool isPlaying();
    
    void setMode(ButtonMode mode);
    ButtonMode getMode();
    
    void addAudioEffect(int effectPosition, int effectID);
    void removeAudioEffect(int effectPosition);
    void setAudioEffectBypassState(int effectPosition, bool bypassState);
    
    void setParameter(int effectPosition, int parameterID, float value);
    
    float getParameter(int effectPosition, int parameterID);
    int   getEffectType(int effectPosition);

    void setSmoothing(int effecPosition, int parameterID, float value);
    
    
private:
    
    AudioDeviceManager&     deviceManager;
    
    AudioFormatManager      formatManager;
    AudioTransportSource    transportSource;
    ScopedPointer<AudioFormatReaderSource> currentAudioFileSource;
    
    OwnedArray<AudioEffectSource>   audioEffectSource;
    Array<bool>                     m_pbBypassStateArray;
    
    TimeSliceThread thread;
    
    int m_iSampleID;
    String  m_sCurrentFilePath;
    bool m_bAudioCurrentlyPlaying;
    
    ButtonMode                  m_eButtonMode;
    
    
};

#endif /* defined(__GestureController__AudioFileStream__) */
