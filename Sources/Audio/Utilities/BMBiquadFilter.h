/*
 ==============================================================================
 
    BMBiquadFilter.h
    Created: 3 Mar 2016 5:15:17pm
    Author:  Govinda Pingali
 
 ==============================================================================
*/

#ifndef BMBIQUADFILTER_H
#define BMBIQUADFILTER_H

class BMBiquadFilter
{
public:
    
    BMBiquadFilter(int numChannels);
    ~BMBiquadFilter();
    
    /*! Biquad direct form I implementation:
        y[n] = (b0/a0)*x[n] + (b1/a0)*x[n-1] + (b2/a0)*x[n-2]
        - (a1/a0)*y[n-1] - (a2/a0)*y[n-2]
    */
    void process(float** buffer, int numChannels, int numSamples);
    void setCoefficients(float a0, float a1, float a2, float b0, float b1, float b2);
    
private:
    
    int         _numChannels;
    
    float       _a0;
    float       _a1;
    float       _a2;
    float       _b0;
    float       _b1;
    float       _b2;
    
    float*      _x1;
    float*      _x2;
    float*      _y1;
    float*      _y2;
};

#endif /* BMBIQUADFILTER_H */
