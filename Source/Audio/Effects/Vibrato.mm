//==============================================================================
//
//  Vibrato.mm
//  BeMotion
//
//  Created by Anand Mahadevan and Govinda Ram Pingali on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#include "Vibrato.h"

CVibrato::CVibrato(int iNumChannels)

{
	m_fSampleRate = DEFAULT_SAMPLE_RATE;
	m_iNumChannels = iNumChannels;
    
	m_fModulatingSample             =   0;
	m_iModulation_Freq_Hz           =   0;
    m_iModulation_Width_Samples     =   0;
    fPhase                          =   0;
    
    m_bLFOInitialized               =   false;
    
	m_CRingBuffer = new CRingBuffer<float>*[m_iNumChannels];
    for (int channel=0; channel<m_iNumChannels; channel++)
    {
        m_CRingBuffer[channel] = new CRingBuffer<float>( 2 * (VIBRATO_MAX_MOD_WIDTH  * m_fSampleRate) / 1000);
    }
    
    
    m_CLFO = new CLFO*[m_iNumChannels];
    for (int channel = 0; channel < m_iNumChannels; channel++) {
        m_CLFO[channel] = new CLFO(DEFAULT_SAMPLE_RATE);
    }
    m_bLFOInitialized   =   true;
    
    initializeDefaults();
}



CVibrato::~CVibrato()
{
    
    if (m_bLFOInitialized)
    {
        delete [] m_CLFO;
    }
    
	delete [] m_CRingBuffer;
}



void CVibrato::prepareToPlay(float sampleRate)
{
    m_fSampleRate   =  sampleRate;
    
    for (int channel = 0; channel < m_iNumChannels; channel++)
    {
        m_CLFO[channel]->setSampleRate(m_fSampleRate);
    }
}



void CVibrato::process(float** audioBuffer, int blockSize, bool bypassState)
{
    
    if(!bypassState)
    {
    
    for (int channel = 0; channel < m_iNumChannels; channel++) {
        m_CLFO[channel] -> generate(blockSize);
    }
    
	for (int sample=0; sample < blockSize; sample++)
    {
        //-- Iterate Through Samples in Each Block --//
        for(int channel=0; channel < m_iNumChannels; channel++)
        {
            
            //-- Vibrato !!! --//
            m_fModulatingSample = 1 + m_CLFO[channel]->getLFOSampleData(sample);
            m_fFloatIndex = (m_fModulatingSample * m_iModulation_Width_Samples);
            
            float currentIndex = m_CRingBuffer[channel]->getWriteIdx() - m_fFloatIndex;
            
            m_CRingBuffer[channel]->putPostInc(audioBuffer[channel][sample]);
            
            audioBuffer[channel][sample] = (m_CRingBuffer[channel]->getAtFloatIdx(currentIndex));
        }
        
    }
    
    }

}


void CVibrato::finidhedPlaying()
{
    
}



void CVibrato::setParam(int parameterID, float value)
{
    switch (parameterID)
    {
        case PARAM_1:
            m_iModulation_Freq_Hz   =   20.0f * value;
//            setModulationFrequency_Hz(m_iModulation_Freq_Hz);
            setModulationFrequency_Hz(value);
            break;
            
        case PARAM_2:
            m_iModulation_Width_Samples =   value * VIBRATO_MAX_MOD_WIDTH;
            setModulationWidth_ms(m_iModulation_Width_Samples);
            break;
            
        case PARAM_3:
            
            if ((value >= 0) && (value < 0.33))
            {
                setModulationType(CLFO::kSin);
            }
            
            else if ((value >= 0.33) && (value < 0.66))
            {
                setModulationType(CLFO::kTriangle);
            }
            
            else
            {
                setModulationType(CLFO::kSquare);
            }
            break;
            
        default:
            break;
    }
    
}


float CVibrato::getParam(int parameterID)
{
    switch (parameterID)
    {
        case PARAM_1:
            return (m_iModulation_Freq_Hz / 20.f);
            break;
            
        case PARAM_2:
            return (m_iModulation_Width_Samples / VIBRATO_MAX_MOD_WIDTH);
            break;
            
        case PARAM_3:
            
            if (m_kLFOType == CLFO::kSin)
            {
                return 0.165f;
            }
            
            else if (m_kLFOType == CLFO::kTriangle)
            {
                return 0.495f;
            }
            
            else
            {
                return 0.825f;
            }
            
            break;
            
        default:
            return 0.0f;
            break;
    }
}


void CVibrato::initializeDefaults()
{
    m_iModulation_Freq_Hz   =   4.0;
    m_kLFOType              =   CLFO::kSin;
    setModulationFrequency_Hz(4.0);
    setModulationWidth_ms(100);
    setModulationType(m_kLFOType);
}


void CVibrato::setModulationWidth_ms(int current_mod_width_ms)
{
	m_iModulation_Width_Samples =  int(((current_mod_width_ms * m_fSampleRate) / 1000.0f) + 0.5f);
	
	for (int channel=0; channel < m_iNumChannels; channel++)
    {
		m_CRingBuffer[channel] -> setWriteIdx(m_CRingBuffer[channel]->getReadIdx() + (2 * m_iModulation_Width_Samples));
    }
}


void CVibrato::setModulationFrequency_Hz(float current_mod_freq_Hz)
{
	m_iModulation_Freq_Hz = current_mod_freq_Hz;
    
    for (int channel = 0; channel < m_iNumChannels; channel++) {
        m_CLFO[channel] -> setFrequencyinHz(current_mod_freq_Hz);
    }
	
}

void CVibrato::setModulationType(CLFO::LFO_Type type)
{
    for (int channel = 0; channel < m_iNumChannels; channel++) {
        m_CLFO[channel] -> setLFOType(type);
    }
}



int CVibrato::getModulationWidth_ms()
{
	return m_iModulation_Width_Samples;
}


float CVibrato::getModulationFrequency_Hz()
{
	return m_iModulation_Freq_Hz;
}


void CVibrato::setSampleRateInHz(float sampleRate)
{
    m_fSampleRate = sampleRate;
}