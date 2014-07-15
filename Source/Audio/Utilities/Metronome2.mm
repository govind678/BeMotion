//
//  Metronome2.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/27/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#include "Metronome2.h"

Metronome2::Metronome2(AudioDeviceManager& sharedDeviceManager) :   deviceManager(sharedDeviceManager)
{
    m_fSampleRate = DEFAULT_SAMPLE_RATE;
    m_iTempo      = DEFAULT_TEMPO;
    m_iCount      = 0;
    m_iBeat       = 0;
    m_bStatus     = false;
}


Metronome2::~Metronome2()
{
    
}


void Metronome2::audioDeviceAboutToStart (AudioIODevice* device)
{
    m_fSampleRate = device->getCurrentSampleRate();
}


void Metronome2::audioDeviceIOCallback(const float** inputChannelData,
                                             int totalNumInputChannels,
                                             float** outputChannelData,
                                             int totalNumOutputChannels,
                                             int numSamples)
{
    for (int i=0; i < numSamples; i++)
    {
        
    }
    std::cout << Time::currentTimeMillis() << "\n";
    
}




void Metronome2::audioDeviceStopped()
{
    
}




//--- Set Interface Methods ---//

void Metronome2::setTempo(int tempo)
{
    m_iTempo = tempo;
}


void Metronome2::start()
{
    deviceManager.addAudioCallback(this);
    m_bStatus = true;
}

void Metronome2::stop()
{
    deviceManager.removeAudioCallback(this);
    m_bStatus = false;
}



//--- Get Interface Methods ---//

bool Metronome2::getCurrentStatus()
{
    return m_bStatus;
}

int Metronome2::getTempo()
{
    return m_iTempo;
}

int Metronome2::getCurrentBeat()
{
    return m_iBeat;
}

