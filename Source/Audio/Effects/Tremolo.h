//==============================================================================
//
//  Tremolo.h
//  GestureController
//
//  Created by Cian O'Brien on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#if !defined(__Tremolo_hdr__)
#define __Tremolo_hdr__

#include "LFO.h"
#include <Math.h>

/*	Tremolo
	----------------
	Paramaters:	
		- Depth
		- Rate
*/

class CTremolo
{
public:

	CTremolo(int NumChannels);
	~CTremolo ();

	// set:
	void setParam(/*hFile::enumType type*/ int type, float value);
	// get:
	float getParam(/*hFile::enumType type*/ int type);
	void prepareToPlay(float sampleRate);

	void initDefaults();
	
	void setType(CLFO::LFO_Type type);

	// process:
	void process(float **inputBuffer, int numFrames, bool bypass);

private:

	CLFO *LFO;

	float m_fSampleRate;
	int   m_iNumChannels;

	float m_fDepth;
	float m_fRate;

};

#endif
