/*
 ==============================================================================
 
    BMEqualizer.h
    Created: 3 Mar 2016 4:56:34pm
    Author:  Govinda Pingali
 
 ==============================================================================
*/

#ifndef BMEQUALIZER_H_INCLUDED
#define BMEQUALIZER_H_INCLUDED

#include "AudioEffect.h"
#include "BMBiquadFilter.h"

class BMEqualizer       : public AudioEffect
{
public:
    
    BMEqualizer();
    ~BMEqualizer();
    
    //========= AudioEffect =========//
    void reset() override;
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
private:
    
    BMBiquadFilter*     _lowpass;
    BMBiquadFilter*     _bandpass;
    BMBiquadFilter*     _highpass;
    
    float       _sampleRate;
    
    float       _newHighsGain;
    float       _currentHighsGain;
    
    float       _newMidsGain;
    float       _currentMidsGain;
    
    float       _newLowsGain;
    float       _currentLowsGain;
};

#endif /* BMEQUALIZER_H_INCLUDED */
