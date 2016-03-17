/*
  ==============================================================================

    BMTremolo.cpp
    Created: 1 Feb 2016 3:16:58pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMTremolo.h"

static const float kMaxRate = 30.0f;

BMTremolo::BMTremolo(int numChannels)
{
    _lfo = new BMOscillator();
    _sampleRate = 48000.0f;
    
    _currentDepth   = 1.0;
    _newDepth       = 1.0f;
    _rate           = 4.0f * 0.681f;
    _shape          = 0.01f;
    
    _lfo->setShape(_shape);
    _lfo->setNormalizedFrequency(_rate / _sampleRate);
}

BMTremolo::~BMTremolo()
{
    delete _lfo;
}


//==============================================================================
// AudioEffect
//==============================================================================

void BMTremolo::reset()
{
    _lfo->restart();
}

void BMTremolo::prepareToPlay (int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate = sampleRate;
    _lfo->setNormalizedFrequency(_rate / _sampleRate);
}

void BMTremolo::process (float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        float lfoSample = _lfo->getNextSample();
        float depth = getDepth();
        
        for (int channel = 0; channel < numChannels; channel++)
        {
            buffer[channel][sample] = (1 + depth * lfoSample) * (buffer[channel][sample]);
        }
    }
}

void BMTremolo::releaseResources()
{
    
}


/** Parameters */
void BMTremolo::setParameter(int parameterID, float value)
{
    if (value < 0.0f)
        value = 0.0f;
    else if (value > 1.0f)
        value = 1.0f;
    
    
    switch(parameterID)
    {
        case 0:
            _rate = kMaxRate * value;
            _lfo->setNormalizedFrequency(_rate / _sampleRate);
            break;
            
        case 1:
            _newDepth = value;
            break;
            
        case 2:
            _shape = value;
            _lfo->setShape(value);
            break;
            
        default:
            break;
    }
    
}

float BMTremolo::getParameter(int parameterID)
{
    switch(parameterID)
    {
        case 0:
            return _rate / kMaxRate;
            break;
            
        case 1:
            return _newDepth;
            break;
            
        case 2:
            return _shape;
            break;
            
        default:
            return 0.0f;
            break;
    }
}

float BMTremolo::getDepth()
{
    _currentDepth = (kSmoothingFactor * _newDepth) + ((1.0f - kSmoothingFactor) * _currentDepth);
    return _currentDepth;
}
