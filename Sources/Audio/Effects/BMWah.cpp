/*
  ==============================================================================

    BMWah.cpp
    Created: 1 Feb 2016 3:16:33pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMWah.h"
#include <math.h>

static const float kSmoothingFactor = 0.001f;

BMWah::BMWah(int numChannels)
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
    _minFrequency       =   100.0f;
    _maxFrequency       =   1600.0f;
    _rangeFrequency     =   1.0f;
    _newBlend           =   0.8;    // 60% Wet, 40% Dry
    _currentBlend       =   0.8;
    
    _angularFrequency   = 2 * sinf((M_PI * _centerFrequency) / _sampleRate);
}

BMWah::~BMWah()
{
    delete [] _bandpass;
    delete [] _highpass;
    delete [] _lowpass;
}


//==============================================================================
// AudioEffect
//==============================================================================

void BMWah::setParameter(int parameterID, float value)
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
            
        // Blend (Dry/Wet)
        case 1:
            _newBlend  = value;
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


float BMWah::getParameter(int parameterID)
{
    switch (parameterID)
    {
        // Center Frequency
        case 0:
            return ((_centerFrequency - _minFrequency) / (_maxFrequency - _minFrequency));
            break;
         
        // Blend (Dry/Wet)
        case 1:
            return _newBlend;
            break;
          
        // Bandwitdh ('Q')
        case 2:
            return (1.0f - _quiscent);
            break;
            
        default:
            return 0.0f;
            break;
    }
}

void BMWah::reset()
{
    
}

void BMWah::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate = sampleRate;
    _angularFrequency = 2.0f * sinf((M_PI * _centerFrequency) / _sampleRate);
}


void BMWah::process(float** buffer, int numChannels, int numSamples)
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

void BMWah::releaseResources()
{
    
}

float BMWah::getBlend()
{
    _currentBlend = (kSmoothingFactor * _newBlend) + ((1.0f - kSmoothingFactor) * _currentBlend);
    return _currentBlend;
}
