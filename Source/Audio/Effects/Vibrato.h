//
//  Vibrato.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __GestureController__Vibrato__
#define __GestureController__Vibrato__

#include "RingBuffer.h"
#include "LFO.h"
#include "Macros.h"

#define DEFAULT_SAMPLING_RATE   44100

class CVibrato
{
    
public:
    
    CVibrato (int iNumChannels);
    ~CVibrato ();
    
    
    
    //--- Main Vibrato Process Method ---//
    void prepareToPlay(float sampleRate);
    void process(float** audioBuffer, int blockSize, bool bypassState);
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
    
    
    //--- Set and Get Modulation Type --//
    void setModulationType(CLFO::LFO_Type type);
    
    //--- Get Max Allowed Modulation Width in ms ---//
    float getMaxModulationWidth_ms();
    
    //--- Set Sampling Rate in Hz --//
    void setSampleRateInHz(float sampleRate);
    
    
    
    
    float       m_fSampleRate;
    float       m_fModulatingSample;
    float       m_fFloatIndex;
	float		m_iModulation_Freq_Hz;
	long        m_iModulation_Width_Samples;
    int         m_iNumChannels;
    
    float fPhase;
    
    CRingBuffer<float>** m_CRingBuffer;
    CLFO** m_CLFO;
    
    float* m_pfLFOBuffer;
};





#endif /* defined(__GestureController__Vibrato__) */
