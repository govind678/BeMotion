//==============================================================================
//
//  AudioFileStream.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================

#include "AudioFileStream.h"


AudioFileStream::AudioFileStream(int sampleID)    : thread("Sample Playback No. " + String(sampleID))
{
    
    m_iSampleID =   sampleID;
    
    m_bAudioCurrentlyPlaying    =   false;
    m_bPlayingFromMemory        =   false;
    m_iSamplesRead              =   0;
    
    m_iButtonMode               =   MODE_LOOP;
    m_iQuantization             =   QUANTIZATION_LEVELS - 1;
    m_iBeat                     =   0;
    m_fGain                     =   1.0f;
    m_fSampleRate               =   DEFAULT_SAMPLE_RATE;
    m_fStartPoint_s             =   0.0f;
    
    transportSource.setSource(nullptr);
    formatManager.registerBasicFormats();
    audioEffectSource.clear(true);
    m_pbBypassStateArray.clear();
    audioEffectInitialized.clear();
    m_pbGestureControl.clear();
    m_pcParameter.clear();
    
    m_pfWaveformArray.clear();
    for (int sample = 0; sample < (WAVEFORM_WIDTH); sample++)
    {
        m_pfWaveformArray.add(0.0f);
    }
    
    
    for (int effectNo = 0; effectNo < NUM_EFFECTS_SLOTS; effectNo++)
    {
        audioEffectSource.add(nullptr);
        audioEffectInitialized.add(false);
        m_pbBypassStateArray.add(false);
    }
    
    
    for (int param = 0; param < NUM_SAMPLE_PARAMS; param++)
    {
        m_pbGestureControl.add(false);
        
        m_pcParameter.add(new Parameter());
        m_pcParameter.getUnchecked(param)->setSmoothingParameter(0.4f);
    }
        

    m_pcLimiter = new CLimiter(NUM_INPUT_CHANNELS);
    m_pcAudioFeature = new AudioFeatureExtraction();

    
    thread.startThread(3);
}


AudioFileStream::~AudioFileStream()
{
    transportSource.setSource(nullptr);
    
    currentAudioFileSource  =   nullptr;
    
    audioEffectInitialized.clear();
    m_pbGestureControl.clear();
    
    audioEffectSource.clear(true);
    m_pbBypassStateArray.clear();
    m_pcParameter.clear();
    m_pfWaveformArray.clear();
    
    m_pcLimiter     =   nullptr;
    m_pcAudioFeature = nullptr;

    thread.stopThread(20);
}



int AudioFileStream::loadAudioFile(String audioFilePath)
{
    m_sCurrentFilePath  =   audioFilePath;
    
    transportSource.stop();
    transportSource.setSource(nullptr);
    
    currentAudioFileSource  =   nullptr;
    
    AudioFormatReader* reader = formatManager.createReaderFor(File(m_sCurrentFilePath));
    
    
    if (reader != nullptr)
    {
        currentAudioFileSource = new AudioFormatReaderSource (reader, true);
        m_fSampleRate = reader->sampleRate;
        
        if (m_iSampleID < 4)
        {
            if ((m_iButtonMode == MODE_LOOP) || (m_iButtonMode == MODE_BEATREPEAT))
            {
                currentAudioFileSource->setLooping(true);
            }
            
//            firstAudioBlock = AudioSampleBuffer(2, STREAMING_BUFFER_SIZE);
//            reader->read(&firstAudioBlock, 0, STREAMING_BUFFER_SIZE, 0, true, true);
            m_fStartPoint_s = m_pcAudioFeature->detectFirstOnset(audioFilePath);
            
            
            //--- Generate Array To Draw Waveform ---//
            FloatVectorOperations::fill(m_pfWaveformArray.getRawDataPointer(), 0.0f, WAVEFORM_WIDTH);
            
            int samplesPerPixel  = int((float(reader->lengthInSamples) / WAVEFORM_WIDTH) + 0.5f);
            
            std::cout << "Sample " << m_iSampleID << " : " << samplesPerPixel << std::endl;
            
            AudioSampleBuffer buffer = AudioSampleBuffer(1, samplesPerPixel);
            
            for (int block = 0; block < WAVEFORM_WIDTH; block++)
            {
                reader->read(&buffer, 0, samplesPerPixel, block * samplesPerPixel, true, false);
                m_pfWaveformArray.set(block, (buffer.getArrayOfReadPointers()[0][0] + 1.0f) * (WAVEFORM_HEIGHT * 0.5f));
            }
            
            
        }
        
//        transportSource.setSource(currentAudioFileSource, 32768, &thread, deviceManager.getCurrentAudioDevice()->getCurrentSampleRate());
        transportSource.setSource(currentAudioFileSource, STREAMING_BUFFER_SIZE, &thread, m_fSampleRate);
        transportSource.setGain(GAIN_SCALE);
        
        return 0;
    }
    
    else
    {
        return 1;
    }
}



