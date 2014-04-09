//==============================================================================
//
//  Macros.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#ifndef GestureController_Macros_h
#define GestureController_Macros_h


//=================================== ID Macros ===========================================

//=========== Effect IDs ============//
#define EFFECT_NONE             0
#define EFFECT_TREMOLO          1
#define EFFECT_DELAY            2
#define EFFECT_VIBRATO          3
#define EFFECT_WAH              4


//========== Parameter IDs ==========//
#define PARAM_BYPASS            0
#define PARAM_GAIN              1
#define PARAM_LOOP              3
#define PARAM_1                 4
#define PARAM_2                 5
#define PARAM_3                 6



//========== Effects Macros ===========//
# define NUM_EFFECTS_PARAMS     3
# define NUM_EFFECTS            5      // Including 1 for None



//========== Metronome Macros ===========//

//-- Quantization --//
# define QUANTIZATION_NONE      0
# define QUANTIZATION_1_1       1
# define QUANTIZATION_1_2       2
# define QUANTIZATION_1_4       3
# define QUANTIZATION_1_8       4
# define QUANTIZATION_1_16      5
# define QUANTIZATION_1_32      6

//-- Defaults --//
# define DEFAULT_TEMPO          120.0f
# define DEFAULT_NUMERATOR      4
# define DEFAULT_DENOMINATOR    8
# define DEFAULT_QUANTIZATION   QUANTIZATION_NONE

//=========================================================================================



#endif
