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
    
	m_fModulatingSample             =   0.0f;
	m_iModulation_Freq_Hz           =   0.0f;
    m_iModulation_Width_Samples     =   0.0f;
    fPhase                          =   0.0f;
    m_fShape                        =   0.0f;
    
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



void CVibrato::process(float** audioBuffer, int blockSize)
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
            
            m_fShape = value;
            setShape(value);
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
            return m_fShape;
            break;
            
        default:
            return 0.0f;
            break;
    }
}


void CVibrato::initializeDefaults()
{
    m_iModulation_Freq_Hz   =   4.0;
    setShape(0.0f);
    setModulationFrequency_Hz(4.0);
    setModulationWidth_ms(100);
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

void CVibrato::setShape(float shape)
{
    for (int channel = 0; channel < m_iNumChannels; channel++) {
        m_CLFO[channel]->setShape(shape);
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