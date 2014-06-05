//==============================================================================
//
//  LoadPreset.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/5/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#include "LoadPreset.h"
#include <iostream>
#include <stdio.h>

LoadPreset::LoadPreset()
{
    
}


LoadPreset::~LoadPreset()
{
    
}




int LoadPreset::loadFXPreset(String filepath)
{
    parsedData = JSON::parse(File(filepath));
    
    if (parsedData.isVoid())
    {
        return 1;
    }
    
    if (!parsedData.isObject())
    {
        return 2;
    }
    
    
    //--- Parse JSON File and Load Backend ---//
    
    
    
    for (int i = 0; i < NUM_BUTTONS; i++)
    {
        String sampleString = "sample" + String(i);
        const char* sample = sampleString.toRawUTF8();
    
        
        //-- Set Mode --//
        mixerPlayer->setSampleParameter(i, PARAM_PLAYBACK_MODE,
                                        JSON::toString(parsedData["samples"][sample]["mode"]).getFloatValue());
    
        //-- Set Gain --//
        mixerPlayer->setSampleParameter(i, PARAM_GAIN,
                                        JSON::toString(parsedData["samples"][sample]["gain"]["value"]).getFloatValue());
        
        //-- Set Gain Motion Control --//
        mixerPlayer->setSampleGestureControlToggle(i, PARAM_MOTION_GAIN,
                                                         bool(JSON::toString(parsedData["samples"][sample]["gain"]["gesture"]).getIntValue()));
        
        
        //-- Set Quantization --//
        mixerPlayer->setSampleParameter(i, PARAM_QUANTIZATION,
                                        JSON::toString(parsedData["samples"][sample]["quantization"]["value"]).getFloatValue());
        
        
        //-- Set Quantization Motion Control --//
        mixerPlayer->setSampleGestureControlToggle(i, PARAM_MOTION_QUANT,
                                                   bool(JSON::toString(parsedData["samples"][sample]["quantization"]["gesture"]).getIntValue()));
        
        
        //-- Set Audio Effect --//
        
        for (int p = 0; p < NUM_EFFECTS_SLOTS; p++)
        {
            String slotString = "slot" + String(p);
            const char* slot = slotString.toRawUTF8();
            
            mixerPlayer->addAudioEffect(i, p,
                                        JSON::toString(parsedData["samples"][sample][slot]["effect"]).getIntValue());
            
            
            //-- Set Effect Parameters --//
            
            mixerPlayer->setEffectParameter(i, p, PARAM_BYPASS,
                                            JSON::toString(parsedData["samples"][sample][slot]["bypass"]).getIntValue());
            
            
            mixerPlayer->setEffectParameter(i, p, PARAM_1,
                                            JSON::toString(parsedData["samples"][sample][slot]["slider0"]["value"]).getFloatValue());
            
            mixerPlayer->setEffectParameter(i, p, PARAM_2,
                                            JSON::toString(parsedData["samples"][sample][slot]["slider1"]["value"]).getFloatValue());
            
            mixerPlayer->setEffectParameter(i, p, PARAM_3,
                                            JSON::toString(parsedData["samples"][sample][slot]["slider2"]["value"]).getFloatValue());
            
            
            //-- Set Gesture Toggles --//
            mixerPlayer->setEffectGestureControlToggle(i, p, PARAM_MOTION_PARAM1,
                                                       bool(JSON::toString(parsedData["samples"][sample][slot]["slider0"]["gesture"]).getIntValue()));
            
            mixerPlayer->setEffectGestureControlToggle(i, p, PARAM_MOTION_PARAM2,
                                                       bool(JSON::toString(parsedData["samples"][sample][slot]["slider1"]["gesture"]).getIntValue()));
            
            mixerPlayer->setEffectGestureControlToggle(i, p, PARAM_MOTION_PARAM3,
                                                       bool(JSON::toString(parsedData["samples"][sample][slot]["slider2"]["gesture"]).getIntValue()));
        }
        
    }


//        std::cout << JSON::toString(parsedData["samples"]["1"]["slot0"]) << std::endl;
    
    return 0;
}




void LoadPreset::setAudioMixerPlayer(AudioMixerPlayer *player)
{
    mixerPlayer = player;
}