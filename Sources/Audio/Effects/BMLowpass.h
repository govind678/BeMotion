/*
 ==============================================================================
 
 BMLowpass.h
 Created: 30 Oct 2017 7:14:25pm
 Author:  Govinda Pingali
 
 Lowpass Parameters:
 0 -> Cutoff Frequency (Hz)
 1 -> Dry/Wet Ratio
 2 -> None
 ==============================================================================
 */

#ifndef BMLOWPASS_H_INCLUDED
#define BMLOWPASS_H_INCLUDED

#include <stdio.h>
#include "AudioEffect.h"

class BMLowpass : public AudioEffect
{
public:
    //===========================================================================
    
    BMLowpass(int numChannels);
    ~BMLowpass();
    
    //========= AudioEffect =========//
    void reset() override;
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
private:
    //===========================================================================
    
    float getGain();
    float getBlend();
    void calculateFrequencyParams();
    
    float*                  _y1;
    
    float                   _sampleRate;
    int                     _numChannels;
    
    float                   _maxFrequency;
    float                   _minFrequency;
    
    //-- Parameters --//
    float                   _cutoffFrequency;
    float                   _currentG;
    float                   _newG;
    float                   _gMakeup;
    
    float                   _currentBlend;
    float                   _newBlend;
    
};

#endif /* BMLOWPASS_H_INCLUDED */
