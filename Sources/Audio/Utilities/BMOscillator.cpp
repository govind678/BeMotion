/*
  ==============================================================================

    BMOscillator.cpp
    Created: 1 Feb 2016 3:20:17pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMOscillator.h"
#include <math.h>

BMOscillator::BMOscillator()
{
    //--- Create Sine Wavetable ---//
    for (int sample = 0; sample < kWaveTableSize; sample++)
    {
        _sineWaveTable[sample] = sinf(2.0f * M_PI * sample / kWaveTableSize);
    }
    
    
    //--- Initialize Defaults ---//
    _frequency          = 1.0f;
    _phase              = 0;
    _newIncrement       = 1.0f;
    _currentIncrement   = 1.0f;
    _currentSample      = 0.0f;
    _shape              = 0.0f;
    _currentScale       = 0.0f;
    _newScale           = 0.0f;
}

BMOscillator::~BMOscillator()
{
    
}

void BMOscillator::setNormalizedFrequency(float frequency)
{
    _frequency = frequency;
    _newIncrement = kWaveTableSize * _frequency;
}

void BMOscillator::setShape(float shape)
{
    _shape = shape;
    _newScale = 40.0f * powf(1000.0f, (_shape - 1.0f));
}

float BMOscillator::getNextSample()
{
    //-- Get Interpolated Increment --//
    float increment = getIncrement();
    
    //-- Create Float Index --//
    float floatIndex = _phase * increment;
    
    //-- Increment Phase --//
    _phase = fmodf(_phase + 1, (kWaveTableSize / increment));
    
    //-- Wrap to Table Size --//
    float wrappedIndex = fmod(floatIndex, kWaveTableSize);
    
    //-- Get Slope --//
    float slope = (_sineWaveTable[int((floorf(floatIndex) + 1)) % kWaveTableSize]) - (_sineWaveTable[int((floorf(floatIndex))) % kWaveTableSize]);
    
    //-- Generate Interpolated Sample --//
    float sample = slope * (wrappedIndex - floorf(wrappedIndex)) + _sineWaveTable[int(floorf(wrappedIndex))];
    
    //-- Shape and Scale Sample (After Interpolation) --//
    float scale = getScale();
    _currentSample = tanhf(scale * sample) / tanhf(scale);
    
    return _currentSample;
}

void BMOscillator::restart()
{
    _phase = 0;
}

float BMOscillator::getIncrement()
{
    _currentIncrement = (kSmoothingFactor * _newIncrement) + ((1.0f - kSmoothingFactor) * _currentIncrement);
    return _currentIncrement;
}

float BMOscillator::getScale()
{
    _currentScale = (kSmoothingFactor * _newScale) + ((1.0f - kSmoothingFactor) * _currentScale);
//    printf("Target: %f, Current: %f\n", _newScale, _currentScale);
    return _currentScale;
}
