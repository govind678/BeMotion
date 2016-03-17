/*
  ==============================================================================

    BMGranularizer.cpp
    Created: 1 Feb 2016 9:16:01pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMGranularizer.h"
#include <stdio.h>

static const float kSmoothFactor = 0.001f;

BMGranularizer::BMGranularizer(int numChannels)
{
    _numChannels  = numChannels;
    _sampleRate   = 48000.0f; // Will be overwritten @prepareToPlay
    
    
    _buffer     = new CRingBuffer<float>* [_numChannels];
    for (int channel = 0; channel < _numChannels; channel++)
    {
        _buffer[channel]    = new CRingBuffer<float> (kMaxSamples);
    }
    
    _sizePerGrain               =   0.5f; // % grain size
    _rateInSeconds              =   0.1f;
    _attackTime                 =   0.5f;
    _samplesBuffered            =   0;
    
    _currentGrainSizeInSamples  =   0.0f;
    _newGrainSizeInSamples      =   0.0f;
    _currentRateInSamples       =   0.0f;
    _newRateInSamples           =   0.0f;
    
    _rateSampleCount            =   0;
    _sizeSampleCount            =   0;
    _finishedBuffering          =   false;
    
    calculateParameters();
}

BMGranularizer::~BMGranularizer()
{
    for (int channel = 0; channel < _numChannels; channel++)
    {
        delete _buffer[channel];
    }
    
    delete [] _buffer;
}


void BMGranularizer::setParameter(int parameterID, float value)
{
    if (value > 1.0f) {
        value = 1.0f;
    }

    switch (parameterID)
    {
        case 0:
            if (value < 0.02f) {
                value = 0.02f;
            }
            _rateInSeconds = value;
            calculateParameters();
            break;
            
        case 1:
            _sizePerGrain = value;
            calculateParameters();
            break;
            
        case 2:
            _attackTime = value;
            break;
            
        default:
            break;
    }
    
    
}


float BMGranularizer::getParameter(int parameterID)
{
    switch (parameterID)
    {
        case 0:
            return _rateInSeconds;
            break;
            
        case 1:
            return _sizePerGrain;
            break;
            
        case 2:
            return _attackTime;
            break;
            
        default:
            return 0.0f;
            break;
    }
}


void BMGranularizer::reset()
{
    _finishedBuffering = false;
    _samplesBuffered = 0;
    _rateSampleCount = 0;
    _sizeSampleCount = 0;
    
    for (int channel = 0; channel < _numChannels; channel++)
    {
        _buffer[channel]->resetInstance();
    }
}

void BMGranularizer::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate = sampleRate;
    calculateParameters();
}


void BMGranularizer::process(float** buffer, int numChannels, int numSamples)
{
    // 1. Store samples into buffer
    
    for (int sample=0; sample < numSamples; sample++)
    {
        for (int channel=0; channel < numChannels; channel++)
        {
            _buffer[channel]->putPostInc(buffer[channel][sample]);
        }
        
        
        // At start of playback, wait for granular synthesis until minimum number of samples are buffered
        
        if (_samplesBuffered < kMaxSamples)
        {
            _samplesBuffered++;
        }
        
        if (!_finishedBuffering)
        {
            if (_samplesBuffered >= getSizeInSamples())
            {
                _finishedBuffering = true;
            }
        }
    }
    
    
    // 2. Generate Grain if minimum number of samples are buffered
    
    if (_finishedBuffering)
    {
        for (int sample=0; sample < numSamples; sample++)
        {
            // Grain Rate
            if (_rateSampleCount == 0)
            {
                int randomIndex = ((double) rand() / (RAND_MAX)) * _samplesBuffered;
                
                for (int channel=0; channel < numChannels; channel++)
                {
                    _buffer[channel]->setReadIdx(randomIndex);
                }
                
                _sizeSampleCount = 0;
            }
            
            _rateSampleCount = (_rateSampleCount + 1) % (int)getRateInSamples();
            
            
            
            // Grain Size
            if (_sizeSampleCount <= getSizeInSamples())
            {
                for (int channel=0; channel < numChannels; channel++)
                {
                    buffer[channel][sample] = _buffer[channel]->getPostInc();
                }
                
                _sizeSampleCount++;
            }
            
            else
            {
                for (int channel=0; channel < numChannels; channel++)
                {
                    buffer[channel][sample] = 0.0f;
                }
            }
        }
    }
    
    
//    for (int sample = 0; sample < numSamples; sample++)
//    {
//        _sampleCount--;
//        
//        if (_sampleCount <= 0)
//        {
//            generateGrain();
//            _sampleCount = _rateInSamples;
//            _grainToggle = true;
//        }
//        
//        //--- Initially check number of samples buffered ---//
//        if (!_bufferingToggle)
//        {
//            _samplesBuffered++;
//            
//            if (_samplesBuffered >= kMaxSamples)
//            {
//                _bufferingToggle = true;
//            }
//        }
//        
//        
//        for (int channel = 0; channel < _numChannels; channel++)
//        {
//            _buffer[channel]->putPostInc(buffer[channel][sample]);
//            
//            if (_grainToggle)
//            {
//                buffer[channel][sample] = _grain[channel]->getPostInc();
//            }
//        }
//    }
    
}


//void BMGranularizer::generateGrain()
//{
//    int randomIndex = ((double) rand() / (RAND_MAX)) * _samplesBuffered;
//    
//    _startIndex = randomIndex - (randomIndex % _quantizationInterval);
//    if (_startIndex < 0)
//        _startIndex = 0;
//    
//    for (int channel = 0; channel < _numChannels; channel++)
//    {
//        _grain[channel]->resetIndices();
//        
//        for (int sample = 0; sample < (_grainSizeInSamples / 1.0f); sample++)
//        {
//            _floatIndex = _startIndex + (sample * 1.0f);
//            
//            if (sample < kEnvelopeSamples)
//            {
//                _grain[channel]->putPostInc(_buffer[channel]->getAtFloatIdx(_floatIndex) * _envelope[sample]);
//            }
//            
//            else
//            {
//                _grain[channel]->putPostInc(_buffer[channel]->getAtFloatIdx(_floatIndex));
//            }
//            
//        }
//        
//        for (int sample = 0; sample < _rateInSamples - (_grainSizeInSamples / 1.0f); sample++)
//        {
//            _grain[channel]->putPostInc(0.0f);
//        }
//    }
//    
//}


void BMGranularizer::calculateParameters()
{
    _newRateInSamples = _rateInSeconds * _sampleRate;
    _newGrainSizeInSamples = ((_sizePerGrain * 0.99f) + 0.01f) * _newRateInSamples;
}


void BMGranularizer::releaseResources()
{
    reset();
}


float BMGranularizer::getRateInSamples()
{
    _currentRateInSamples = (kSmoothFactor * _newRateInSamples) + ((1.0f - kSmoothFactor) * _currentRateInSamples);
    return _currentRateInSamples;
}

float BMGranularizer::getSizeInSamples()
{
    _currentGrainSizeInSamples = (kSmoothFactor * _newGrainSizeInSamples) + ((1.0f - kSmoothFactor) * _currentGrainSizeInSamples);
    return _currentGrainSizeInSamples;
}

