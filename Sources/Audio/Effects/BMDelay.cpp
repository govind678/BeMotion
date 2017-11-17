/*
  ==============================================================================

    BMDelay.cpp
    Created: 1 Feb 2016 2:51:35pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMDelay.h"
#include "BMConstants.h"
#include <math.h>
#include <stdio.h>

static const long kMaxDelaySamples = 72000;
static const float kSmoothFactor = 0.001f;
static const float kTimeSmoothFactor = 0.0002f;

BMDelay::BMDelay(int numChannels)
{
    m_iNumChannels          =   numChannels;
    m_fSampleRate           =   48000.0f;
    
    _currentFeedback        =   0.5f;
    _newFeedback            =   0.5f;
    _currentWetDry          =   0.5f;
    _newWetDry              =   0.5f;
    _currentDelayTime_s      =   0.5f;
    _delayTimeParam          =  0.5f;
    _currentDelayInSamples  =   _newDelayInSamples  =  m_fSampleRate * _currentDelayTime_s;
    
    _wetSignal  = new CRingBuffer<float>* [numChannels];
    
    for (int n = 0; n < numChannels; n++)
    {
        _wetSignal[n]    = new CRingBuffer<float> (kMaxDelaySamples);
        _wetSignal[n]->resetInstance();
    }
    
    _tempo  =   120;
    _shouldQuantizeTime = true;
    
    computeDelayTimeParams(_delayTimeParam);
}

BMDelay::~BMDelay()
{
    for (int n = 0; n < m_iNumChannels; n++)
    {
        delete _wetSignal[n];
    }
    
    delete [] _wetSignal;
}


//==============================================================================
// AudioEffect
//==============================================================================

void BMDelay::reset()
{
    
}

void BMDelay::prepareToPlay (int samplesPerBlockExpected, double sampleRate)
{
    m_fSampleRate   =   sampleRate;
    computeDelayTimeParams(_delayTimeParam);
    _currentDelayInSamples  =   _newDelayInSamples;
//    for (int n = 0; n < m_iNumChannels; n++)
//    {
//        _wetSignal[n]->setReadIdx(_wetSignal[n]->getWriteIdx() - (_delayTime_s * m_fSampleRate));
//        _currentReadIdx = _newReadIdx = _wetSignal[n]->getReadIdx();
//    }
}

void BMDelay::process (float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        float feedback = getFeedback();
        float delaySamples = getDelayInSamples();
        
        float wetDry = getWetDry();
        float dryScale = cosf(wetDry * M_PI_2);
        float wetScale = sinf(wetDry * M_PI_2);
        
        for (int channel = 0; channel < m_iNumChannels; channel++)
        {
            float readIndex = _wetSignal[channel]->getWriteIdx() - delaySamples;
            
            float xn = buffer[channel][sample];
            float yn = _wetSignal[channel]->getAtFloatIdx(readIndex);
            
            _wetSignal[channel]->putPostInc(xn + (feedback*yn));
            buffer[channel][sample] = (dryScale * xn) + (wetScale * yn);
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
            computeDelayTimeParams(value);
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
            return _delayTimeParam;
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

void BMDelay::setTempo(float tempo)
{
    _tempo = tempo;
    computeDelayTimeParams(_delayTimeParam);
}

void BMDelay::setShouldQuantizeTime(bool shouldQuantizeTime)
{
    _shouldQuantizeTime = shouldQuantizeTime;
    computeDelayTimeParams(_delayTimeParam);
}

void BMDelay::computeDelayTimeParams(float newValue)
{
    _delayTimeParam = newValue;
    
    if (_shouldQuantizeTime) {
        int idx = floorf(newValue * kLenQuantizedTimeArray);
        if (idx >= kLenQuantizedTimeArray) {
            idx = kLenQuantizedTimeArray - 1;
        } else if (idx < 0) {
            idx = 0;
        }
        _currentDelayTime_s = (60.f / _tempo * kQuantizedTimeArray[idx]);
    } else {
        _currentDelayTime_s = newValue;
    }
    _newDelayInSamples = _currentDelayTime_s * m_fSampleRate;
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

float BMDelay::getDelayInSamples()
{
    _currentDelayInSamples = (kTimeSmoothFactor * _newDelayInSamples) + ((1.0f - kTimeSmoothFactor) * _currentDelayInSamples);
    return _currentDelayInSamples;
}
