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
    void reset() override;
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
    
private:
    //===========================================================================
    
//    void generateGrain();
    void calculateParameters();
    
    float getRateInSamples();
    float getSizeInSamples();
    float getAttackInSamples();
    
    CRingBuffer<float>**    _buffer;
    
    float                   _sampleRate;
    int                     _numChannels;
    
    //-- Parameters --//
    float                   _rateInSeconds;
    float                   _sizePerGrain;
    float                   _attackTime;
    
    float                   _currentRateInSamples;
    float                   _newRateInSamples;
    
    float                   _currentGrainSizeInSamples;
    float                   _newGrainSizeInSamples;
    
    float                   _currentAttackSamples;
    float                   _newAttackSamples;
    
    int                     _rateSampleCount;
    int                     _sizeSampleCount;
    int                     _samplesBuffered;
    bool                    _finishedBuffering;
};


#endif  // BMGRANULARIZER_H_INCLUDED
