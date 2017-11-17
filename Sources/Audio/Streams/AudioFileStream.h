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
#include "BMConstants.h"

static const int64 kReadBufferSize  = 512;

class AudioFileStream   : public AudioSource
{
public:
    //==========================================================================
    
    AudioFileStream(int numChannels, bool shouldCreateWaveform, String threadName);
    ~AudioFileStream();
    
    //========= Track Methods =========//
    bool loadAudioFile(const File& audioFile);
    void setPlaybackSpeed(float speed);
    
    void startPlayback();
    void stopPlayback();
    bool isPlaying();
    float getNormalizedPlaybackProgress();
    float getTotalTime();
    
    void setPlaybackGain(float gain);
    float getPlaybackGain();
    
    void setPlaybackPan(float pan);
    float getPlaybackPan();
    
    void setPlaybackMode(BMPlaybackMode playbackMode);
    BMPlaybackMode getPlaybackMode();
    
    const float* getSamplesForWaveform();
    
    //========= Effect Methods =========//
    void setEffect(int slot, int effectID);
    int getEffect(int slot);
    
    void setEffectParameter(int slot, int parameterID, float value);
    float getEffectParameter(int slot, int parameterID);
    
    void setEffectEnable(int slot, bool enable);
    bool getEffectEnable(int slot);
    
    void setTempo(float tempo);
    void setShouldQuantizeTime(int slot, bool shouldQuantizeTime);
    
    
    //========= AudioSource =========//
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void getNextAudioBlock (const AudioSourceChannelInfo& bufferToFill) override;
    void releaseResources() override;
    
    
private:
    //===========================================================================
    
    void setShouldLoop(bool shouldLoop);
    bool getShouldLoop();
    float getRMSForBlock(const float* block, int64 length);
    
    TimeSliceThread                             _backgroundThread;
    AudioFormatManager                          _formatManager;
    AudioTransportSource                        _transportSource;
    ScopedPointer<AudioFormatReaderSource>      _formatReaderSource;
    
    OwnedArray<AudioEffect>                     _effects;
    Array<bool>                                 _effectsEnable;
    Array<int>                                  _effectIDs;
    
    ScopedPointer<BMStereo>                     _panner;
    
    float*                                      _waveformSamples;
    ScopedPointer<AudioSampleBuffer>            _readBuffer;
    
    int                                         _numChannels;
    
    BMPlaybackMode                              _playbackMode;
    bool                                        _shouldLoop;
    
    bool                                        _shouldCreateWaveform;
    bool                                        _isLoading;

    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (AudioFileStream)
};


#endif  // AUDIOFILESTREAM_H_INCLUDED
