#if !defined(__CLFO_hdr__)
#define __CLFO_hdr__

class CLFO
{
public:
    
    
    CLFO(float fSamplingFreq);
    ~CLFO();
    
    
    enum LFO_Type
    {
        kSin,
        kSquare,
        kTriangle
    };
    
    
    //--- Set, Get Methods for Parameters ---//
    
    void setFrequencyinHz(float frequency);
    float getFrequencyinHz();
    
    void setLFOType(LFO_Type lfoType);
    LFO_Type getLFOType();
    
    //--- Generate LFO ---//
    void generate(int bufferLengthToFill);
    
	//--- Get LFO sample data ---//
    float getLFOSampleData(int index);
    
private:
    
    static const int m_kWaveTableSize = 4096;
    

    float m_fSampleRate;
    float m_fFrequency;
    LFO_Type m_eLFOType;
    
    int m_iPhase;
    float m_fIncrement;
    
    float m_fFloatIndex;
    float m_fWrappedIndex;
    float m_fSlope;                     // Linear Interpolation
    
    float m_pfSineWaveTable[4096];
    float m_pfSquareWaveTable[4096];
    float m_pfTriangleWaveTable[4096];
    
	float m_pfBufferData[4096];
    
};

#endif