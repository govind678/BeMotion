#include "PeakFilter.h"

CPeakFilter::CPeakFilter(int numChannels)
{
	m_iNumChannels = numChannels;

	buff = new float *[numChannels];

	for (int c=0; c < numChannels ; c++)
	{
		buff[c] = new float [2];
		buff[c][0] = 0;
		buff[c][1] = 0;
	}

	initDefaults();
}

void CPeakFilter::prepareToPlay(float sampleRate)
{
	m_fSampleRate = sampleRate;

	if (m_fGainInDB >= 0){
				m_fC = (tan(M_PI*m_fCentreFreq/2)-1.0)
						/ (tan(M_PI*m_fBandwidth/2)+1.0);								// boost
	}else{
				m_fC = (tan(M_PI*m_fBandwidth/2)-powf(10.0, m_fGainInDB/20.0)) 
						/ (tan(M_PI*m_fBandwidth/2)+powf(10.0, m_fGainInDB/20.0));	// cut
	}

	m_fD = -cos(M_PI*m_fCentreFreq);
	m_fH = powf(10.0, m_fGainInDB/20.0) - 1.0;
}

void CPeakFilter::initDefaults()
{
	m_fCentreFreq	= 0.1;
	m_fBandwidth	= 0.1;
	m_fGainInDB		= -12.0;
}

void CPeakFilter::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		case 0:
			m_fCentreFreq	= value;
			m_fD = -cos(M_PI*(m_fCentreFreq));
		break;
		case 1:

			if (m_fGainInDB >= 0){
				m_fC = (tan(M_PI*m_fCentreFreq/2)-1.0)
				/ (tan(M_PI*(m_fBandwidth/2))+1.0);								// boost
			}else{
				m_fC = (tan(M_PI*m_fBandwidth)-powf(10.0, m_fGainInDB/20.0)) 
				/ (tan(M_PI*m_fBandwidth)+powf(10.0, m_fGainInDB/20.0));		// cut
			}

		break;
		case 2:
			m_fGainInDB	= value;
			m_fH = powf(10.0, m_fGainInDB/20.0) - 1;
		break;
		default: 
			break;
	}
}

void CPeakFilter::process(float **inputBuffer, int numFrames, bool bypass)
{
	/*	-------------- MATLAB code ---------------
		xh = [0, 0];
		for n = 1:length(x)
			xh_new = x(n) - d*(1-c)*xh(1) + c*xh(2);
			ap_y = -c * xh_new + d*(1-c)*xh(1) + xh(2);
			xh = [xh_new, xh(1)];
			y(n) = 0.5 * H0 * (x(n) - ap_y) + x(n);
		end;	
		------------------------------------------ */

	// for each channel, for each sample:
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < m_iNumChannels; c++)
		{	
			m_fNewVal = inputBuffer[c][i] - m_fD*(1-m_fC)*buff[c][0] + m_fC*buff[c][1];
			m_fTemp   = -m_fC * m_fNewVal + m_fD*(1-m_fC)*buff[c][0] + buff[c][1];
			
			buff[c][1] = buff[c][0];
			buff[c][0] = m_fNewVal;

			inputBuffer[c][i] = 0.5 * m_fH * (inputBuffer[c][i] - m_fTemp) + inputBuffer[c][i];
		}
	}
}

CPeakFilter::~CPeakFilter()
{
	delete [] buff;
}