//==============================================================================
// Add and Remove Audio Effect
// Will pause playback for an instant and restart
//==============================================================================

void AudioFileStream::addAudioEffect(int effectPosition, int effectID)
{
    if (effectID == 0)
    {
        audioEffectSource.set(effectPosition, nullptr);
        audioEffectInitialized.set(effectPosition, false);
    }
    
    
    else
    {
        if (effectPosition < (NUM_EFFECTS_SLOTS))
        {
            audioEffectSource.set(effectPosition, new AudioEffectSource(effectID, NUM_OUTPUT_CHANNELS));
            audioEffectInitialized.set(effectPosition, true);
        }
    }
}


void AudioFileStream::removeAudioEffect(int effectPosition)
{
    audioEffectSource.set(effectPosition, nullptr);
    audioEffectInitialized.set(effectPosition, false);
}



void AudioFileStream::setAudioEffectBypassState(int effectPosition, bool bypassState)
{
    m_pbBypassStateArray.set(effectPosition, bypassState);
}



bool AudioFileStream::isPlaying()
{
    return m_bAudioCurrentlyPlaying;
}



//==============================================================================
// Process Functions - Audio Source Callbacks
// !!! Audio Thread
//==============================================================================

void AudioFileStream::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    transportSource.prepareToPlay(samplesPerBlockExpected, sampleRate);
    
    for (int effectNo = 0; effectNo < audioEffectSource.size(); effectNo++)
    {
        if (audioEffectSource.getUnchecked(effectNo) != nullptr)
        {
            audioEffectSource.getUnchecked(effectNo)->audioDeviceAboutToStart(sampleRate);
        }
    }
    
    m_pcLimiter->prepareToPlay(sampleRate);
//    m_pcAutoLimiter->Setup(sampleRate);
}


void AudioFileStream::releaseResources()
{
    transportSource.releaseResources();
    
    for (int effectNo = 0; effectNo < audioEffectSource.size(); effectNo++)
    {
        if (audioEffectInitialized.getUnchecked(effectNo) == true)
        {
            if (m_pbBypassStateArray[effectNo] == false)
            {
                audioEffectSource.getUnchecked(effectNo)->audioDeviceStopped();
            }
        }
    }

}


void AudioFileStream::getNextAudioBlock(const AudioSourceChannelInfo &audioSourceChannelInfo)
{
//    if (m_iButtonMode != MODE_BEATREPEAT)
//    {
//        transportSource.getNextAudioBlock(audioSourceChannelInfo);
//        processAudioBlock(audioSourceChannelInfo.buffer->getArrayOfWritePointers(), audioSourceChannelInfo.numSamples);
//    }
//    
//    else
//    {
//        for (int channel = 0; channel < 2; channel++)
//        {
//            audioSourceChannelInfo.buffer->addFrom(channel, 0, firstAudioBlock, channel, 0, audioSourceChannelInfo.numSamples);
//        }
//    }
    
//    if (m_bAudioCurrentlyPlaying)
//    {
//        if (m_bPlayingFromMemory)
//        {
//            for (int channel = 0; channel < NUM_CHANNELS; channel++)
//            {
//                audioSourceChannelInfo.buffer->addFrom(channel, 0, firstAudioBlock, channel, m_iSamplesRead, audioSourceChannelInfo.numSamples);
//            }
//            
//            m_iSamplesRead += audioSourceChannelInfo.numSamples;
//            
//            if (m_iSamplesRead >= STREAMING_BUFFER_SIZE)
//            {
//                m_bPlayingFromMemory = false;
//                m_iSamplesRead = 0;
//                internal_startPlayback();
//            }
//        }
//        
//        else
//        {
//            transportSource.getNextAudioBlock(audioSourceChannelInfo);
//        }
//
//        processAudioBlock(audioSourceChannelInfo.buffer->getArrayOfWritePointers(), audioSourceChannelInfo.numSamples);
//    }
    
    
//    else
//    {
//        audioSourceChannelInfo.buffer->clear();
//    }
    
    transportSource.getNextAudioBlock(audioSourceChannelInfo);
    processAudioBlock(audioSourceChannelInfo.buffer->getArrayOfWritePointers(), audioSourceChannelInfo.numSamples);

}



