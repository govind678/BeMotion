//==============================================================================
//
//  AudioFileRecord.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================


#ifndef AUDIOFILERECORD_H_INCLUDED
#define AUDIOFILERECORD_H_INCLUDED

#include "BeatMotionHeader.h"

class AudioFileRecord   :   public AudioIODeviceCallback
{
    
public:
    
    AudioFileRecord(AudioDeviceManager& sharedDeviceManager);
    ~AudioFileRecord();
    
    void startRecording(String filePath, bool internalCallback);
    void stopRecording();
    
    
    void audioDeviceAboutToStart (AudioIODevice* device) override;
    void audioDeviceStopped() override;
    void audioDeviceIOCallback (const float** inputChannelData, int numInputChannels,
                                float** outputChannelData, int numOutputChannels,
                                int numSamples) override;
    
    void writeBuffer(float** buffer, int blockSize);
    
    bool isRecording();
    
    
private:

    AudioDeviceManager& deviceManager;
    TimeSliceThread backgroundThread;
    
    String m_sCurrentFilePath;
    double  sampleRate;
    
    ScopedPointer<AudioFormatWriter::ThreadedWriter> threadedWriter;
    int64 nextSampleNum;
    
    CriticalSection writerLock;
    AudioFormatWriter::ThreadedWriter* volatile activeWriter;
};




#endif  // AUDIOFILERECORD_H_INCLUDED
