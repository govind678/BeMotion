/*
  ==============================================================================

    AudioController.cpp
    Created: 1 Feb 2016 2:52:55am
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "AudioController.h"
#include "BMConstants.h"


//=======================================================================
// Init Methods
//=======================================================================

#pragma mark - Init Methods

#include <stdio.h>
AudioController::AudioController()
{
    String audioError = _deviceManager.initialise (kDefaultNumInputChannels, kDefaultNumOutputChannels, nullptr, true);
    jassert (audioError.isEmpty());
    
    AudioDeviceManager::AudioDeviceSetup setup;
    _deviceManager.getAudioDeviceSetup(setup);
    _sampleRate = setup.sampleRate;
    _numSamplesPerBlock = setup.bufferSize;
    
    _mixerSource    = new MixerAudioSource();
    _masterRecorder   = new AudioFileRecord();
    
    for (int i=0; i < kNumTracks; i++)
    {
        AudioFileStream* fileStream = new AudioFileStream(kDefaultNumOutputChannels);
        _streams.add(fileStream);
        _mixerSource->addInputSource(fileStream, false);
        
        AudioFileRecord* fileRecord = new AudioFileRecord();
        _recorders.add(fileRecord);
        
        for (int j=0; j < 2; j++)
        {
            String filepath = File::getSpecialLocation(File::userDocumentsDirectory).getFullPathName() + "/Recordings" + String(i) + "_" + String(j) + ".wav";
            _recorderPaths.add(filepath);
        }
        _recorderPathToggles.add(false);
    }
    
    openSession();
}


AudioController::~AudioController()
{
    closeSession();
    
    _streams.clear();
    _recorders.clear();
    _recorderPathToggles.clear();
    _recorderPaths.clear();
    _mixerSource       = nullptr;
    _masterRecorder    = nullptr;
    
    _deviceManager.removeAudioCallback(this);
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
// Audio Track Methods
//=======================================================================

#pragma mark - Audio Track Methods

int AudioController::loadAudioFileIntoTrack(String filepath, int track)
{
    return _streams.getUnchecked(track)->loadAudioFile(File(filepath));
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

float AudioController::getNormalizedPlaybackProgress(int track)
{
    return _streams.getUnchecked(track)->getNormalizedPlaybackProgress();
}


void AudioController::saveMicRecordingForTrack(String filepath, int track)
{
    
}

void AudioController::startRecordingAtTrack(int track)
{
    _streams.getUnchecked(track)->stopPlayback();
    
    bool recorderToggle = _recorderPathToggles.getUnchecked(track);
    String filepath = _recorderPaths.getReference(track + int(recorderToggle));
    _recorders.getUnchecked(track)->startRecording(File(filepath));
    _recorderPathToggles.set(track, !recorderToggle);
}

void AudioController::stopRecordingAtTrack(int track)
{
    _recorders.getUnchecked(track)->stopRecording();
    String filepath = _recorderPaths.getReference(track + int(!_recorderPathToggles.getReference(track)));
    loadAudioFileIntoTrack(filepath, track);
}

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

float* AudioController::getSamplesForWaveformAtTrack(int track)
{
    return _streams.getUnchecked(track)->getSamplesForWaveform();
}

//=======================================================================
// Audio Master Track Methods
//=======================================================================

#pragma mark - Audio Master Track Methods

void AudioController::startRecordingMaster()
{
    _tempMasterFile.deleteFile();
    String audioRecordFilePath = File::getSpecialLocation(File::tempDirectory).getFullPathName() + "/bm_recording.wav";
    _tempMasterFile = File(audioRecordFilePath);
    _masterRecorder->startRecording(_tempMasterFile);
}

void AudioController::stopRecordingMaster()
{
    _masterRecorder->stopRecording();
}

bool AudioController::saveMasterRecording(String filepath)
{
    return _tempMasterFile.copyFileTo(File(filepath));
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
    for (int i=0; i < _streams.size(); i++)
        _recorders.getUnchecked(i)->prepareToRecord(_sampleRate);
}

void AudioController::audioDeviceIOCallback(const float **inputChannelData,
                                            int totalNumInputChannels,
                                            float **outputChannelData,
                                            int totalNumOutputChannels,
                                            int numSamples)
{
    // Record Microphone Input to File, if Enabled
    for (int track = 0; track < kNumTracks; track++)
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
            outputChannelData[channel][sample] /= (float)kNumTracks;
        }
    }
}

void AudioController::audioDeviceStopped()
{
    _mixerSource->releaseResources();
}