void AudioFileStream::processAudioBlock(float **audioBuffer, int numSamples)
{
    for (int effectNo = 0; effectNo < audioEffectSource.size(); effectNo++)
    {
        if (audioEffectInitialized.getUnchecked(effectNo) == true)
        {
            if (m_pbBypassStateArray[effectNo] == false)
            {
                audioEffectSource.getUnchecked(effectNo)->process(audioBuffer,
                                                                  numSamples);
            }
        }
    }
    
    m_pcLimiter->process(audioBuffer, numSamples);
//    m_pcAutoLimiter->Process(numSamples, audioBuffer);
}





//==============================================================================
// Transport Control Methods
//==============================================================================

void AudioFileStream::startPlayback()
{
    m_bAudioCurrentlyPlaying    =   true;
//    m_bPlayingFromMemory        =   true;
    
    if ((m_iButtonMode != MODE_BEATREPEAT))
    {
        transportSource.setPosition(m_fStartPoint_s);
        transportSource.start();
    }
}

void AudioFileStream::stopPlayback()
{
    m_bAudioCurrentlyPlaying    =   false;
//    m_bPlayingFromMemory        =   false;
//    m_iSamplesRead = 0;
    if (m_iButtonMode != MODE_TRIGGER) {
        transportSource.stop();
        
        for (int effectNo = 0; effectNo < audioEffectSource.size(); effectNo++)
        {
            if (audioEffectInitialized.getUnchecked(effectNo) == true)
            {
                if (m_pbBypassStateArray.getUnchecked(effectNo) == false)
                {
                    audioEffectSource.getUnchecked(effectNo)->audioDeviceStopped();
                }
            }
        }
        
        
    }
    
}


void AudioFileStream::setLooping(bool looping)
{
    currentAudioFileSource->setLooping(looping);
}


void AudioFileStream::internal_startPlayback()
{
//    transportSource.setNextReadPosition(STREAMING_BUFFER_SIZE);
//    transportSource.start();
}





//==============================================================================
// Set and Get Audio Effect Parameters
//==============================================================================

void AudioFileStream::setEffectParameter(int effectPosition, int parameterID, float value)
{
    if (parameterID == PARAM_BYPASS)
    {
        m_pbBypassStateArray.set(effectPosition, bool(value));
    }
    
    else
    {
        if (audioEffectInitialized.getUnchecked(effectPosition))
        {
            audioEffectSource.getUnchecked(effectPosition)->setParameter((parameterID), value);
        }
    }
}


void AudioFileStream::setSampleParameter(int parameterID, float value)
{
    if (parameterID == PARAM_GAIN)
    {
        m_fGain     =   value;
        transportSource.setGain((value * value) * GAIN_SCALE);
    }
    
    else if (parameterID == PARAM_QUANTIZATION)
    {
        m_iQuantization =  int(powf(2, int(QUANTIZATION_LEVELS - value - 1)));
    }
    
    else if (parameterID == PARAM_PLAYBACK_MODE)
    {
        m_iButtonMode   =   int(value + 0.5f);
        
        if (m_iButtonMode != MODE_LOOP)
        {
            setLooping(false);
        }
        
        else
        {
            setLooping(true);
        }
    }
}



float AudioFileStream::getEffectParameter(int effectPosition, int parameterID)
{
    if (parameterID == PARAM_BYPASS)
    {
        return m_pbBypassStateArray.getUnchecked(effectPosition);
    }
    
    else
    {
        if (audioEffectInitialized.getUnchecked(effectPosition))
        {
            return audioEffectSource.getUnchecked(effectPosition)->getParameter(parameterID);
        }
        
        else
        {
            return 0.0f;
        }
        
    }
}


