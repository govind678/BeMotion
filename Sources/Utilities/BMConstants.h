//
//  BMConstants.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#ifndef BMCONSTANTS_H_INCLUDED
#define BMCONSTANTS_H_INCLUDED

extern int const    kNumButtonTracks;
extern int const    kNumMotionTracks;
extern int const    kNumEffectsPerTrack;
extern int const    kNumParametersPerEffect;

extern float const  kDefaultSampleRate;
extern int const    kDefaultNumInputChannels;
extern int const    kDefaultNumOutputChannels;

extern float const  kDeviceMotionUpdateInterval;

extern long const   kNumWaveformSamples;

extern float const    kQuantizedTimeArray[];
extern int const      kLenQuantizedTimeArray;


typedef enum {
    None,
    Wah,
    Tremolo,
    Vibrato,
    Delay,
    Granularizer,
    Lowpass,
    Pan
} EffectID;


typedef enum {
    BMSampleMode_Playback,
    BMSampleMode_Recording,
    BMSampleMode_LoadFX,
    BMSampleMode_LoadFile,
    BMSampleMode_Mix,
} BMSampleMode;

typedef enum {
    BMMotionMode_None,
    BMMotionMode_Pitch,
    BMMotionMode_Roll,
    BMMotionMode_Yaw,
} BMMotionMode;

typedef enum {
    BMPlaybackMode_Loop,
    BMPlaybackMode_OneShot,
    BMPlaybackMode_BeatRepeat,
} BMPlaybackMode;

typedef enum {
    BMLibrary_BuiltIn,
    BMLibrary_MicRecordings,
    BMLibrary_MasterRecordings,
} BMLibrary;

typedef enum {
    BMMicLibrary_Temporary,
    BMMicLibrary_Saved,
    BMMicLibrary_NotApplicable,
} BMMicLibrary;


#endif  // BMCONSTANTS_H_INCLUDED
