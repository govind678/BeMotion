/*
 ==============================================================================
 
 BMLowpass.cpp
 Created: 30 Oct 2017 7:14:25pm
 Author:  Govinda Pingali
 
 ==============================================================================
 */


#include "BMLowpass.h"
#include <math.h>
#include <stdio.h>

static const float kSmoothingFactor = 0.001f;

BMLowpass::BMLowpass(int numChannels)
{
    _numChannels                = numChannels;
    _sampleRate                 = 48000.0f;
    
    _y1                         = new float[numChannels];
    
    _minFrequency               =   20.0f;
    _maxFrequency               =   8000.0f;
    
    _cutoffFrequency            = 2000.0f;
    calculateFrequencyParams();
    _currentG                   = _newG;
    
    _gMakeup                    = 1.0f;
    
    _newBlend = _currentBlend    =   1.0;    // 60% Wet, 40% Dry
}

BMLowpass::~BMLowpass()
{
    delete [] _y1;
}

//==============================================================================
// AudioEffect
//==============================================================================

void BMLowpass::setParameter(int parameterID, float value)
{
    if (value < 0.0f)
        value = 0.0f;
    else if (value > 1.0f)
        value = 1.0f;
    
    
    switch(parameterID)
    {
            // Cutoff Frequency (Log Scale)
        case 0:
            _cutoffFrequency = _minFrequency * powf((_maxFrequency / _minFrequency), value);
//            _cutoffFrequency = (value * (_maxFrequency - _minFrequency)) + _minFrequency;
            calculateFrequencyParams();
            break;
            
            // Blend (Dry/Wet)
        case 1:
            _newBlend  = value;
            break;
            
        case 2:
            break;
            
        default:
            break;
    }
}


float BMLowpass::getParameter(int parameterID)
{
    switch (parameterID)
    {
            // Center Frequency (Log)
        case 0:
            return (logf(_cutoffFrequency / _minFrequency) / logf(_maxFrequency / _minFrequency));
//            return ((_cutoffFrequency - _minFrequency) / (_maxFrequency - _minFrequency));
            break;
            
            // Blend (Dry/Wet)
        case 1:
            return _newBlend;
            break;
            
        case 2:
            return 0.0f;
            break;
            
        default:
            return 0.0f;
            break;
    }
}

void BMLowpass::reset()
{
    
}

void BMLowpass::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate             = sampleRate;
    calculateFrequencyParams();
}


void BMLowpass::process(float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        float blend = getBlend();
        float g = getGain();
        
        for (int channel = 0; channel < numChannels; channel++)
        {
            float xn = buffer[channel][sample];
            float yn = _gMakeup * (xn * (1.0f - g)) + (_y1[channel] * g);
            buffer[channel][sample] = (blend * yn) + ((1.0f - blend) * xn);
            _y1[channel] = buffer[channel][sample];
        }
    }
}

void BMLowpass::releaseResources()
{
    
}

float BMLowpass::getGain()
{
    _currentG = (kSmoothingFactor * _newG) + ((1.0f - kSmoothingFactor) * _currentG);
    return _currentG;
}

float BMLowpass::getBlend()
{
    _currentBlend = (kSmoothingFactor * _newBlend) + ((1.0f - kSmoothingFactor) * _currentBlend);
    return _currentBlend;
}

void BMLowpass::calculateFrequencyParams()
{
    float wc    = 2.0f * M_PI * _cutoffFrequency / _sampleRate;
    _newG       = 2.0f - cosf(wc) - sqrtf(powf((cosf(wc) - 2.0f), 2.0f) - 1.0f);
    _gMakeup = 1.0f + (3.0f * (1.0f - (logf(_cutoffFrequency / _minFrequency) / logf(_maxFrequency / _minFrequency))));
}
