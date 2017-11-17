//
//  BMConstants.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMConstants.h"

int const   kNumButtonTracks                = 4;
int const   kNumMotionTracks                = 2;
int const   kNumEffectsPerTrack             = 4;
int const   kNumParametersPerEffect         = 3;

float const kDefaultSampleRate              = 48000.0f;
int const   kDefaultNumInputChannels        = 2;
int const   kDefaultNumOutputChannels       = 2;

float const kDeviceMotionUpdateInterval     = 0.01;   // seconds

long const  kNumWaveformSamples             = 1000;

float const kQuantizedTimeArray[]           = {
//                                                0.083333,    // 0 -> 32nd Triplet
                                                0.125000,    // 1 -> 32nd
                                                0.187500,    // 2 -> 32nd Dotted
//                                                0.166667,    // 3 -> 16th Triplet
                                                0.250000,    // 4 -> 16th
                                                0.375000,    // 5 -> 16th Dotted
//                                                0.333333,    // 6 -> 8th Triplet
                                                0.500000,    // 7 -> 8th
                                                0.750000,    // 8 -> 8th Dotted
//                                                0.666667,    // 9 -> 4th Triplet
                                                1.000000,    // 10 -> 4th
                                                1.500000,    // 11 -> 2nd Triplet
                                            };

int const   kLenQuantizedTimeArray          = 8;




//float const kQuantizedTimeArray[]
//= {  0.0416666,  // 0 -> 64th Triplet
//    0.0625,     // 1 -> 64th
//    0.09375,    // 2 -> 64th Dotted
//    0.08333,    // 3 -> 32nd Triplet
//    0.125,      // 4 -> 32nd
//    0.1875,     // 5 -> 32nd Dotted
//    0.1666,     // 6 -> 16th Triplet
//    0.25,       // 7 -> 16th
//    0.375,      // 8 -> 16th Dotted
//    0.333,      // 9 -> 8th Triplet
//    0.5,        // 10 -> 8th
//    0.75,       // 11 -> 8th Dotted
//    0.666,      // 12 -> 4th Triplet
//    1.0,        // 13 -> 4th
//    1.5,        // 14 -> 4th Dotted
//    1.33333};   // 15 -> 2nd Triplet

