/*
  ==============================================================================

    BMTremolo.h
    Created: 1 Feb 2016 3:16:58pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef BMTREMOLO_H_INCLUDED
#define BMTREMOLO_H_INCLUDED

#include "AudioEffect.h"
#include "Oscillator.h"

class BMTremolo     :   public AudioEffect
{
public:
    //===========================================================================
    
    BMTremolo(int numChannels);
    ~BMTremolo();
    
    //========= AudioEffect =========//
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
private:
    //===========================================================================
    
    float getDepth();
    
    Oscillator*     _lfo;
    
    int             _numChannels;
    float           _sampleRate;
    
    float           _currentDepth;
    float           _newDepth;
    
    float           _rate;  // Normalized to Sampling Rate
    float           _shape;
};



#endif  // BMTREMOLO_H_INCLUDED
