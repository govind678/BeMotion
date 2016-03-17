/*
  ==============================================================================
 
    BMStereo.h
    Created: 16 Feb 2016 11:25:08pm
    Author:  Govinda Pingali
 
    Pan Positions:
     0   -> Hard Left
     0.5 -> Center
     1   -> Hard Right
  ==============================================================================
 */

#ifndef BMSTEREO_H_INCLUDED
#define BMSTEREO_H_INCLUDED

#include "AudioEffect.h"

class BMStereo     :   public AudioEffect
{
public:
    //===========================================================================
    
    BMStereo();
    ~BMStereo();
    
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
    
    float getPanPosition();
    
    float               _currentPanPosition;
    float               _newPanPosition;
};

#endif /* BMSTEREO_H_INCLUDED */
