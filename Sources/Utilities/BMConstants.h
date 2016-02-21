//
//  BMConstants.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//


extern int const    kNumTracks;
extern int const    kNumEffectsPerTrack;
extern int const    kNumParametersPerEffect;

extern float const  kDefaultSampleRate;
extern int const    kDefaultNumInputChannels;
extern int const    kDefaultNumOutputChannels;


typedef enum {
    None,
    Filter,
    Tremolo,
    Vibrato,
    Delay,
    Granularizer,
    Pan
} EffectID;

