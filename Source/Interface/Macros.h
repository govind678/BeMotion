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
# define EFFECT_NONE             0
# define EFFECT_TREMOLO          1
# define EFFECT_DELAY            2
# define EFFECT_VIBRATO          3
# define EFFECT_WAH              4
# define EFFECT_GRANULAR         5


//========== Effect Parameter IDs ==========//
# define PARAM_BYPASS            0
# define PARAM_1                 1
# define PARAM_2                 2
# define PARAM_3                 3


//========== Sample Parameter IDs ==========//
# define PARAM_GAIN              0
# define PARAM_QUANTIZATION      1
# define PARAM_PLAYBACK_MODE     2



//========== Playback Modes ==========//
# define MODE_LOOP               0
# define MODE_TRIGGER            1
# define MODE_BEATREPEAT         2


//========== Button Modes ==========//
# define MODE_PLAYBACK           0
# define MODE_SETTINGS           1
# define MODE_RECORD             2


//========== Effects Macros ===========//
# define NUM_EFFECTS_PARAMS     3
# define NUM_EFFECTS            6      // Including 1 for None




//========== Metronome Macros ===========//

//-- Defaults --//
# define DEFAULT_TEMPO          120.0f
# define DEFAULT_NUMERATOR      64
# define MAX_QUANTIZATION       6           //  2^n
# define GUI_METRO_COUNT        8




//========== Motion Control Macros ===========//

# define NUM_MOTION_PARAMS      6

# define NUM_SAMPLE_PARAMS      2

# define PARAM_MOTION_GAIN      0
# define PARAM_MOTION_QUANT     1

# define PARAM_MOTION_PARAM1    0
# define PARAM_MOTION_PARAM2    1
# define PARAM_MOTION_PARAM3    2

# define ATTITUDE_PITCH         0
# define ATTITUDE_ROLL          1
# define ATTITUDE_YAW           2
# define ACCEL_X                3
# define ACCEL_Y                4
# define ACCEL_Z                5


//===== Buffer Size =====//

#define DELAY_MAX_SAMPLES       100000
#define GRANULAR_MAX_SAMPLES    250000.0
#define LIMITER_MAX_SAMPLES     5

//=========================================================================================



#endif
