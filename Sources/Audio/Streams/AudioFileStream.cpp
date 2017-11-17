/*
  ==============================================================================

    AudioFileStream.cpp
    Created: 1 Feb 2016 11:23:58am
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "AudioFileStream.h"

#include "BMWah.h"
#include "BMTremolo.h"
#include "BMVibrato.h"
#include "BMDelay.h"
#include "BMGranularizer.h"
#include "BMLowpass.h"

#include <math.h>


static const float kGainScaleExponent = 2.0f;
static const float kSamplesToBufferAhead = 32768;


AudioFileStream::AudioFileStream(int numChannels, bool shouldCreateWaveform, String threadName)  : _backgroundThread(threadName)
{
    _numChannels = numChannels;
    _shouldCreateWaveform = shouldCreateWaveform;
    
    _transportSource.setSource(nullptr);
    _formatManager.registerBasicFormats();
    
    _panner  = new BMStereo();
    
    for (int i = 0; i < kNumEffectsPerTrack; i++)
    {
        _effects.add(nullptr);
        _effectIDs.add(0);
        _effectsEnable.add(false);
    }
    
    _shouldLoop = true;
    
    _waveformSamples = nullptr;
    if (_shouldCreateWaveform) {
        _waveformSamples = new float[kNumWaveformSamples];
        _readBuffer = new AudioSampleBuffer(1, kReadBufferSize);
    }
    
    _isLoading = false;
    
    _backgroundThread.startThread(10);
}

AudioFileStream::~AudioFileStream()
{
    if (_shouldCreateWaveform) {
        delete [] _waveformSamples;
    }
    _waveformSamples = nullptr;
    _readBuffer = nullptr;
    
    _backgroundThread.stopThread(1000);
    _effects.clear();
    _effectsEnable.clear();
    _effectIDs.clear();
    _transportSource.stop();
    _transportSource.releaseResources();
    _transportSource.setSource(nullptr);
    _formatReaderSource  = nullptr;
    _panner  = nullptr;
}


//==============================================================================
// Audio Track Methods
//==============================================================================

bool AudioFileStream::loadAudioFile(const File &audioFile)
{
    bool success    = false;
    _isLoading      = true;
    
    _transportSource.stop();
    _transportSource.setSource(nullptr);
    
    _formatReaderSource  =   nullptr;
    
    AudioFormatReader* reader = _formatManager.createReaderFor(audioFile);
    
    if (reader != nullptr)
    {
        _formatReaderSource = new AudioFormatReaderSource(reader, true);
        _formatReaderSource->setLooping(_shouldLoop);
        _transportSource.setSource(_formatReaderSource,
                                   kSamplesToBufferAhead,             // tells it to buffer this many samples ahead
                                   &_backgroundThread,               // this is the background thread to use for reading-ahead
                                   reader->sampleRate);             // allows for sample rate correction)
        
        if (_shouldCreateWaveform) {
            // Read Entire File and Store Reduced Set To Draw Waveform
            int64 samplesPerBin = int64(ceilf(reader->lengthInSamples / kNumWaveformSamples));
            if (samplesPerBin > kNumWaveformSamples) {
                samplesPerBin = kNumWaveformSamples;
            }
            for (int64 i=0; i < kNumWaveformSamples; i++) {
                reader->read(_readBuffer, 0, int(samplesPerBin), (i * samplesPerBin), true, false);
                _waveformSamples[i] = getRMSForBlock(_readBuffer->getReadPointer(0), samplesPerBin);
            }
        }
        
        success = true;
    }
    
    _isLoading = false;
    return success;
}

void AudioFileStream::setPlaybackSpeed(float speed)
{
    
}


void AudioFileStream::startPlayback()
{
    _transportSource.setPosition(0.0f);
    _transportSource.start();
}

void AudioFileStream::stopPlayback()
{
    _transportSource.stop();
    
    for (int i=0; i < _effects.size(); i++)
    {
        if (_effectsEnable.getUnchecked(i))
        {
            _effects.getUnchecked(i)->reset();
        }
    }
}

bool AudioFileStream::isPlaying()
{
    return _transportSource.isPlaying();
}

float AudioFileStream::getNormalizedPlaybackProgress()
{
    if (_transportSource.getLengthInSeconds() == 0.0f) {
        return 0.0f;
    } else {
        return (_transportSource.getCurrentPosition() / _transportSource.getLengthInSeconds());
    }
}

float AudioFileStream::getTotalTime()
{
    return _transportSource.getLengthInSeconds();
}

void AudioFileStream::setPlaybackGain(float gain)
{
    float scaled = powf(gain, kGainScaleExponent);
    _transportSource.setGain(scaled);
}

float AudioFileStream::getPlaybackGain()
{
    return powf(_transportSource.getGain(), 1.0f/kGainScaleExponent);
}

void AudioFileStream::setPlaybackPan(float pan)
{
    _panner->setParameter(0, pan);
}

float AudioFileStream::getPlaybackPan()
{
    return _panner->getParameter(0);
}

void AudioFileStream::setShouldLoop(bool shouldLoop)
{
    _shouldLoop = shouldLoop;
    if (_formatReaderSource) {
        _formatReaderSource->setLooping(_shouldLoop);
    }
}

bool AudioFileStream::getShouldLoop()
{
    return _shouldLoop;
}

void AudioFileStream::setPlaybackMode(BMPlaybackMode playbackMode)
{
    _playbackMode = playbackMode;
    
    switch (_playbackMode) {
        case BMPlaybackMode_Loop:
        case BMPlaybackMode_BeatRepeat:
            setShouldLoop(true);
            break;
        
        case BMPlaybackMode_OneShot:
            setShouldLoop(false);
            break;
            
        default:
            break;
    }
}

BMPlaybackMode AudioFileStream::getPlaybackMode()
{
    return _playbackMode;
}

const float* AudioFileStream::getSamplesForWaveform()
{
    return _waveformSamples;
}

//==============================================================================
// Audio Effect Methods
//==============================================================================

void AudioFileStream::setEffect(int slot, int effectID)
{
    _effectsEnable.set(slot, false);
    
    switch (effectID) {
        case Wah:
            _effects.set(slot, new BMWah(_numChannels));
            _effectsEnable.set(slot, true);
            break;
        case Tremolo:
            _effects.set(slot, new BMTremolo(_numChannels));
            _effectsEnable.set(slot, true);
            break;
        case Vibrato:
            _effects.set(slot, new BMVibrato(_numChannels));
            _effectsEnable.set(slot, true);
            break;
        case Delay:
            _effects.set(slot, new BMDelay(_numChannels));
            _effectsEnable.set(slot, true);
            break;
        case Granularizer:
            _effects.set(slot, new BMGranularizer(_numChannels));
            _effectsEnable.set(slot, true);
            break;
        case Lowpass:
            _effects.set(slot, new BMLowpass(_numChannels));
            _effectsEnable.set(slot, true);
            break;
        case None:
            _effects.set(slot, nullptr);
            _effectsEnable.set(slot, false);
            break;
            
        default:
            break;
    }
    
    _effectIDs.set(slot, effectID);
}


int AudioFileStream::getEffect(int slot)
{
    return _effectIDs.getUnchecked(slot);
}

void AudioFileStream::setEffectParameter(int slot, int parameterID, float value)
{
    if (_effectIDs.getUnchecked(slot) > 0)
        _effects.getUnchecked(slot)->setParameter(parameterID, value);
}

float AudioFileStream::getEffectParameter(int slot, int parameterID)
{
    if (_effectIDs.getUnchecked(slot) > 0)
        return _effects.getUnchecked(slot)->getParameter(parameterID);
    else
        return 0.0f;
}


void AudioFileStream::setEffectEnable(int slot, bool enable)
{
    if (_effectIDs.getUnchecked(slot) > 0)
        _effectsEnable.set(slot, enable);
}

bool AudioFileStream::getEffectEnable(int slot)
{
    if (_effectIDs.getUnchecked(slot) > 0)
        return _effectsEnable.getUnchecked(slot);
    else
        return false;
}

void AudioFileStream::setTempo(float tempo)
{
    for (int i=0; i < kNumEffectsPerTrack; i++) {
        if (_effectIDs.getUnchecked(i) > 0)
            _effects.getUnchecked(i)->setTempo(tempo);
    }
}

void AudioFileStream::setShouldQuantizeTime(int slot, bool shouldQuantizeTime)
{
    if (_effectIDs.getUnchecked(slot) > 0)
        _effects.getUnchecked(slot)->setShouldQuantizeTime(shouldQuantizeTime);
}


//==============================================================================
// AudioSource
//==============================================================================

void AudioFileStream::prepareToPlay (int samplesPerBlockExpected, double sampleRate)
{
    _transportSource.prepareToPlay(samplesPerBlockExpected, sampleRate);
    
    for (int i=0; i < _effects.size(); i++)
    {
        if (_effectsEnable.getUnchecked(i))
        {
            _effects.getUnchecked(i)->prepareToPlay(samplesPerBlockExpected, sampleRate);
        }
    }
}

void AudioFileStream::getNextAudioBlock (const AudioSourceChannelInfo& bufferToFill)
{
    if (_isLoading) {
        return;
    }

    //-- Read from Transport Source --//
    _transportSource.getNextAudioBlock(bufferToFill);
    
    //-- Apply Audio Effects --//
    for (int i=0; i < _effects.size(); i++)
    {
        if (_effectsEnable.getUnchecked(i))
        {
            _effects.getUnchecked(i)->process(bufferToFill.buffer->getArrayOfWritePointers(),
                                              bufferToFill.buffer->getNumChannels(),
                                              bufferToFill.numSamples);
        }
    }
    
    //-- Stereo Panning --//
    _panner->process(bufferToFill.buffer->getArrayOfWritePointers(), bufferToFill.buffer->getNumChannels(), bufferToFill.numSamples);
}

void AudioFileStream::releaseResources()
{
    _transportSource.releaseResources();
    
    for (int i=0; i < _effects.size(); i++)
    {
        if (_effectsEnable.getUnchecked(i))
        {
            _effects.getUnchecked(i)->releaseResources();
        }
    }
}


//==============================================================================
// Utility
//==============================================================================

float AudioFileStream::getRMSForBlock(const float* block, int64 length)
{
    float sum = 0.0f;
    for (int64 i=0; i < length; i++) {
        sum += (block[i] * block[i]);
    }
    return sqrtf(sum / length);
}
