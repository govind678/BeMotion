//==============================================================================
//
//  LoadPreset.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/5/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================



#ifndef __BeatMotion__LoadPreset__
#define __BeatMotion__LoadPreset__

#include "AudioMixerPlayer.h"

class LoadPreset
{
    
public:
    
    LoadPreset();
    ~LoadPreset();
    
    int loadFXPreset(String filepath);
    
    void setAudioMixerPlayer(AudioMixerPlayer* player);
    
private:
    
    var parsedData;
    
    ScopedPointer<AudioMixerPlayer> mixerPlayer;
};


#endif /* defined(__BeatMotion__JSONParse__) */
