/*
  ==============================================================================

    AudioFilePlayback.cpp
    Created: 8 Mar 2014 5:49:39pm
    Author:  Govinda Ram Pingali

  ==============================================================================
*/

#include "AudioFilePlayback.h"


AudioFilePlayback::AudioFilePlayback(AudioDeviceManager& sharedDeviceManager)  :    deviceManager(sharedDeviceManager),
                                                                                    thread ("audio file playback")
{
    formatManager.registerBasicFormats();
    
    thread.startThread (3);
    
    deviceManager.addAudioCallback (&audioSourcePlayer);
    audioSourcePlayer.setSource (&transportSource);
}


AudioFilePlayback::~AudioFilePlayback()
{
    transportSource.setSource (nullptr);
    audioSourcePlayer.setSource (nullptr);
    
    deviceManager.removeAudioCallback(&audioSourcePlayer);
}




void AudioFilePlayback::startPlaying()
{
    transportSource.setPosition (0);
    transportSource.start();
}


void AudioFilePlayback::stopPlaying()
{
    transportSource.stop();
}



void AudioFilePlayback::loadFileIntoTransport(String filePath)
{
    File audioFile(filePath);
    
    transportSource.stop();
    transportSource.setSource (nullptr);
    currentAudioFileSource = nullptr;
    
    AudioFormatReader* reader = formatManager.createReaderFor (audioFile);
    
    if (reader != nullptr)
    {
        currentAudioFileSource = new AudioFormatReaderSource (reader, true);
        
        // ..and plug it into our transport source
        transportSource.setSource (currentAudioFileSource,
                                   32768,                   // tells it to buffer this many samples ahead
                                   &thread,                 // this is the background thread to use for reading-ahead
                                   reader->sampleRate);     // allows for sample rate correction
    }
}
