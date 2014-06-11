//==============================================================================
//
//  LFO.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 2/14/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//=====================================================
//
// Low Frequency Oscillator Class
//
// Interface functions:
// Set and Get LFO Frequency
// Set and Get LFO Type (Sin, Square or Triangle)
// Generate section of LFO
//
//==============================================================================


#include "LFO.h"
#include "CUtil.h"
#include <math.h>
//#define M_PI 3.14159

CLFO::CLFO(float fSampleRate)
{
    
    m_fSampleRate = fSampleRate;
    CUtil::setZero(m_pfBufferData, m_kWaveTableSize);
    
    
    //--- Generate Sine Wave Table ---//
    
    for (int sample = 0; sample < m_kWaveTableSize; sample++)
    {
        m_pfSineWaveTable[sample] = sinf(2 * M_PI * sample / m_kWaveTableSize);
    }
    

    //--- Initialize Defaults ---//
    m_fFrequency    = m_fSampleRate / m_kWaveTableSize;
    m_iPhase        = 0;
    m_fIncrement    = m_kWaveTableSize * m_fFrequency / m_fSampleRate;
    m_fFloatIndex   = 0.0f;
    m_fWrappedIndex = 0.0f;
    m_fSlope        = 0.0f;
    m_fScale        = 0.0f;
    m_fSample       = 0.0f;
    
}

CLFO::~CLFO()
{
    //This class uses only static allocated arrays
}

//--- Set, Get LFO Frequency in Hz ---//
void CLFO::setFrequencyinHz(float frequency)
{
    m_fFrequency = frequency;
    m_fIncrement = m_kWaveTableSize * m_fFrequency / m_fSampleRate;
}

float CLFO::getFrequencyinHz()
{
    return m_fFrequency;
}


void CLFO::setShape(float shape)
{
    m_fShape = shape;
    m_fScale = 20.0f * powf(1000.0f, (m_fShape - 1.0f));
}

float CLFO::getShape()
{
    return m_fShape;
}



//--- Generate LFO ---//
void CLFO::generate(int bufferLengthToFill)
{
    
    for (int sample = 0; sample < bufferLengthToFill; sample++)
    {
        //-- Create Float Index --//
        m_fFloatIndex = ((sample + m_iPhase) * m_fIncrement);
        
        //-- Wrap to Table Size --//
        m_fWrappedIndex = fmod(m_fFloatIndex, m_kWaveTableSize);
        
        //-- Linear Interpolation --//
        
        //***************************************** MATLAB Code ************************************************************//
        //* slope = waveTable(mod(floor(floatIndex), tableSize) + 1) - waveTable(mod(floor(floatIndex)-1,tableSize) + 1);
        //* output(i) = slope * (wrapFloatIndex - floor(wrapFloatIndex)) + waveTable(floor(wrapFloatIndex));
        //******************************************************************************************************************//
        
        m_fSlope = m_pfSineWaveTable[int((floorf(m_fFloatIndex) + 1)) % m_kWaveTableSize] -
        m_pfSineWaveTable[int((floorf(m_fFloatIndex))) % m_kWaveTableSize];
        m_fSample = m_fSlope * (m_fWrappedIndex - floorf(m_fWrappedIndex)) + m_pfSineWaveTable[int(floorf(m_fWrappedIndex))];
        
        
        //-- Shape interpolated sample --//
        m_pfBufferData[sample] = tanhf(m_fScale * m_fSample) / tanhf(m_fScale);
    }
    
    m_iPhase = fmodf(m_iPhase + bufferLengthToFill, (m_kWaveTableSize / m_fIncrement));
}


//--- Get LFO Sample at Index ---//
float CLFO::getLFOSampleData(int index)
{
	return (m_pfBufferData[index]);
}

void CLFO::setSampleRate(float sampleRate)
{
    m_fSampleRate   = sampleRate;
    m_fIncrement    = m_kWaveTableSize * m_fFrequency / m_fSampleRate;
}

