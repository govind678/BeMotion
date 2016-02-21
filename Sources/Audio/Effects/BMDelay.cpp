/*
  ==============================================================================

    BMDelay.cpp
    Created: 1 Feb 2016 2:51:35pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMDelay.h"
#include <math.h>

static const long kMaxDelaySamples = 96000;
static const float kSmoothFactor = 0.001f;

BMDelay::BMDelay(int numChannels)
{
    m_iNumChannels      =   numChannels;
    m_fSampleRate       =   48000.0f;
    
    _currentFeedback    =   0.5f;
    _newFeedback        =   0.5f;
    _currentWetDry      =   0.5f;
    _newWetDry          =   0.5f;
    _delayTime_s        =   0.5f;
    _currentReadIdx     =   0.0f;
    _newReadIdx         =   0.0f;
    
    wetSignal  = new CRingBuffer<float>* [numChannels];
    
    for (int n = 0; n < numChannels; n++)
    {
        wetSignal[n]    = new CRingBuffer<float> (kMaxDelaySamples);
        wetSignal[n]->resetInstance();
    }
}

BMDelay::~BMDelay()
{
    for (int n = 0; n < m_iNumChannels; n++)
    {
        delete wetSignal[n];
    }
    
    delete [] wetSignal;
}


//==============================================================================
// AudioEffect
//==============================================================================

/** Audio Callback */
void BMDelay::prepareToPlay (int samplesPerBlockExpected, double sampleRate)
{
    m_fSampleRate   =   sampleRate;
    
    for (int n = 0; n < m_iNumChannels; n++)
    {
        wetSignal[n]->setReadIdx(wetSignal[n]->getWriteIdx() - (_delayTime_s * m_fSampleRate));
        _currentReadIdx = _newReadIdx = wetSignal[n]->getReadIdx();
    }
}

void BMDelay::process (float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        float feedback = getFeedback();
        float wetDry = getWetDry();
        
        for (int channel = 0; channel < m_iNumChannels; channel++)
        {
            wetSignal[channel]->putPostInc(buffer[channel][sample] + (feedback * wetSignal[channel]->get()));
            
            float dryScale = cosf(wetDry * M_PI_2);
            float wetScale = sinf(wetDry * M_PI_2);
            
            buffer[channel][sample] = (dryScale * buffer[channel][sample]) + (wetScale * wetSignal[channel]->getPostInc());
            
            
        }
    }
}

void BMDelay::releaseResources()
{
    
}


/** Parameters */
void BMDelay::setParameter(int parameterID, float value)
{
    if (value < 0.0f)
        value = 0.0f;
    else if (value > 1.0f)
        value = 1.0f;
    
    
    switch(parameterID)
    {
        case 0:
            
            _delayTime_s = value;
            
            for (int n = 0; n < m_iNumChannels; n++)
            {
                wetSignal[n]->setReadIdx(wetSignal[n]->getWriteIdx() - (_delayTime_s * m_fSampleRate));
            }
            
            break;
            
            
        case 1:
            _newWetDry = value;
            break;
            
            
        case 2:
            if (value >= 0.95f)
                _newFeedback = 0.95f;
            else
                _newFeedback = value;
            break;
            
        default:
            break;
    }
}


float BMDelay::getParameter(int parameterID)
{
    switch(parameterID)
    {
        case 0:
            return _delayTime_s;
            break;
            
            
        case 1:
            return _newWetDry;
            break;
            
            
        case 2:
            return _newFeedback;
            break;
            
        default:
            return 0.0f;
            break;
    }
}

float BMDelay::getFeedback()
{
    _currentFeedback = (kSmoothFactor * _newFeedback) + ((1.0f - kSmoothFactor) * _currentFeedback);
    return _currentFeedback;
}

float BMDelay::getWetDry()
{
    _currentWetDry = (kSmoothFactor * _newWetDry) + ((1.0f - kSmoothFactor) * _currentWetDry);
    return _currentWetDry;
}

float BMDelay::getReadIdx()
{
    _currentReadIdx = (kSmoothFactor * _newReadIdx) + ((1.0f - kSmoothFactor) * _currentReadIdx);
    return _currentReadIdx;
}
