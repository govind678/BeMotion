//==============================================================================
//
//  TrimAudio.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/9/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================

#include "TrimAudio.h"


TrimAudio::TrimAudio()
{
    m_fSampleRate = DEFAULT_SAMPLE_RATE;
    
    formatManager.registerBasicFormats();
}


TrimAudio::~TrimAudio()
{
    
}


void TrimAudio::cropAudioFile(String filepath, float startTime_s, float stopTime_s)
{
    File audioFile = File(filepath);
    
    AudioFormatReader* reader = formatManager.createReaderFor(audioFile);
    
    std::cout << "Audio File: " << audioFile.getFullPathName() << std::endl;
    
    if (reader != nullptr)
    {
//        currentAudioFileSource = new AudioFormatReaderSource (reader, true);
        m_fSampleRate = reader->sampleRate;
        int numSamples = (stopTime_s - startTime_s) * m_fSampleRate;
        
        ScopedPointer<FileOutputStream> outputStream = new FileOutputStream(audioFile, 65536);
//        outputStream = audioFile.createOutputStream();
        AudioFormatWriter* writer = wavAudioFormat.createWriterFor(outputStream, m_fSampleRate, reader->numChannels, reader->bitsPerSample, NULL, 0);
        
        writer->writeFromAudioReader(*reader, startTime_s * m_fSampleRate, numSamples);
        
//        inputFile.deleteFile();
        outputStream = nullptr;
        
    }
}


void TrimAudio::trimAudioFile(String filepath)
{
    
}



void TrimAudio::setSamplingRate(float samplingRate)
{
    m_fSampleRate = samplingRate;
}