/*
  ==============================================================================

    BMDelay.h
    Created: 1 Feb 2016 2:51:35pm
    Author:  Govinda Pingali

    Delay Parameters:
    0 -> Delay Time (s)
    1 -> Dry/Wet Ratio
    2 -> Feedback
  ==============================================================================
*/

#ifndef BMDELAY_H_INCLUDED
#define BMDELAY_H_INCLUDED

#include "AudioEffect.h"
#include "RingBuffer.h"

class BMDelay       :   public AudioEffect
{
public:
    //===========================================================================
    
    BMDelay(int numChannels);
    ~BMDelay();
    
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
    
    float getWetDry();
    float getFeedback();
    float getDelayInSamples();
    void computeDelayTimeParams(float newValue);
    
    CRingBuffer<float>**        _wetSignal;
    
    float   m_fSampleRate;
    int     m_iNumChannels;
    
    float   _currentFeedback;
    float   _newFeedback;
    
    float   _currentWetDry;
    float   _newWetDry;
    
    float   _currentDelayInSamples;
    float   _newDelayInSamples;
    float   _delayTimeParam;
    float   _currentDelayTime_s;
    
    float   _tempo;
    bool    _shouldQuantizeTime;
};



#endif  // BMDELAY_H_INCLUDED
