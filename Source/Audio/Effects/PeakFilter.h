#if !defined(__PeakFilter_hdr__)
#define __PeakFilter_hdr__

#include <Math.h>

/*	PeakFilter
	----------------
	Paramaters:	
		- Cutoff
		- Bandwidh
		- Gain
*/

class CPeakFilter
{
public:

	CPeakFilter(int NumChannels);
	~CPeakFilter ();

	// set:
	void setParam(/*hFile::enumType type*/ int type, float value);
	// get:
	float getParam(/*hFile::enumType type*/ int type);
	void prepareToPlay(float sampleRate);

	void initDefaults();

	// process:
	void process(float **inputBuffer, int numFrames, bool bypass);

private:

	float **buff;

	float m_fSampleRate;
	int   m_iNumChannels;

	// Normalized frequencies: 
	float m_fCentreFreq;
	float m_fBandwidth;
	float m_fGainInDB;

	float m_fC;
	float m_fD;
	float m_fH;
	float m_fNewVal;
	float m_fTemp;

};

#endif
