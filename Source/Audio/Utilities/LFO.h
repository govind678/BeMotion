//==============================================================================
//
//  LFO.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 2/14/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#if !defined(__CLFO_hdr__)
#define __CLFO_hdr__


class CLFO
{
public:
    
    
    CLFO(float fSamplingFreq);
    ~CLFO();
    
    //--- Set, Get Methods for Parameters ---//
    
    void setFrequencyinHz(float frequency);
    float getFrequencyinHz();
    
    void setShape(float shape);
    float getShape();
    
    //--- Generate LFO ---//
    void generate(int bufferLengthToFill);
    
	//--- Get LFO sample data ---//
    float getLFOSampleData(int index);
    
    void setSampleRate(float sampleRate);
    
private:
    
    static const int m_kWaveTableSize = 4096;
    

    float m_fSampleRate;
    float m_fFrequency;
    float m_fShape;
    float m_fScale;
    
    int m_iPhase;
    float m_fIncrement;
    
    float m_fFloatIndex;
    float m_fWrappedIndex;
    float m_fSlope;                     // Linear Interpolation
    
    float m_fSample;
    
    float m_pfSineWaveTable[4096];
	float m_pfBufferData[4096];
    
};

#endif