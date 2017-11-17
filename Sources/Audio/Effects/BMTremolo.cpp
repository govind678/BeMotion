/*
  ==============================================================================

    BMTremolo.cpp
    Created: 1 Feb 2016 3:16:58pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMTremolo.h"
#include "BMConstants.h"
#include <math.h>
#include <stdio.h>
static const float kMaxRate = 40.0f;

BMTremolo::BMTremolo(int numChannels)
{
    _lfo = new BMOscillator();
    _sampleRate = 48000.0f;
    
    _currentDepth   = 1.0;
    _newDepth       = 1.0f;
    _rateParam      = 0.5f;
    _shape          = 0.01f;
    
    _tempo          =   120;
    _shouldQuantizeTime = true;
    
    _lfo->setShape(_shape);
    computeTimeParams(_rateParam);
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
    computeTimeParams(_rateParam);
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
            computeTimeParams(value);
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
            return _rateParam;
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

void BMTremolo::setTempo(float tempo)
{
    _tempo = tempo;
    computeTimeParams(_rateParam);
}

void BMTremolo::setShouldQuantizeTime(bool shouldQuantizeTime)
{
    _shouldQuantizeTime = shouldQuantizeTime;
    computeTimeParams(_rateParam);
}

void BMTremolo::computeTimeParams(float newValue)
{
    _rateParam = newValue;
    
    if (_shouldQuantizeTime) {
        int idx = floorf(newValue * kLenQuantizedTimeArray);
        if (idx >= kLenQuantizedTimeArray) {
            idx = kLenQuantizedTimeArray - 1;
        } else if (idx < 0) {
            idx = 0;
        }
        _currentRate = _tempo / (60.0f * kQuantizedTimeArray[idx]);
    } else {
        _currentRate = kMaxRate * _rateParam;
    }
//    printf("Rate: %f\n", _currentRate);
    _lfo->setNormalizedFrequency(_currentRate / _sampleRate);
}


float BMTremolo::getDepth()
{
    _currentDepth = (kSmoothingFactor * _newDepth) + ((1.0f - kSmoothingFactor) * _currentDepth);
    return _currentDepth;
}
