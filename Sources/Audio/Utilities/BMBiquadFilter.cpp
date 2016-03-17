/*
 ==============================================================================
 
    BMBiquadFilter.cpp
    Created: 3 Mar 2016 5:15:17pm
    Author:  Govinda Pingali
 
 ==============================================================================
 */

#include "BMBiquadFilter.h"

BMBiquadFilter::BMBiquadFilter(int numChannels)
{
    _numChannels = numChannels;
    
    _x1 = new float[numChannels];
    _x2 = new float[numChannels];
    _y1 = new float[numChannels];
    _y2 = new float[numChannels];
    
    _a0 = 1;
    _a1 = 2;
    _a2 = 1;
    _b0 = 1;
    _b1 = 2;
    _b2 = 1;
}

BMBiquadFilter::~BMBiquadFilter()
{
    delete [] _x1;
    delete [] _x2;
    delete [] _y1;
    delete [] _y2;
}

void BMBiquadFilter::setCoefficients(float a0, float a1, float a2, float b0, float b1, float b2)
{
    _a0 = a0;
    _a1 = a1;
    _a2 = a2;
    _b0 = b0;
    _b1 = b1;
    _b2 = b2;
}

void BMBiquadFilter::process(float **buffer, int numChannels, int numSamples)
{
    for (int sample=0; sample < numSamples; sample++)
    {
        for (int channel=0; channel < numChannels; channel++)
        {
            float x0 = buffer[channel][sample];
            
            buffer[channel][sample] = ( (_b0 * x0) + (_b1 * _x1[channel]) + (_b2 * _x2[channel]) -
                                       (_a1 * _y1[channel]) - (_a2 * _y2[channel])) / _a0;
            
            _x2[channel] = _x1[channel];
            _x1[channel] = x0;
            _y2[channel] = _y1[channel];
            _y1[channel] = buffer[channel][sample];
        }
    }
}
