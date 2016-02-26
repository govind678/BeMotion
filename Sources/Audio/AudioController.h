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
    int loadAudioFileIntoTrack(String filepath, int track);
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
    
    void saveMicRecordingForTrack(String filepath, int track);
    void startRecordingAtTrack(int track);
    void stopRecordingAtTrack(int track);
    bool isTrackRecording(int track);
    void loadRecordedFileIntoTrack(int track);
    
    float* getSamplesForWaveformAtTrack(int track);
    
    
    //============================================
    // Audio Master Track Methods
    //============================================
    void startRecordingMaster();
    void stopRecordingMaster();
    bool saveMasterRecording(String filepath);
    
    
    //============================================
    // Audio Effect Methods
    //============================================
    void setEffect(int track, int slot, int effectID);
    int getEffect(int track, int slot);
    
    void setEffectParameter(int track, int slot, int parameterID, float value);
    float getEffectParameter(int track, int slot, int parameterID);
    
    void setEffectEnable(int track, int slot, bool enable);
    bool getEffectEnable(int track, int slot);
    
    
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
    
    AudioDeviceManager                          _deviceManager;
    float                                       _sampleRate;
    int                                         _numSamplesPerBlock;
    
    OwnedArray<AudioFileStream>                 _streams;
    ScopedPointer<MixerAudioSource>             _mixerSource;
    
    OwnedArray<AudioFileRecord>                 _recorders;
    StringArray                                 _recorderPaths;
    Array<bool>                                 _recorderPathToggles;
    
    ScopedPointer<AudioFileRecord>              _masterRecorder;
    File                                        _tempMasterFile;
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (AudioController)
};



#endif  // AUDIOCONTROLLER_H_INCLUDED
