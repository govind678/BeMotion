/*
  ==============================================================================

    AudioController.cpp
    Created: 1 Feb 2016 2:52:55am
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "AudioController.h"


//=======================================================================
// Init Methods
//=======================================================================

#pragma mark - Init Methods

#include <stdio.h>
AudioController::AudioController()
{
    // Device Setup
    String audioError = _deviceManager.initialise (kDefaultNumInputChannels, kDefaultNumOutputChannels, nullptr, true);
    jassert (audioError.isEmpty());
    AudioDeviceManager::AudioDeviceSetup setup;
    _deviceManager.getAudioDeviceSetup(setup);
    _sampleRate = setup.sampleRate;
    _numSamplesPerBlock = setup.bufferSize;
    
    _mixerSource    = new MixerAudioSource();
    
    // UI Button Tracks
    for (int i=0; i < kNumButtonTracks; i++)
    {
        String playbackThreadName = "Audio File Stream Thread " + String(i);
        AudioFileStream* fileStream = new AudioFileStream(kDefaultNumOutputChannels, true, playbackThreadName);
        _streams.add(fileStream);
        _mixerSource->addInputSource(fileStream, false);
        
        String recordThreadName = "Audio Recorder Thread " + String(i);
        _recorders.add(new AudioFileRecord(1, recordThreadName));
    }
    
    // Motion Playback Tracks
    for (int i=0; i < kNumMotionTracks; i++)
    {
        String threadName = "Audio File Stream Thread " + String(kNumButtonTracks + i);
        AudioFileStream* fileStream = new AudioFileStream(kDefaultNumOutputChannels, false, threadName);
        fileStream->setPlaybackMode(BMPlaybackMode_OneShot);
        _streams.add(fileStream);
        _mixerSource->addInputSource(fileStream, false);
    }
    
    // Create Master Recorder
    _masterRecorder   = new AudioFileRecord(kDefaultNumOutputChannels, "Master Recorder Thread");
    
    // Create Output Limiter
    _limiter = new BMLimiter(kDefaultNumOutputChannels);
    
    // Start
    openSession();
}


AudioController::~AudioController()
{
    closeSession();
    
    _streams.clear();
    _recorders.clear();
    _mixerSource       = nullptr;
    _masterRecorder    = nullptr;
    _limiter           = nullptr;
    
    _deviceManager.closeAudioDevice();
}


int AudioController::openSession()
{
    _deviceManager.addAudioCallback(this);
    return 0;
}


int AudioController::closeSession()
{
    _deviceManager.removeAudioCallback(this);
    return 0;
}


//=======================================================================
// Audio Track Playback Methods
//=======================================================================

#pragma mark - Audio Track Playback Methods

bool AudioController::loadAudioFileIntoTrack(String filepath, int track)
{
    AudioFileStream* stream = _streams.getUnchecked(track);
    bool success = false;
    stream->stopPlayback();
    stream->releaseResources();
    success = stream->loadAudioFile(File(filepath));
    if (success) {
        stream->prepareToPlay(_numSamplesPerBlock, _sampleRate);
    }
    return success;
}

void AudioController::setPlaybackSpeedOfTrack(float speed, int track)
{
    
}

void AudioController::startPlaybackOfTrack(int track)
{
    _streams.getUnchecked(track)->startPlayback();
}

void AudioController::stopPlaybackOfTrack(int track)
{
    _streams.getUnchecked(track)->stopPlayback();
}

bool AudioController::isTrackPlaying(int track)
{
    return _streams.getUnchecked(track)->isPlaying();
}

float AudioController::getNormalizedPlaybackProgress(int track)
{
    return _streams.getUnchecked(track)->getNormalizedPlaybackProgress();
}

float AudioController::getTotalTimeOfTrack(int track)
{
    return _streams.getUnchecked(track)->getTotalTime();
}


//=======================================================================
// Audio Track Recording Methods
//=======================================================================

#pragma mark - Audio Track Recording Methods

bool AudioController::startRecordingAtTrack(int track, String filepath)
{
    _streams.getUnchecked(track)->stopPlayback();
    return _recorders.getUnchecked(track)->startRecording(File(filepath));
}

void AudioController::stopRecordingAtTrack(int track)
{
    _recorders.getUnchecked(track)->stopRecording();
}

bool AudioController::isTrackRecording(int track)
{
    return _recorders.getUnchecked(track)->isRecording();
}


//=======================================================================
// Audio Track Parameter Methods
//=======================================================================

#pragma mark - Audio Track Parameter Methods

void AudioController::setTrackGain(int track, float gain)
{
    _streams.getUnchecked(track)->setPlaybackGain(gain);
}

float AudioController::getTrackGain(int track)
{
    return _streams.getUnchecked(track)->getPlaybackGain();
}

void AudioController::setTrackPan(int track, float pan)
{
    _streams.getUnchecked(track)->setPlaybackPan(pan);
}

float AudioController::getTrackPan(int track)
{
    return _streams.getUnchecked(track)->getPlaybackPan();
}

void AudioController::setPlaybackModeOfTrack(int track, BMPlaybackMode mode)
{
    _streams.getUnchecked(track)->setPlaybackMode(mode);
}

BMPlaybackMode AudioController::getPlaybackModeOfTrack(int track)
{
    return _streams.getUnchecked(track)->getPlaybackMode();
}

const float* AudioController::getSamplesForWaveformAtTrack(int track)
{
    return _streams.getUnchecked(track)->getSamplesForWaveform();
}


//=======================================================================
// Audio Master Track Methods
//=======================================================================

#pragma mark - Audio Master Track Methods

void AudioController::startRecordingMaster(String filepath)
{
    _masterRecorder->startRecording(File(filepath));
}

void AudioController::stopRecordingMaster()
{
    _masterRecorder->stopRecording();
}


//=======================================================================
// Audio Effect Methods
//=======================================================================

#pragma mark - Audio Effect Methods

void AudioController::setEffect(int track, int slot, int effectID)
{
    _streams.getUnchecked(track)->setEffect(slot, effectID);
    _streams.getUnchecked(track)->prepareToPlay(_numSamplesPerBlock, _sampleRate);
}

int AudioController::getEffect(int track, int slot)
{
    return _streams.getUnchecked(track)->getEffect(slot);
}


void AudioController::setEffectParameter(int track, int slot, int parameterID, float value)
{
    _streams.getUnchecked(track)->setEffectParameter(slot, parameterID, value);
}

float AudioController::getEffectParameter(int track, int slot, int parameterID)
{
    return _streams.getUnchecked(track)->getEffectParameter(slot, parameterID);
}


void AudioController::setEffectEnable(int track, int slot, bool enable)
{
    _streams.getUnchecked(track)->setEffectEnable(slot, enable);
}

bool AudioController::getEffectEnable(int track, int slot)
{
    return _streams.getUnchecked(track)->getEffectEnable(slot);
}

void AudioController::setTempo(float tempo)
{
    for (int i=0; i < kNumButtonTracks; i++) {
        _streams.getUnchecked(i)->setTempo(tempo);
    }
}

void AudioController::setShouldQuantizeTime(int track, int slot, bool shouldQuantizeTime)
{
    _streams.getUnchecked(track)->setShouldQuantizeTime(slot, shouldQuantizeTime);
}


//==============================================================================
// AudioIODeviceCallback
//==============================================================================

#pragma mark - AudioIODeviceCallback

void AudioController::audioDeviceAboutToStart(juce::AudioIODevice *device)
{
    _sampleRate = device->getCurrentSampleRate();
    _numSamplesPerBlock = device->getCurrentBufferSizeSamples();
    
    _mixerSource->prepareToPlay (_numSamplesPerBlock, _sampleRate);
    _masterRecorder->prepareToRecord(_sampleRate);
    _limiter->prepareToPlay(_numSamplesPerBlock, _sampleRate);
    for (int i=0; i < _recorders.size(); i++)
        _recorders.getUnchecked(i)->prepareToRecord(_sampleRate);
}

void AudioController::audioDeviceIOCallback(const float **inputChannelData,
                                            int totalNumInputChannels,
                                            float **outputChannelData,
                                            int totalNumOutputChannels,
                                            int numSamples)
{
    // Record Microphone Input to File, if Enabled
    for (int track = 0; track < kNumButtonTracks; track++)
    {
        AudioFileRecord* recorder = _recorders.getUnchecked(track);
        if (recorder->isRecording())
        {
            recorder->writeBuffer(inputChannelData, numSamples);
        }
    }
    
    
    // Fill Mixer with Audio from Tracks
    AudioSampleBuffer buffer (outputChannelData, totalNumOutputChannels, numSamples);
    AudioSourceChannelInfo info (&buffer, 0, numSamples);
    _mixerSource->getNextAudioBlock(info);
    
    
    // Record Song, Output of Mixer, if Enabled
    if (_masterRecorder->isRecording())
        _masterRecorder->writeBuffer(outputChannelData, numSamples);
    
    
    // Post-Mix Gain Scale to prevent clipping
    for (int channel = 0; channel < totalNumOutputChannels; channel++)
    {
        for (int sample = 0; sample < numSamples; sample++)
        {
            outputChannelData[channel][sample] /= (float)kNumButtonTracks;
        }
    }
    
    //-- Limiter --//
    _limiter->process(outputChannelData, totalNumOutputChannels, numSamples);
}

void AudioController::audioDeviceStopped()
{
    _mixerSource->releaseResources();
}
