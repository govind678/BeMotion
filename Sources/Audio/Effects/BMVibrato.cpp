/*
  ==============================================================================

    BMVibrato.cpp
    Created: 1 Feb 2016 3:17:08pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMVibrato.h"

static const float kVibratoMaxModWidth = 50.0f;
static const float kSmoothFactor = 0.001f;

BMVibrato::BMVibrato(int numChannels)

{
    _sampleRate = 48000.0f;
    _numChannels = numChannels;
    
    _modulation_Freq_Hz           =   5.0f;
    _shape                        =   0.01f;
    _currentModulation            =   100.0f;
    _newModulation                =   100.0f;
    
    _ringBuffer = new CRingBuffer<float>*[_numChannels];
    for (int channel=0; channel < _numChannels; channel++)
    {
        _ringBuffer[channel] = new CRingBuffer<float>(2 * (kVibratoMaxModWidth  * _sampleRate) / 1000.0f);
        _ringBuffer[channel]->setWriteIdx(_ringBuffer[channel]->getReadIdx() + kVibratoMaxModWidth - 1);
    }
    
    _lfo = new BMOscillator();
    _lfo->setShape(_shape);
    _lfo->setNormalizedFrequency(_modulation_Freq_Hz / _sampleRate);
}



BMVibrato::~BMVibrato()
{
    for (int channel = 0; channel < _numChannels; channel++)
    {
        delete _ringBuffer[channel];
    }
    delete _ringBuffer;
    
    delete _lfo;
}


void BMVibrato::reset()
{
    _lfo->restart();
}

void BMVibrato::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate   =  sampleRate;
    _lfo->setNormalizedFrequency(_modulation_Freq_Hz / sampleRate);
}



void BMVibrato::process(float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        float lfoSample = _lfo->getNextSample();
        float width = getModulationWidth();
        
        //-- Iterate Through Samples in Each Block --//
        for(int channel=0; channel < numChannels; channel++)
        {
            _floatIndex = ((1.0f + lfoSample) * width);
            
            float currentIndex = _ringBuffer[channel]->getWriteIdx() - _floatIndex;
            
            _ringBuffer[channel]->putPostInc(buffer[channel][sample]);
            
            buffer[channel][sample] = (_ringBuffer[channel]->getAtFloatIdx(currentIndex));
        }
        
    }
}


void BMVibrato::releaseResources()
{
    
}



void BMVibrato::setParameter(int parameterID, float value)
{
    if (value < 0.0f)
        value = 0.0f;
    else if (value > 1.0f)
        value = 1.0f;
    
    
    switch (parameterID)
    {
        case 0:
            _modulation_Freq_Hz = 20.0f * value;
            _lfo->setNormalizedFrequency(_modulation_Freq_Hz / _sampleRate);
            break;
            
        case 1:
            _newModulation = ((value * kVibratoMaxModWidth * _sampleRate) / 1000.0f) + 0.5f;
            break;
            
        case 2:
            _shape = value;
            _lfo->setShape(_shape);
            break;
            
        default:
            break;
    }
    
}


float BMVibrato::getParameter(int parameterID)
{
    switch (parameterID)
    {
        case 0:
            return (_modulation_Freq_Hz / 20.f);
            break;
            
        case 1:
            return ((_newModulation - 0.5f) * 1000.0f) / (kVibratoMaxModWidth * _sampleRate);
            break;
            
        case 2:
            return _shape;
            break;
            
        default:
            return 0.0f;
            break;
    }
}


float BMVibrato::getModulationWidth()
{
    _currentModulation = (kSmoothFactor * _newModulation) + ((1.0f - kSmoothFactor) * _currentModulation);
    return _currentModulation;
}
