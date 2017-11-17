/*
  ==============================================================================

    AudioFileRecord.cpp
    Created: 2 Feb 2016 12:25:50am
    Author:  Govinda Pingali

  ==============================================================================
*/

#include "AudioFileRecord.h"

AudioFileRecord::AudioFileRecord(int numChannels, String threadName) :
    _backgroundThread (threadName),
    _sampleRate (0),
    nextSampleNum (0),
    activeWriter (nullptr),
    _numChannels(numChannels)
{
    _backgroundThread.startThread(10);
    _sampleRate = 48000.0f;
}


AudioFileRecord::~AudioFileRecord()
{
    _backgroundThread.stopThread(1000);
    stopRecording();
}


bool AudioFileRecord::startRecording(const File& file)
{
    bool success = false;
    
    stopRecording();
    
    if (_sampleRate > 0)
    {
        // Create an OutputStream to write to destination file...
        file.deleteFile();
        ScopedPointer<FileOutputStream> fileStream (file.createOutputStream());
        
        if (fileStream != nullptr)
        {
            // WAV writer object that writes to the output stream...
            WavAudioFormat wavFormat;
            AudioFormatWriter* writer = wavFormat.createWriterFor (fileStream, _sampleRate, _numChannels, 16, StringPairArray(), 0);
            
            if (writer != nullptr)
            {
                fileStream.release(); // (passes responsibility for deleting the stream to the writer object that is now using it)
                
                
                // Now we'll create one of these helper objects which will act as a FIFO buffer, and will
                // write the data to disk on our background thread.
                threadedWriter = new AudioFormatWriter::ThreadedWriter (writer, _backgroundThread, 32768);
                
                
                // And now, swap over our active writer pointer so that the audio callback will start using it..
                const ScopedLock sl (writerLock);
                activeWriter = threadedWriter;
                
                success = true;
            }
        }
    }
    
    return success;
}




void AudioFileRecord::stopRecording()
{
    // First, clear this pointer to stop the audio callback from using our writer object..
    {
        const ScopedLock sl (writerLock);
        activeWriter = nullptr;
    }
    
    // Now we can delete the writer object. It's done in this order because the deletion could
    // take a little time while remaining data gets flushed to disk, so it's best to avoid blocking
    // the audio callback while this happens.
    threadedWriter = nullptr;
    
}


void AudioFileRecord::prepareToRecord(double sampleRate)
{
    _sampleRate = sampleRate;
}


void AudioFileRecord::writeBuffer(float **buffer, int numSamples)
{
    const ScopedLock sl (writerLock);
    
    if (activeWriter != nullptr)
    {
        activeWriter->write (buffer, numSamples);
    }
}

void AudioFileRecord::writeBuffer(const float **buffer, int numSamples)
{
    const ScopedLock sl (writerLock);
    
    if (activeWriter != nullptr)
    {
        activeWriter->write (buffer, numSamples);
    }
}


bool AudioFileRecord::isRecording()
{
    return activeWriter != nullptr;
}