float AudioFileStream::getSampleParameter(int parameterID)
{
    if (parameterID == PARAM_GAIN)
    {
        return m_fGain;
    }
    
    else if (parameterID == PARAM_QUANTIZATION)
    {
        return  (QUANTIZATION_LEVELS - log2f(m_iQuantization) - 1);
    }
    
    else if (parameterID == PARAM_PLAYBACK_MODE)
    {
        return m_iButtonMode;
    }
    
    else
    {
        return 0.0f;
    }
}


void AudioFileStream::setSmoothing(int effectPosition, int parameterID, float smoothing)
{
    audioEffectSource.getUnchecked(effectPosition)->setSmoothing(parameterID, smoothing);
}

int AudioFileStream::getEffectType(int effectPosition)
{
    if (audioEffectInitialized.getUnchecked(effectPosition))
    {
        return audioEffectSource.getUnchecked(effectPosition)->getEffectType();
    }
    
    else
    {
        return EFFECT_NONE;
    }
    
}



void AudioFileStream::setSampleGestureControlToggle(int parameterID, bool toggle)
{
    m_pbGestureControl.set(parameterID, toggle);
}

void AudioFileStream::setEffectGestureControlToggle(int effectPosition, int parameterID, bool toggle)
{
    if (audioEffectInitialized.getUnchecked(effectPosition))
    {
        audioEffectSource.getUnchecked(effectPosition)->setGestureControlToggle(parameterID, toggle);
    }
}


bool AudioFileStream::getSampleGestureControlToggle(int parameterID)
{
    return m_pbGestureControl.getUnchecked(parameterID);
}


bool AudioFileStream::getEffectGestureControlToggle(int effectPosition, int parameterID)
{
    if (audioEffectInitialized.getUnchecked(effectPosition))
    {
        return audioEffectSource.getUnchecked(effectPosition)->getGestureControlToggle(parameterID);
    }
    
    else
    {
       return false;
    }
}


float AudioFileStream::getCurrentPlaybackTime()
{
    if (m_bAudioCurrentlyPlaying)
    {
        return (transportSource.getCurrentPosition() / transportSource.getLengthInSeconds());
    }
    
    else
    {
        return 0.0f;
    }
}






void AudioFileStream::beat(int beatNum)
{
    m_iBeat = beatNum % m_iQuantization;
    
    if (m_iButtonMode == MODE_BEATREPEAT)
    {
        if (m_bAudioCurrentlyPlaying)
        {
            if (m_iBeat == 0)
            {
                transportSource.setPosition(0);
                transportSource.start();
            }
        }
    }
}


void AudioFileStream::motionUpdate(float *motion)
{
    if (m_pbGestureControl.getUnchecked(PARAM_MOTION_GAIN))
    {
        transportSource.setGain(m_pcParameter.getUnchecked(PARAM_MOTION_GAIN)->process(motion[ATTITUDE_PITCH] * motion[ATTITUDE_PITCH]) * GAIN_SCALE);
    }
    
    
    if (m_pbGestureControl.getUnchecked(PARAM_MOTION_QUANT))
    {
        float smooth = m_pcParameter.getUnchecked(PARAM_MOTION_QUANT)->process(motion[ATTITUDE_ROLL]);
        
        if ((smooth >= 0.0f) && (smooth < 0.25f))
        {
            m_iQuantization = 8;
        }
        
        else if ((smooth >= 0.25f) && (smooth < 0.5f))
        {
            m_iQuantization = 4;
        }
        
        else if ((smooth >= 0.5f) && (smooth < 0.75f))
        {
            m_iQuantization = 2;
        }
        
        else if ((smooth >= 0.75f) && (smooth < 1.0f))
        {
            m_iQuantization = 1;
        }

    }
    
    
    for (int effect = 0; effect < NUM_EFFECTS_SLOTS ; effect++)
    {
        if (audioEffectInitialized.getUnchecked(effect))
        {
            audioEffectSource.getUnchecked(effect)->motionUpdate(motion);
        }
    }
}


void AudioFileStream::setTempo(float newTempo)
{
    for (int effect = 0; effect < NUM_EFFECTS_SLOTS ; effect++)
    {
        if (audioEffectInitialized.getUnchecked(effect))
        {
            audioEffectSource.getUnchecked(effect)->setTempo(newTempo);
        }
    }
}


float* AudioFileStream::getSamplesToDrawWaveform()
{
    return m_pfWaveformArray.getRawDataPointer();
}
