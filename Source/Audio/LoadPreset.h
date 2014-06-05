//==============================================================================
//
//  LoadPreset.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/5/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================



#ifndef __BeMotion__LoadPreset__
#define __BeMotion__LoadPreset__

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


#endif /* defined(__BeMotion__JSONParse__) */
