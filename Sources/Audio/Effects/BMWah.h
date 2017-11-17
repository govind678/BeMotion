/*
  ==============================================================================

    BMWah.h
    Created: 1 Feb 2016 3:16:33pm
    Author:  Govinda Pingali
 
    Parameters:
    0 -> Center Frequency (Hz)
    1 -> Dry/Wet Ratio
    2 -> Bandwidth (Q)
  ==============================================================================
*/

#ifndef BMWAH_H_INCLUDED
#define BMWAH_H_INCLUDED

#include "AudioEffect.h"

class BMWah     :   public AudioEffect
{
public:
    //===========================================================================
    
    BMWah(int numChannels);
    ~BMWah();
    
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
    
    float getBlend();
    
    float                   _sampleRate;
    int                     _numChannels;
    
    //-- Parameters --//
    float                   _centerFrequency;
    float                   _quiscent;
    float                   _currentBlend;
    float                   _newBlend;
    
    float                   _maxFrequency;
    float                   _minFrequency;
    float                   _rangeFrequency;
    
    //-- Coefficient --//
    float                   _angularFrequency;
    
    //-- Sample Values --//
    float*                  _highpass;
    float*                  _bandpass;
    float*                  _lowpass;
};



#endif  // BMWAH_H_INCLUDED
