/*
  ==============================================================================

    BMGranularizer.h
    Created: 1 Feb 2016 9:16:01pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef BMGRANULARIZER_H_INCLUDED
#define BMGRANULARIZER_H_INCLUDED

#include "AudioEffect.h"
#include "RingBuffer.h"

static const int kEnvelopeSamples   = 20;
static const long kMaxSamples       = 96000;

class BMGranularizer     :   public AudioEffect
{
public:
    //===========================================================================
    
    BMGranularizer(int numChannels);
    ~BMGranularizer();
    
    //========= AudioEffect =========//
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
    void setTempo(float tempo);
    
private:
    //===========================================================================
    
    void generateGrain();
    void calculateParameters();
    
    CRingBuffer<float>**    _buffer;
    CRingBuffer<float>**    _grain;
    float                   _envelope[kEnvelopeSamples];
    
    float                   _sampleRate;
    int                     _numChannels;
    
    //-- Parameters --//
    float                   _rateInSeconds;
    float                   _sizePerGrain;
    float                   _attackTime;
    
    int                     _rateInSamples;
    int                     _sizeInSamples;
    
    int                     _startIndex;
    int                     _sampleCount;
    float                   _floatIndex;
    float                   _tempo;
    int                     _quantizationInterval;
    
    int                     _samplesBuffered;
    bool                    _bufferingToggle;
    bool                    _grainToggle;
};


#endif  // BMGRANULARIZER_H_INCLUDED
