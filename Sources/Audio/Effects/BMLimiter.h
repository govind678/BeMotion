/*
  ==============================================================================

    BMLimiter.h
    Created: 1 Feb 2016 9:56:34pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef BMLIMITER_H_INCLUDED
#define BMLIMITER_H_INCLUDED

#include "AudioEffect.h"
#include "RingBuffer.h"

class BMLimiter     :   public AudioEffect
{
public:
    //===========================================================================
    
    BMLimiter(int numChannels);
    ~BMLimiter();
    
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
    
    CRingBuffer<float>** _ringBuffer;
    
    float       _attackTimeInSec;
    float       _releaseTimeInSec;
    float       _delayInSec;
    float       _threshold;
    
    float*      _peak;
    float*      _coeff;
    float*      _gain;
    
    int         _numChannels;
};


#endif  // BMLIMITER_H_INCLUDED
