/*
  ==============================================================================

    AudioEffect.h
    Created: 1 Feb 2016 2:42:39pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef AUDIOEFFECT_H_INCLUDED
#define AUDIOEFFECT_H_INCLUDED


class AudioEffect
{
protected:
    //===========================================================================
    /** Creates an AudioEffect */
    AudioEffect() {}
    
public:
    
    /** Destructor. */
    virtual ~AudioEffect() {}
    
    /** Audio Callback */
    virtual void prepareToPlay (int samplesPerBlockExpected, double sampleRate) {}
    virtual void process (float** buffer, int numChannels, int numSamples) {}
    virtual void releaseResources() {}
    
    /** Parameters */
    virtual void setParameter(int parameterID, float value) {}
    virtual float getParameter(int parameterID) = 0;
    
private:
    //===========================================================================
    
};


#endif  // AUDIOEFFECT_H_INCLUDED
