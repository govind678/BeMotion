/*
  ==============================================================================

    AudioFileRecord.h
    Created: 2 Feb 2016 12:25:50am
    Author:  Govinda Pingali

  ==============================================================================
*/

#ifndef AUDIOFILERECORD_H_INCLUDED
#define AUDIOFILERECORD_H_INCLUDED


#include "JuceHeader.h"

class AudioFileRecord
{
    
public:
    
    AudioFileRecord();
    ~AudioFileRecord();
    
    void startRecording(const File& file);
    void stopRecording();
    
    void prepareToRecord(double sampleRate);
    void writeBuffer(float** buffer, int numSamples);
    void writeBuffer(const float** buffer, int numSamples);
    
    bool isRecording();
    
private:
    
    TimeSliceThread backgroundThread;
    
    double  _sampleRate;
    
    ScopedPointer<AudioFormatWriter::ThreadedWriter> threadedWriter;
    int64 nextSampleNum;
    
    CriticalSection writerLock;
    AudioFormatWriter::ThreadedWriter* volatile activeWriter;
    
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (AudioFileRecord)
};


#endif  // AUDIOFILERECORD_H_INCLUDED
