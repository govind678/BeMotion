//****************************************************************************************************
// Low Frequency Oscillator Class
//
// Interface functions:
// Set and Get LFO Frequency
// Set and Get LFO Type (Sin, Square or Triangle)
// Generate section of LFO
//****************************************************************************************************

#include "LFO.h"
#include "Util.h"
#include "math.h" 
#define M_PI 3.14159

CLFO::CLFO(float fSampleRate)
{
    
    m_fSampleRate = fSampleRate;
    CUtil::setZero(m_pfBufferData, m_kWaveTableSize);
    
    //--- Generate Wave Tables ---//
    
    //- Sine and Square from Sine -//
    for (int sample = 0; sample < m_kWaveTableSize; sample++) {
        m_pfSineWaveTable[sample] = sinf(2*M_PI*sample / m_kWaveTableSize);
        
        if (m_pfSineWaveTable[sample] >= 0) {
            m_pfSquareWaveTable[sample] = 1;
        }
        else {
            m_pfSquareWaveTable[sample] = -1;
        }
    }
    
    //- Triangle from Sine -//
    float m_iAmplitude = 0.0;
    float m_fDelta = 4.0 / m_kWaveTableSize;
    
    m_pfTriangleWaveTable[0] = 0;
    for (int sample = 1; sample < m_kWaveTableSize; sample++) {
        if ((m_pfSineWaveTable[sample] - m_pfSineWaveTable[sample-1]) >= 0) {
            m_iAmplitude += m_fDelta;
        } else {
            m_iAmplitude -= m_fDelta;
        }
        m_pfTriangleWaveTable[sample] = m_iAmplitude;
        
    }
    
    //--- Initialize Defaults ---//
    m_eLFOType      = kSin;
    m_fFrequency    = m_fSampleRate / m_kWaveTableSize;
    m_iPhase        = 0;
    m_fIncrement    = m_kWaveTableSize * m_fFrequency / m_fSampleRate;
    m_fFloatIndex   = 0;
    m_fWrappedIndex = 0;
    m_fSlope        = 0;
    
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

//--- Set, Get LFO Wave Type in Hz ---//
void CLFO::setLFOType(LFO_Type lfoType)
{
    m_eLFOType = lfoType;
}

CLFO::LFO_Type CLFO::getLFOType()
{
    return m_eLFOType;
}

//--- Generate LFO ---//
void CLFO::generate(int bufferLengthToFill)
{
    
    for (int sample = 0; sample < bufferLengthToFill; sample++) {
        
        //-- Create Float Index --//
        m_fFloatIndex = ((sample + m_iPhase) * m_fIncrement);
        
        //-- Wrap to Table Size --//
        m_fWrappedIndex = fmod(m_fFloatIndex, m_kWaveTableSize);
        
        //-- Linear Interpolation --//
        
        //***************************************** MATLAB Code ************************************************************//
        //* slope = waveTable(mod(floor(floatIndex), tableSize) + 1) - waveTable(mod(floor(floatIndex)-1,tableSize) + 1);
        //* output(i) = slope * (wrapFloatIndex - floor(wrapFloatIndex)) + waveTable(floor(wrapFloatIndex));
        //******************************************************************************************************************//
        
        if (m_eLFOType == kSin) {
            m_fSlope = m_pfSineWaveTable[int((floorf(m_fFloatIndex) + 1)) % m_kWaveTableSize] -
            m_pfSineWaveTable[int((floorf(m_fFloatIndex))) % m_kWaveTableSize];
            m_pfBufferData[sample] = m_fSlope * (m_fWrappedIndex - floorf(m_fWrappedIndex)) + m_pfSineWaveTable[int(floorf(m_fWrappedIndex))];
        }
        
        else if (m_eLFOType == kSquare) {
            m_fSlope = m_pfSquareWaveTable[int((floorf(m_fFloatIndex) + 1)) % m_kWaveTableSize] -
            m_pfSquareWaveTable[int((floorf(m_fFloatIndex))) % m_kWaveTableSize];
            m_pfBufferData[sample] = m_fSlope * (m_fWrappedIndex - floorf(m_fWrappedIndex)) + m_pfSquareWaveTable[int(floorf(m_fWrappedIndex))];
        }
        
        else if (m_eLFOType == kTriangle) {
            m_fSlope = m_pfTriangleWaveTable[int((floorf(m_fFloatIndex) + 1)) % m_kWaveTableSize] -
            m_pfTriangleWaveTable[int((floorf(m_fFloatIndex))) % m_kWaveTableSize];
            m_pfBufferData[sample] = m_fSlope * (m_fWrappedIndex - floorf(m_fWrappedIndex)) + m_pfTriangleWaveTable[int(floorf(m_fWrappedIndex))];
        }
        
    }
    
    m_iPhase = fmodf(m_iPhase + bufferLengthToFill, (m_kWaveTableSize / m_fIncrement));
}

//--- Get LFO Sample at Index ---//
float CLFO::getLFOSampleData(int index)
{
	return (m_pfBufferData[index]);
}

