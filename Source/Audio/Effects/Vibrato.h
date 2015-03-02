//==============================================================================
//
//  Vibrato.h
//  BeatMotion
//
//  Created by Anand Mahadevan and Govinda Ram Pingali on 3/10/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================


#ifndef __BeatMotion__Vibrato__
#define __BeatMotion__Vibrato__

#include "RingBuffer.h"
#include "LFO.h"
#include "Macros.h"

class CVibrato
{
    
public:
    
    CVibrato (int iNumChannels);
    ~CVibrato ();
    
    
    
    //--- Main Vibrato Process Method ---//
    void prepareToPlay(float sampleRate);
    void process(float** audioBuffer, int blockSize);
    void finidhedPlaying();
    
    void setParam(int parameterID, float value);
    float getParam(int parameterID);
    
    
    
private:
    
    
    void initializeDefaults();
    
    //--- Set and Get Modulation Frequency in Hz ---//
    void  setModulationFrequency_Hz(float current_mod_freq_Hz);
    float getModulationFrequency_Hz();
    
	//--- Set and Get Modulation Width in ms ---//
    void  setModulationWidth_ms(int current_mod_width_ms);
    int getModulationWidth_ms();
    
    
    //--- Set and Get LFO Shape --//
    void setShape(float shape);
    
    //--- Get Max Allowed Modulation Width in ms ---//
    float getMaxModulationWidth_ms();
    
    //--- Set Sampling Rate in Hz --//
    void setSampleRateInHz(float sampleRate);
    
    
    
    
    float       m_fSampleRate;
    float       m_fModulatingSample;
    float       m_fFloatIndex;
	float		m_iModulation_Freq_Hz;
	int         m_iModulation_Width_Samples;
    int         m_iNumChannels;
    float       m_fShape;
    
    float fPhase;
    
    CRingBuffer<float>** m_CRingBuffer;
    CLFO** m_CLFO;
    
    float*     m_pfLFOBuffer;
    
    
    bool       m_bLFOInitialized;
};





#endif /* defined(__BeatMotion__Vibrato__) */
