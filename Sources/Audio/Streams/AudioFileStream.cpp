/*
  ==============================================================================

    AudioFileStream.cpp
    Created: 1 Feb 2016 11:23:58am
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "AudioFileStream.h"

#include "BMFilter.h"
#include "BMTremolo.h"
#include "BMVibrato.h"
#include "BMDelay.h"
#include "BMGranularizer.h"
#include "BMConstants.h"

AudioFileStream::AudioFileStream(int numChannels)  : _thread("file stream")
{
    _numChannels = numChannels;
    
    _transportSource.setSource(nullptr);
    _formatManager.registerBasicFormats();
    
    _limiter = new BMLimiter(numChannels);
    _panner  = new BMStereo();
    
    for (int i = 0; i < kNumEffectsPerTrack; i++)
    {
        _effects.add(nullptr);
        _effectIDs.add(0);
        _effectsEnable.add(false);
    }
    
    _thread.startThread(3);
}

AudioFileStream::~AudioFileStream()
{
    _effects.clear();
    _effectsEnable.clear();
    _effectIDs.clear();
    _transportSource.setSource(nullptr);
    _formatReaderSource  = nullptr;
    _limiter = nullptr;
    _panner  = nullptr;
    _thread.stopThread(20);
}


//==============================================================================
// Audio Track Methods
//==============================================================================

int AudioFileStream::loadAudioFile(const File &audioFile)
{
    _transportSource.stop();
    _transportSource.setSource(nullptr);
    
    _formatReaderSource  =   nullptr;
    
    AudioFormatReader* reader = _formatManager.createReaderFor(audioFile);
    
    if (reader != nullptr)
    {
        _formatReaderSource = new AudioFormatReaderSource(reader, true);
        _formatReaderSource->setLooping(true);
        _transportSource.setSource(_formatReaderSource,
                                   32768,                   // tells it to buffer this many samples ahead
                                   &_thread,                // this is the background thread to use for reading-ahead
                                   reader->sampleRate);     // allows for sample rate correction)
        
        
        
        // Read Entire File and Store Reduced Set To Draw Waveform
/*
        int64 samplesPerBin = reader->lengthInSamples / kNumWaveformSamples;
        int64 index = 0;

        for (int64 i=0; i < reader->lengthInSamples; i += samplesPerBin) {

            float leftMax, rightMax, leftMin, rightMin;
            reader->readMaxLevels(i, samplesPerBin, leftMin, leftMax, rightMin, rightMax);
            _waveformSamples[index] = (leftMax + rightMax) / 2.0f;
            index++;
        }
*/        
        
        
        return 0;
    }
    
    else
    {
        return 1;
    }
    
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
}

float AudioFileStream::getNormalizedPlaybackProgress()
{
    if (_transportSource.getLengthInSeconds() == 0.0f) {
        return 0.0f;
    } else {
        return (_transportSource.getCurrentPosition() / _transportSource.getLengthInSeconds());
    }
}


void AudioFileStream::setPlaybackGain(float gain)
{
    _transportSource.setGain(gain);
}

float AudioFileStream::getPlaybackGain()
{
    return _transportSource.getGain();
}

void AudioFileStream::setPlaybackPan(float pan)
{
    _panner->setParameter(0, pan);
}

float AudioFileStream::getPlaybackPan()
{
    return _panner->getParameter(0);
}

float* AudioFileStream::getSamplesForWaveform()
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
        case Filter:
            _effects.set(slot, new BMFilter(_numChannels));
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
    
    _limiter->prepareToPlay(samplesPerBlockExpected, sampleRate);
}

void AudioFileStream::getNextAudioBlock (const AudioSourceChannelInfo& bufferToFill)
{
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
    
    //-- Limiter --//
    _limiter->process(bufferToFill.buffer->getArrayOfWritePointers(), bufferToFill.buffer->getNumChannels(), bufferToFill.numSamples);
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
