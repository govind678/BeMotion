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
#include "BMOscillator.h"

class BMTremolo     :   public AudioEffect
{
public:
    //===========================================================================
    
    BMTremolo(int numChannels);
    ~BMTremolo();
    
    //========= AudioEffect =========//
    void reset() override;
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
    void setTempo(float tempo) override;
    void setShouldQuantizeTime(bool shouldQuantizeTime) override;
    
private:
    //===========================================================================
    
    float getDepth();
    void computeTimeParams(float newValue);
    
    BMOscillator*   _lfo;
    
    int             _numChannels;
    float           _sampleRate;
    
    float           _currentDepth;
    float           _newDepth;
    
    float           _rateParam;
    float           _currentRate;  // Normalized to Sampling Rate
    float           _shape;
    
    float           _tempo;
    bool            _shouldQuantizeTime;
};



#endif  // BMTREMOLO_H_INCLUDED
