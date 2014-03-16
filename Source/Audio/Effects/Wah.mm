#include "Wah.h"

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
	setParam(0, 1.0);
	setParam(1, 0.3);
}

void CWah::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		case 0:

			if (0 <= value && value <= 1)
				m_fGain = 0.1*(powf(value, m_fTheta));

		break;

		case 1:

			if (0 <= value && value <= 1){
				m_fTheta = value;	// "pedal" value
				m_fQ	 = powf(2.0, 2.0*(1.0 - m_fTheta)+1);
				m_fReso  = 450.0 * (powf(2.0, 2.3 * m_fTheta));
				m_fFrn   = m_fReso / m_fSampleRate;
				m_fPoleAngle =  2.0 * M_PI * m_fFrn;
				m_fCoeff2	 = -2.0 * (1 - M_PI * m_fFrn / m_fQ) * cos(m_fPoleAngle);
				m_fCoeff3	 = (1.0 - M_PI * m_fFrn / m_fQ)*(1.0 - M_PI * m_fFrn / m_fQ);
			}

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
	delete [] buff;
}