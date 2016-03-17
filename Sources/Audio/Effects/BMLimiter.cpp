/*
  ==============================================================================

    BMLimiter.cpp
    Created: 1 Feb 2016 9:56:34pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMLimiter.h"
#include <math.h>
#include <algorithm>

static const int kMaxSamples = 20;

BMLimiter::BMLimiter(int numChannels)
{
    _numChannels        = numChannels;
    
    _threshold          = 0.99f;
    _attackTimeInSec	= 0.01f;
    _releaseTimeInSec	= 0.5f;
    _delayInSec         = 0.01f;
    
    _peak		= new float [numChannels];
    _coeff      = new float [numChannels];
    _gain		= new float [numChannels];
    
    _ringBuffer = new CRingBuffer<float> *[numChannels];
    for (int n = 0; n < numChannels; n++)
    {
        _ringBuffer[n]	= new CRingBuffer<float>((int)(kMaxSamples));
        _ringBuffer[n]->resetInstance();
        
        _peak[n]		= 0.0f;
        _gain[n]		= 1.0f;
        _coeff[n]		= 0.0f;
    }
}

BMLimiter::~BMLimiter()
{
    delete [] _ringBuffer;
    delete [] _peak;
    delete [] _gain;
    delete [] _coeff;
}


//==============================================================================
// AudioEffect
//==============================================================================

void BMLimiter::reset()
{
    
}

void BMLimiter::prepareToPlay (int samplesPerBlockExpected, double sampleRate)
{
    
}

void BMLimiter::process (float** buffer, int numChannels, int numSamples)
{
    for (int channel = 0; channel < numChannels; channel++)
    {
        for (int sample = 0; sample < numSamples; sample++)
        {
            if (fabs(buffer[channel][sample]) > _peak[channel])
            {
                _coeff[channel] = _attackTimeInSec;
            }
            else
            {
                _coeff[channel] = _releaseTimeInSec;
            }
            
            
            _peak[channel] = (1.0f - _coeff[channel]) * _peak[channel] + _coeff[channel] * fabs(buffer[channel][sample]);
            
            if (std::min(1.0f, _threshold/_peak[channel]) < _gain[channel])
            {
                _coeff[channel] = _attackTimeInSec;
            } else {
                _coeff[channel] = _releaseTimeInSec;
            }
            
            _gain[channel] = (1.0f - _coeff[channel]) * _gain[channel] + _coeff[channel] * (std::min(1.0f, _threshold / _peak[channel]));
            
            _ringBuffer[channel]->putPostInc(buffer[channel][sample]);
            buffer[channel][sample] = _gain[channel] * _ringBuffer[channel]->getPostInc();
        }
    }
}

void BMLimiter::releaseResources()
{
    
}


/** Parameters */
void BMLimiter::setParameter(int parameterID, float value)
{
    if (value < 0.0f)
        value = 0.0f;
    else if (value > 1.0f)
        value = 1.0f;
}

float BMLimiter::getParameter(int parameterID)
{
    return 0.0f;
}
