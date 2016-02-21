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
    void prepareToPlay (int samplesPerBlockExpected, double sampleRate) override;
    void process (float** buffer, int numChannels, int numSamples) override;
    void releaseResources() override;
    
    /** Parameters */
    void setParameter(int parameterID, float value) override;
    float getParameter(int parameterID) override;
    
private:
    //===========================================================================
    
    float getWetDry();
    float getFeedback();
    float getReadIdx();
    
    CRingBuffer<float>**        wetSignal;
    
    float   m_fSampleRate;
    int     m_iNumChannels;
    
    float   _currentFeedback;
    float   _newFeedback;
    
    float   _currentWetDry;
    float   _newWetDry;
    
    float   _currentReadIdx;
    float   _newReadIdx;
    float   _delayTime_s;
};



#endif  // BMDELAY_H_INCLUDED
