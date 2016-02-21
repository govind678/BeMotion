/*
  ==============================================================================

    BMFilter.cpp
    Created: 1 Feb 2016 3:16:33pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMFilter.h"
#include <math.h>

static const float kSmoothingFactor = 0.001f;

BMFilter::BMFilter(int numChannels)
{
    _numChannels = numChannels;
    _sampleRate  = 48000.0f;
    
    _highpass = new float[_numChannels];
    _bandpass = new float[_numChannels];
    _lowpass  = new float[_numChannels];
    
    for (int channel=0; channel < _numChannels; channel++)
    {
        _highpass[channel] = 0.0f;
        _bandpass[channel] = 0.0f;
        _lowpass[channel]  = 0.0f;
    }
    
    _centerFrequency    =   1000.0f;
    _quiscent           =   0.1f;
    _minFrequency       =   200.0f;
    _maxFrequency       =   1600.0f;
    _rangeFrequency     =   1.0f;
    _newBlend           =   0.6;    // 60% Wet, 40% Dry
    _currentBlend       =   0.6;
    
    _angularFrequency   = 2 * sinf((M_PI * _centerFrequency) / _sampleRate);
}

BMFilter::~BMFilter()
{
    delete [] _bandpass;
    delete [] _highpass;
    delete [] _lowpass;
}


//==============================================================================
// AudioEffect
//==============================================================================

void BMFilter::setParameter(int parameterID, float value)
{
    if (value < 0.0f)
        value = 0.0f;
    else if (value > 1.0f)
        value = 1.0f;
    
    
    switch(parameterID)
    {
        // Center Frequency
        case 0:
            _centerFrequency = (value * (_maxFrequency - _minFrequency)) + _minFrequency;
            _angularFrequency = 2 * sinf((M_PI * _centerFrequency) / _sampleRate);
            break;
            
        // Frequency Range - TODO: Changed from Frequency range to Blend
        case 1:
            _newBlend  = value;
//          m_fRange   = value;
//          m_fMinFreq = ((1.0f - value) * 600.0f) + 200.0f;
//          m_fMaxFreq = (value * 600.0f) + 1200.0f;
            break;
            
        // Bandwidth 'Q'
        case 2:
            _quiscent = 1.0f - value;
            if (_quiscent < 0.1f)
            {
                _quiscent = 0.1f;
            }
            break;
            
        default:
            break;
    }
}


float BMFilter::getParameter(int parameterID)
{
    switch (parameterID)
    {
        case 0:
            return ((_centerFrequency - _minFrequency) / (_maxFrequency - _minFrequency));
            break;
            
        case 1:
            return (1.0f - _quiscent);
            break;
            
        case 2:
            return _newBlend;
            break;
            
        default:
            return 0.0f;
            break;
    }
}


void BMFilter::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate = sampleRate;
    _angularFrequency = 2.0f * sinf((M_PI * _centerFrequency) / _sampleRate);
}


void BMFilter::process(float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        float blend = getBlend();
        
        for (int channel = 0; channel < numChannels; channel++)
        {
            _highpass[channel] = buffer[channel][sample] - _lowpass[channel] - (_quiscent * _bandpass[channel]);
            _bandpass[channel] = (_angularFrequency * _highpass[channel]) + _bandpass[channel];
            _lowpass[channel]  = (_angularFrequency * _bandpass[channel]) + _lowpass[channel];
            
            buffer[channel][sample] = (blend * _bandpass[channel]) + ((1.0f - blend) * buffer[channel][sample]);
        }
    }
}

void BMFilter::releaseResources()
{
    
}

float BMFilter::getBlend()
{
    _currentBlend = (kSmoothingFactor * _newBlend) + ((1.0f - kSmoothingFactor) * _currentBlend);
    return _currentBlend;
}
