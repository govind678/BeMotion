/*
  ==============================================================================

    BMVibrato.cpp
    Created: 1 Feb 2016 3:17:08pm
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "BMVibrato.h"

static const float kVibratoMaxModWidth = 100.0f;

BMVibrato::BMVibrato(int numChannels)

{
    _sampleRate = 48000.0f;
    _numChannels = numChannels;
    
    _modulation_Freq_Hz           =   5.0f;
    _modulation_Width_Samples     =   100;
    _shape                        =   0.01f;
    
    _ringBuffer = new CRingBuffer<float>*[_numChannels];
    for (int channel=0; channel < _numChannels; channel++)
    {
        _ringBuffer[channel] = new CRingBuffer<float>(2 * (kVibratoMaxModWidth  * _sampleRate) / 1000.0f);
    }
    
    _lfo = new Oscillator();
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
        
        //-- Iterate Through Samples in Each Block --//
        for(int channel=0; channel < numChannels; channel++)
        {
            _floatIndex = ((1.0f + lfoSample) * _modulation_Width_Samples);
            
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
            _modulation_Width_Samples = int(((value * kVibratoMaxModWidth * _sampleRate) / 1000.0f) + 0.5f);
            for (int channel = 0; channel < _numChannels; channel++)
            {
                _ringBuffer[channel]->setWriteIdx(_ringBuffer[channel]->getReadIdx() + (2.0f * _modulation_Width_Samples));
            }
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
            return ((float(_modulation_Width_Samples) - 0.5f) * 1000.0f) / (kVibratoMaxModWidth * _sampleRate);
            break;
            
        case 2:
            return _shape;
            break;
            
        default:
            return 0.0f;
            break;
    }
}
