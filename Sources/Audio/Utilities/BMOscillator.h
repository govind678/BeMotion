/*
  ==============================================================================

    BMOscillator.h
    Created: 1 Feb 2016 3:20:17pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef BMOSCILLATOR_H_INCLUDED
#define BMOSCILLATOR_H_INCLUDED

static const int kWaveTableSize = 4096;
static const float kSmoothingFactor = 0.001f;

enum WaveShape
{
    Sine,
    Saw,
    Square,
    WhiteNoise
};

//==============================================================================


class BMOscillator
{
public:
    //===========================================================================
    
    BMOscillator();
    ~BMOscillator();
    
    void setNormalizedFrequency(float frequency);
    
    /* Shape: 0 to 1 number indicating number of harmonics added where 0 is sine, 1 is almost square */
    void setShape(float shape);
    
    float getNextSample();
    
    void restart();
    
private:
    
    float getIncrement();
    float getScale();
    
    float   _frequency;
    
    float   _shape;
    float   _currentScale;
    float   _newScale;
    
    int     _phase;
    float   _newIncrement;
    float   _currentIncrement;
    
    float   _currentSample;
    
    float   _sineWaveTable[kWaveTableSize];
};



#endif  // BMOSCILLATOR_H_INCLUDED
