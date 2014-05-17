//==============================================================================
//
//  Wah.h
//  BeMotion
//
//  Created by Cian O'Brien on 4/22/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================

#if !defined(__Wah_hdr__)
#define __Wah_hdr__

#include <Math.h>
#include "Macros.h"

/*	Wah
	----------------
	Paramaters:	
        - Theta "Pedal Value"
		- Gain
*/

class CWah
{
public:

	CWah(int NumChannels);
	~CWah ();

	// set:
	void setParam(/*hFile::enumType type*/ int type, float value);
	//get
	float getParam(/*hFile::enumType type*/ int type);

	void prepareToPlay(float sampleRate);

	void initDefaults();

	// process:
	void process(float **inputBuffer, int numFrames, bool bypass);

private:

	void calculateCoeffs();

	float **buff;

	float m_fTempVal;

	float m_fSampleRate;
	int   m_iNumChannels;

	float m_fGain;
	float m_fTheta;		// pedal value
	float m_fQscale;
	float m_fGainScale;

	float m_fReso;
	float m_fQ;

	float m_fPoleAngle;

	float m_fFrn;

	float m_fCoeff2;
	float m_fCoeff3;
};

#endif
