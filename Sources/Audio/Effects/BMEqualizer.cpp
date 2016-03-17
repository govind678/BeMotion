/*
 ==============================================================================
 
    BMEqualizer.cpp
    Created: 3 Mar 2016 4:56:34pm
    Author:  Govinda Pingali
 
 ==============================================================================
*/

#include "BMEqualizer.h"

BMEqualizer::BMEqualizer()
{
    _newHighsGain       = 0.5f;
    _currentHighsGain   = 0.5f;
    
    _newMidsGain        = 0.5f;
    _currentMidsGain    = 0.5f;
    
    _newLowsGain        = 0.5f;
    _currentLowsGain    = 0.5f;
}

BMEqualizer::~BMEqualizer()
{
    
}

void BMEqualizer::reset()
{
    
}

void BMEqualizer::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    _sampleRate   =  sampleRate;
}



void BMEqualizer::process(float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        for(int channel=0; channel < numChannels; channel++)
        {
            
        }
    }
}


void BMEqualizer::releaseResources()
{
    
}



void BMEqualizer::setParameter(int parameterID, float value)
{
    if (value < 0.0f)
        value = 0.0f;
    else if (value > 1.0f)
        value = 1.0f;
    
    
    switch (parameterID)
    {
        case 0:
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        default:
            break;
    }
    
}


float BMEqualizer::getParameter(int parameterID)
{
    switch (parameterID)
    {
        case 0:
            return 0.0f;
            break;
            
        case 1:
            return 0.0f;
            break;
            
        case 2:
            return 0.0f;
            break;
            
        default:
            return 0.0f;
            break;
    }
}
