/*
  ==============================================================================

    AudioController.h
    Created: 1 Feb 2016 2:52:55am
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef AUDIOCONTROLLER_H_INCLUDED
#define AUDIOCONTROLLER_H_INCLUDED

#include "JuceHeader.h"
#include "BMConstants.h"
#include "AudioFileStream.h"
#include "AudioFileRecord.h"

class AudioController   : public AudioIODeviceCallback
{
    
public:
    //==========================================================================
    
    
    //============================================
    // Init Methods
    //============================================
    AudioController();
    ~AudioController();
    
    int openSession();
    int closeSession();
    
    
    //============================================
    // Audio Track Methods
    //============================================
    bool loadAudioFileIntoTrack(String filepath, int track);
    void setPlaybackSpeedOfTrack(float speed, int track);
    
    void startPlaybackOfTrack(int track);
    void stopPlaybackOfTrack(int track);
    bool isTrackPlaying(int track);
    float getNormalizedPlaybackProgress(int track);
    float getTotalTimeOfTrack(int track);
    
    void setTrackGain(int track, float gain);
    float getTrackGain(int track);
    
    void setTrackPan(int track, float pan);
    float getTrackPan(int track);
    
    void setPlaybackModeOfTrack(int track, BMPlaybackMode mode);
    BMPlaybackMode getPlaybackModeOfTrack(int track);
    
    bool startRecordingAtTrack(int track, String filepath);
    void stopRecordingAtTrack(int track);
    bool isTrackRecording(int track);
    
    const float* getSamplesForWaveformAtTrack(int track);
    
    
    //============================================
    // Audio Master Track Methods
    //============================================
    void startRecordingMaster(String filepath);
    void stopRecordingMaster();
    
    
    //============================================
    // Audio Effect Methods
    //============================================
    void setEffect(int track, int slot, int effectID);
    int getEffect(int track, int slot);
    
    void setEffectParameter(int track, int slot, int parameterID, float value);
    float getEffectParameter(int track, int slot, int parameterID);
    
    void setEffectEnable(int track, int slot, bool enable);
    bool getEffectEnable(int track, int slot);
    
    void setTempo(float tempo);
    void setShouldQuantizeTime(int track, int slot, bool shouldQuantizeTime);
    
    
    //============================================
    // AudioIODeviceCallback
    //============================================
    void audioDeviceIOCallback (const float** inputChannelData,
                                int totalNumInputChannels,
                                float** outputChannelData,
                                int totalNumOutputChannels,
                                int numSamples) override;
    
    void audioDeviceAboutToStart (AudioIODevice* device) override;

    void audioDeviceStopped() override;
    
    
private:
    //=========================================================================
    
    AudioDeviceManager                               _deviceManager;
    float                                           _sampleRate;
    int                                             _numSamplesPerBlock;
    
    OwnedArray<AudioFileStream>                     _streams;
    ScopedPointer<MixerAudioSource>                 _mixerSource;
    ScopedPointer<BMLimiter>                        _limiter;
    
    OwnedArray<AudioFileRecord>                     _recorders;
    ScopedPointer<AudioFileRecord>                  _masterRecorder;
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (AudioController)
};



#endif  // AUDIOCONTROLLER_H_INCLUDED
