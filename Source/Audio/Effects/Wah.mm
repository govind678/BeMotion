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
	setParam(0, 0.2);
	setParam(1, 1.0);
	setParam(2, 1.0);
	calculateCoeffs();
}

void CWah::calculateCoeffs()
{
	m_fGain			= 0.1 * (powf(0.1, m_fTheta));
	m_fQ			= powf(2.0, 2.5*(1.0 - m_fTheta)+1);
	m_fReso			= 500.0 * (powf(2.0, 2.3 * m_fTheta));
	m_fFrn			= m_fReso / m_fSampleRate;
	m_fPoleAngle	=  2.0 * M_PI * m_fFrn;
	m_fCoeff2		= -2.0 * (1 - M_PI* m_fFrn / m_fQ) * cos(m_fPoleAngle);
	m_fCoeff3		= (1.0 - M_PI * m_fFrn / m_fQ)*(1.0 - M_PI * m_fFrn / m_fQ);

}

void CWah::setParam(int type, float value)
{
	switch(type)
	{
		
		case 0:
            
			if (0.0 <= value && value <= 1.0){

				m_fTheta	= value;	// "pedal" value
				calculateCoeffs();
			}
				
		break;

		case 1:

			if (0.0 <= value && value <= 1.0){

			//	m_fGainScale = value;
				//calculateCoeffs();
			}

		break;

		case 2:

			if (0.0 <= value && value <= 1.0){

				//m_fQscale	 = value;
				//calculateCoeffs();
			}

		default: 
			break;
	}
}


float CWah::getParam(int type)
{
	switch(type)
	{
		case 0:
				return m_fTheta;
				break;

		case 1:

				return m_fGainScale;
				break;

		case 2:

				return m_fQscale;
				break;
		default:
            return 0.0f;
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

			inputBuffer[c][i] = ((1.0 - m_fTheta* m_fTheta)*0.0001 + m_fTheta * m_fTheta) * m_fGain * m_fTempVal;

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