//
//  AudioFeatureExtraction.cpp
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/23/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#include "AudioFeatureExtraction.h"


AudioFeatureExtraction::AudioFeatureExtraction()
{
    formatManager.registerBasicFormats();
    currentAudioFileSource = nullptr;
    
    m_fSampleRate   =   DEFAULT_SAMPLE_RATE;
}



AudioFeatureExtraction::~AudioFeatureExtraction()
{
    currentAudioFileSource = nullptr;
}


float AudioFeatureExtraction::detectFirstOnset(String filepath)
{
    AudioFormatReader* reader = formatManager.createReaderFor(File(filepath));
    
    if (reader != nullptr)
    {
        int blockSize = 256;
        AudioSampleBuffer buffer = AudioSampleBuffer(NUM_OUTPUT_CHANNELS, blockSize);
        
        for (int64 block = 0; block < (reader->lengthInSamples - blockSize); block+= blockSize)
        {
            reader->read(&buffer, 0, blockSize, block, true, true);
            
            //--- Check for level ---//
            for (int channel = 0; channel < NUM_OUTPUT_CHANNELS; channel++)
            {
                if (buffer.getRMSLevel(channel, 0, blockSize) > SILENCE_AMPLITUDE)
                {
                    return (float(block) / m_fSampleRate);
                }
            }
            
        }
    }
    
    return 0.0f;
}