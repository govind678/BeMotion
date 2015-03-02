//
//  Metronome2.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/27/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#ifndef __BeatMotion__Metronome2__
#define __BeatMotion__Metronome2__

#include "BeatMotionHeader.h"
#include "Macros.h"

class Metronome2 :   public AudioIODeviceCallback
{
    
public:
    
    Metronome2(AudioDeviceManager& sharedDeviceManager);
    ~Metronome2();
    
    
    void audioDeviceIOCallback(const float** inputChannelData,
							   int totalNumInputChannels,
							   float** outputChannelData,
							   int totalNumOutputChannels,
							   int blockSize) override;
	
	void audioDeviceAboutToStart (AudioIODevice* device) override;
    void audioDeviceStopped() override;
    
    
    
    //=== Interface Methods ===//
    
    //-- Tempo --//
    void setTempo(int tempo);
    int getTempo();
    
    //-- Clock --//
    void start();
    void stop();
    bool getCurrentStatus();
    
    
    int getCurrentBeat();
    
private:
    
    AudioDeviceManager&                 deviceManager;
    
    float   m_fSampleRate;
    int     m_iTempo;
    bool    m_bStatus;
    
    int     m_iCount;
    int     m_iBeat;
    
};

#endif /* defined(__BeatMotion__Metronome2__) */