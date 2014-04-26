#include "Wah.h"
#include <stdio.h>
#include <iostream>

CWah::CWah(int numChannels)
{
	m_iNumChannels = numChannels;

	buff = new float *[numChannels];

	for (int c = 0; c < numChannels ; c++)
	{
		buff[c]		= new float [2];
		buff[c][0]	= 0;
		buff[c][1]	= 0;
	}
}

void CWah::prepareToPlay(float sampleRate)
{
	m_fSampleRate = sampleRate;
	initDefaults();
}

void CWah::initDefaults()
{
	setParam(0, 0.0);
	setParam(1, 1.0);
	setParam(2, 1.0);
}

void CWah::calculateCoeffs()
{
	m_fGain			= m_fGainScale*0.1*(powf(4.0, m_fTheta+0.1));
	m_fQ			= powf(2.0, 2.5*(1.0 - m_fTheta)+1);
	m_fReso			= 450.0 * (powf(2.0, 2.0 * m_fQscale * m_fTheta));
	m_fFrn			= m_fReso / m_fSampleRate;
	m_fPoleAngle	=  2.0 * M_PI * m_fFrn;
	m_fCoeff2		= -2.0 * (1 - M_PI* m_fFrn / m_fQ) * cos(m_fPoleAngle);
	m_fCoeff3		= (1.0 - M_PI * m_fFrn / m_fQ)*(1.0 - M_PI * m_fFrn / m_fQ);

}
void CWah::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		// gain
		case PARAM_1:

			if (0.0 <= value && value <= 1.0){

				m_fGainScale = value * value;
				calculateCoeffs();
			}
				
		break;

		case PARAM_2:

			if (0.0 <= value && value <= 1.0){

				m_fTheta	= value;	// "pedal" value
				calculateCoeffs();
			}

		break;

		case PARAM_3:

			if (0.0 <= value && value <= 1.0){

				m_fQscale	 = value;
				calculateCoeffs();
			}

		default: 
			break;
	}
}
void CWah::getParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		// gain
		case PARAM_1:

				return m_fGainScale;
				break;

		case PARAM_2:

				return m_fTheta;
				break;

		case PARAM_3:

				return m_fQscale;
				break;
		default: 
			break;
	}
}


void CWah::process(float **inputBuffer, int numFrames, bool bypass)
{
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < m_iNumChannels; c++)
		{	
			
			m_fTempVal		  = inputBuffer[c][i] - m_fCoeff2 * buff[c][0] - m_fCoeff3 * buff[c][1];
			inputBuffer[c][i] = m_fGain*m_fTempVal;

			buff[c][1] = buff[c][0];
			buff[c][0] = m_fTempVal;
		}
	}
}

CWah::~CWah()
{
    for (int i=0; i < m_iNumChannels; i++)
    {
        delete [] buff[i];
    }
	
    delete [] buff;
    
    buff = nullptr;
}