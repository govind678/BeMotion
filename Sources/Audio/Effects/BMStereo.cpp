/*
  ==============================================================================
 
    BMStereo.cpp
    Created: 16 Feb 2016 11:25:08pm
    Author:  Govinda Pingali
 
  ==============================================================================
 */

#include "BMStereo.h"
#include <math.h>

static const float kSmoothFactor = 0.001;

BMStereo::BMStereo()
{
    _currentPanPosition = _newPanPosition = 0.5f;
}


BMStereo::~BMStereo()
{
    
}


//========= AudioEffect =========//

void BMStereo::prepareToPlay (int samplesPerBlockExpected, double sampleRate)
{
    
}


void BMStereo::process (float** buffer, int numChannels, int numSamples)
{
    for (int sample = 0; sample < numSamples; sample++)
    {
        float position = getPanPosition();
        
        buffer[0][sample] *= cosf(position * M_PI_2);
        buffer[1][sample] *= sinf(position * M_PI_2);
    }
}


void BMStereo::releaseResources()
{
    
}


/** Parameters */

void BMStereo::setParameter(int parameterID, float value)
{
    _newPanPosition = value;
}

float BMStereo::getParameter(int parameterID)
{
    return _newPanPosition;
}


float BMStereo::getPanPosition()
{
    _currentPanPosition = (kSmoothFactor * _newPanPosition) + ((1.0f - kSmoothFactor) * _currentPanPosition);
    return _currentPanPosition;
}

