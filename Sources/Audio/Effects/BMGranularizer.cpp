/*
  ==============================================================================

    BMGranularizer.cpp
    Created: 1 Feb 2016 9:16:01pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMGranularizer.h"

BMGranularizer::BMGranularizer(int numChannels)
{
    _numChannels  = numChannels;
    _sampleRate   = 48000.0f; // Will be overwritten @prepareToPlay
    
    
    _buffer     = new CRingBuffer<float>* [_numChannels];
    _grain      = new CRingBuffer<float>* [_numChannels];
    
    for (int channel = 0; channel < _numChannels; channel++)
    {
        _buffer[channel]    = new CRingBuffer<float> (kMaxSamples);
        _grain[channel]     = new CRingBuffer<float> (kMaxSamples * 0.5f);
    }
    
    for (int i=0; i < kEnvelopeSamples; i++)
    {
        _envelope[i] = tanhf(i / 4.0f);
    }
    
    _sizePerGrain           =   0.5f;
    _rateInSeconds          =   0.1f;
    _attackTime             =   0.5f; // % grain size
    _startIndex             =   0;
    _samplesBuffered        =   0;
    _sizeInSamples          =   0;
    _rateInSamples          =   0;
    _floatIndex             =   0.0f;
    _bufferingToggle        =   false;
    _grainToggle            =   false;
    
    setTempo(120.0f);
    
    calculateParameters();
    
    _sampleCount            =   _rateInSamples;
}

BMGranularizer::~BMGranularizer()
{
    for (int channel = 0; channel < _numChannels; channel++)
    {
        delete _buffer[channel];
        delete _grain[channel];
    }
    
    delete [] _buffer;
    delete [] _grain;
}


void BMGranularizer::setParameter(int parameterID, float value)
{
    if (value > 1.0f) {
        value = 1.0f;
    }

    switch (parameterID)
    {
        case 0:
            if (value < 0.03f) {
                value = 0.03f;
            }
            _rateInSeconds = value;
            calculateParameters();
            break;
            
        case 1:
            _sizePerGrain = (1.0f - value);
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
            return (1.0f - _sizePerGrain);
            break;
            
        case 2:
            return _attackTime;
            break;
            
        default:
            return 0.0f;
            break;
    }
}


void BMGranularizer::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate = sampleRate;
    calculateParameters();
}


void BMGranularizer::process(float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        _sampleCount--;
        
        if (_sampleCount <= 0)
        {
            generateGrain();
            _sampleCount = _rateInSamples;
            _grainToggle = true;
        }
        
        //--- Initially check number of samples buffered ---//
        if (!_bufferingToggle)
        {
            _samplesBuffered++;
            
            if (_samplesBuffered >= kMaxSamples)
            {
                _bufferingToggle = true;
            }
        }
        
        
        for (int channel = 0; channel < _numChannels; channel++)
        {
            _buffer[channel]->putPostInc(buffer[channel][sample]);
            
            if (_grainToggle)
            {
                buffer[channel][sample] = _grain[channel]->getPostInc();
            }
            
        }
    }
    
}


void BMGranularizer::generateGrain()
{
    int randomIndex = ((double) rand() / (RAND_MAX)) * _samplesBuffered;
    _startIndex = randomIndex - (randomIndex % _quantizationInterval);
    if (_startIndex < 0)
        _startIndex = 0;
    
    for (int channel = 0; channel < _numChannels; channel++)
    {
        _grain[channel]->resetIndices();
        
        for (int sample = 0; sample < (_sizeInSamples / 1.0f); sample++)
        {
            _floatIndex = _startIndex + (sample * 1.0f);
            
            if (sample < kEnvelopeSamples)
            {
                _grain[channel]->putPostInc(_buffer[channel]->getAtFloatIdx(_floatIndex) * _envelope[sample]);
            }
            
            else
            {
                _grain[channel]->putPostInc(_buffer[channel]->getAtFloatIdx(_floatIndex));
            }
            
        }
        
        for (int sample = 0; sample < _rateInSamples - (_sizeInSamples / 1.0f); sample++)
        {
            _grain[channel]->putPostInc(0.0f);
        }
    }
    
}


void BMGranularizer::calculateParameters()
{
    _rateInSamples = _rateInSeconds * _sampleRate;
    _sizeInSamples = (((1.0f - _sizePerGrain) * 0.99f) + 0.01f) * _rateInSamples;
}


void BMGranularizer::releaseResources()
{
    for (int channel = 0; channel < _numChannels; channel++)
    {
        _grain[channel]->resetInstance();
        _buffer[channel]->resetInstance();
        _bufferingToggle = false;
        _grainToggle     = false;
        _samplesBuffered = 0;
    }
}


void BMGranularizer::setTempo(float tempo)
{
    _tempo = tempo;
    _quantizationInterval = (60.0f / (_tempo * 4.0f)) * _sampleRate;
    
    for (int channel = 0; channel < _numChannels; channel++)
    {
        _buffer[channel]->setWrapPoint(kMaxSamples - (kMaxSamples % _quantizationInterval));
    }
}