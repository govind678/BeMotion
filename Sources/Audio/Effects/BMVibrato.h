/*
  ==============================================================================

    BMVibrato.h
    Created: 1 Feb 2016 3:17:08pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef BMVIBRATO_H_INCLUDED
#define BMVIBRATO_H_INCLUDED

#include "AudioEffect.h"
#include "RingBuffer.h"
#include "Oscillator.h"

class BMVibrato     :   public AudioEffect
{
public:
    //===========================================================================
    
    BMVibrato(int numChannels);
    ~BMVibrato();
    
    //========= AudioEffect =========//
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
private:
    //===========================================================================
    
    float               _sampleRate;
    int                 _numChannels;
    
    float               _floatIndex;
    
    float               _modulation_Freq_Hz;
    int                 _modulation_Width_Samples;
    float               _shape;
    
    Oscillator*         _lfo;
    CRingBuffer<float>** _ringBuffer;
};

#endif  // BMVIBRATO_H_INCLUDED
