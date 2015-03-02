//==============================================================================
//
//  AudioFileStream.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================

#ifndef __BeatMotion__AudioFileStream__
#define __BeatMotion__AudioFileStream__

#include "BeatMotionHeader.h"
#include "Macros.h"

#include "AudioEffectSource.h"
#include "Limiter.h"
#include "Parameter.h"
#include "AudioFeatureExtraction.h"

#define GAIN_SCALE      0.4f


class AudioFileStream        :   public AudioSource
{
    
public:
    
    AudioFileStream(int sampleID);
    ~AudioFileStream();
    
    
    int loadAudioFile(String audioFilePath);
    
    void prepareToPlay(int samplesPerBlockExpected, double sampleRate) override;
    void getNextAudioBlock (const AudioSourceChannelInfo& audioSourceChannelInfo) override;
    void releaseResources() override;
    
    void processAudioBlock(float** audioBuffer, int numSamples);
    
    
    void startPlayback();
    void stopPlayback();
    
    bool isPlaying();
    
    void addAudioEffect(int effectPosition, int effectID);
    void removeAudioEffect(int effectPosition);
    void setAudioEffectBypassState(int effectPosition, bool bypassState);
    
    void setEffectParameter(int effectPosition, int parameterID, float value);
    void setSampleParameter(int parameterID, float value);
    
    float getEffectParameter(int effectPosition, int parameterID);
    float getSampleParameter(int parameterID);
    
    void setSampleGestureControlToggle(int parameterID, bool toggle);
    void setEffectGestureControlToggle(int effectPosition, int parameterID, bool toggle);
    
    bool getSampleGestureControlToggle(int parameterID);
    bool getEffectGestureControlToggle(int effectPosition, int parameterID);
    
    int  getEffectType(int effectPosition);
    
    float getCurrentPlaybackTime();

    void setSmoothing(int effecPosition, int parameterID, float value);

    void beat(int beatNum);
    
    void motionUpdate(float* motion);
    float getMotionParameter(int effectPosition, int parameterID);
    
    void setPlayheadPosition(float position);
    
    
    //--- Metronome ---//
    void setTempo(float newTempo);
    void startClock();
    void stopClock();
    
    float* getSamplesToDrawWaveform();
    
    
private:
    
    void setLooping(bool looping);
    
    void internal_startPlayback();
    
    AudioFormatManager              formatManager;
    AudioTransportSource            transportSource;
    ScopedPointer<AudioFormatReaderSource> currentAudioFileSource;
    
//    AudioSampleBuffer               firstAudioBlock;
    
    OwnedArray<AudioEffectSource>   audioEffectSource;
    Array<bool>                     m_pbBypassStateArray;
    Array<bool>                     audioEffectInitialized;
    
    Array<bool>                     m_pbGestureControl;

    ScopedPointer<CLimiter>         m_pcLimiter;
    ScopedPointer<AudioFeatureExtraction>   m_pcAudioFeature;
    
    TimeSliceThread thread;
    
    OwnedArray<Parameter>           m_pcParameter;

    
    int                             m_iSampleID;
    float                           m_fSampleRate;
    String                          m_sCurrentFilePath;
    
    bool                            m_bAudioCurrentlyPlaying;
    bool                            m_bPlayingFromMemory;
    int                             m_iSamplesRead;
    
    int                             m_iQuantization;
    int                             m_iButtonMode;
    
    int                             m_iBeat;
    float                           m_fGain;
    
    float                           m_fStartPoint_s;
    Array<float>                    m_pfWaveformArray;
    
    
    //--- Metronome ---//
    float                           m_fTempo;
    int64                           m_iSampleCount;
    bool                            m_bMetronomeStatus;
    int64                           m_iSampleLength;
    int                             m_iBeatLength;
    
};

#endif /* defined(__BeatMotion__AudioFileStream__) */
