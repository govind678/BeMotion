/*
  ==============================================================================

    AudioFileStream.h
    Created: 1 Feb 2016 11:23:58am
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef AUDIOFILESTREAM_H_INCLUDED
#define AUDIOFILESTREAM_H_INCLUDED

#include "JuceHeader.h"
#include "AudioEffect.h"
#include "BMLimiter.h"
#include "BMStereo.h"

static const int64 kNumWaveformSamples = 2000;

class AudioFileStream   : public AudioSource
{
public:
    //==========================================================================
    
    AudioFileStream(int numChannels);
    ~AudioFileStream();
    
    //========= Track Methods =========//
    int loadAudioFile(const File& audioFile);
    void setPlaybackSpeed(float speed);
    
    void startPlayback();
    void stopPlayback();
    float getNormalizedPlaybackProgress();
    
    void setPlaybackGain(float gain);
    float getPlaybackGain();
    
    void setPlaybackPan(float pan);
    float getPlaybackPan();
    
    float* getSamplesForWaveform();
    
    
    //========= Effect Methods =========//
    void setEffect(int slot, int effectID);
    int getEffect(int slot);
    
    void setEffectParameter(int slot, int parameterID, float value);
    float getEffectParameter(int slot, int parameterID);
    
    void setEffectEnable(int slot, bool enable);
    bool getEffectEnable(int slot);
    
    
    //========= AudioSource =========//
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void getNextAudioBlock (const AudioSourceChannelInfo& bufferToFill) override;
    void releaseResources() override;
    
    
private:
    //===========================================================================
    
    TimeSliceThread                             _thread;
    AudioFormatManager                          _formatManager;
    AudioTransportSource                        _transportSource;
    ScopedPointer<AudioFormatReaderSource>      _formatReaderSource;
    
    OwnedArray<AudioEffect>                     _effects;
    Array<bool>                                 _effectsEnable;
    Array<int>                                  _effectIDs;
    
    ScopedPointer<BMLimiter>                    _limiter;
    ScopedPointer<BMStereo>                     _panner;
    
    float                                       _waveformSamples[kNumWaveformSamples];
    
    int                                         _numChannels;

    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (AudioFileStream)
};


#endif  // AUDIOFILESTREAM_H_INCLUDED
