//==============================================================================
//
//  Macros.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//
//==============================================================================


#ifndef BeMotion_Macros_h
#define BeMotion_Macros_h


//=================================== ID Macros ===========================================

//=========== GUI ====================//

# define NUM_BUTTONS             4
# define BUTTON_OFF_ALPHA        0.25f
# define SETTINGS_ICON_RADIUS    50.0f


//=========== Effect IDs ============//
# define EFFECT_NONE             0
# define EFFECT_TREMOLO          1
# define EFFECT_DELAY            2
# define EFFECT_VIBRATO          3
# define EFFECT_WAH              4
# define EFFECT_GRANULAR         5
# define EFFECT_LOWSHELF         6


//========== Effect Parameter IDs ==========//
# define PARAM_BYPASS            0
# define PARAM_1                 1
# define PARAM_2                 2
# define PARAM_3                 3


//========== Sample Parameter IDs ==========//
# define PARAM_GAIN              0
# define PARAM_QUANTIZATION      1
# define PARAM_RESAMPLE_RATIO    2
# define PARAM_PLAYBACK_MODE     3



//========== Playback Modes ==========//
# define MODE_LOOP               0
# define MODE_TRIGGER            1
# define MODE_BEATREPEAT         2
# define MODE_FOURTH             3


//========== Button Modes ==========//
# define MODE_PLAYBACK           0
# define MODE_SETTINGS           1
# define MODE_RECORD             2



//========== Effects Macros ===========//
# define NUM_EFFECTS_PARAMS      3
# define NUM_EFFECTS_TYPES       6      // Including 1 for None
# define NUM_EFFECTS_SLOTS       4






//========== Metronome Macros ===========//

//-- Defaults --//
# define DEFAULT_TEMPO          120.0f
# define DEFAULT_NUMERATOR      64
# define MAX_QUANTIZATION       3           //  2^n
# define QUANTIZATION_LEVELS    6
# define GUI_METRO_COUNT        8

# define PROGRESS_UPDATE_RATE   0.1f
# define MOTION_UPDATE_RATE     0.05f





//========== Sample Preset Banks ==========//
# define PRESET_BANK_EKIT               0
# define PRESET_BANK_DUBBEAT            1
# define PRESET_BANK_BREAKBEAT          2
# define PRESET_BANK_INDIANPERC         3
# define PRESET_BANK_EMBRYO             4
# define PRESET_BANK_SKIES              5
# define PRESET_BANK_MT                 6
# define PRESET_BANK_LATINPERC          7
# define PRESET_BANK_LATINLOOP          8
# define PRESET_BANK_ELECTRONIC         9
# define PRESET_BANK_ELECTRONICA        10


//========== Sample Bank default Tempos ===========//
# define BANK0_TEMPO            120.0f
# define BANK1_TEMPO            140.0f
# define BANK2_TEMPO            140.0f
# define BANK3_TEMPO            100.0f
# define BANK4_TEMPO            200.0f
# define BANK5_TEMPO            180.0f
# define BANK6_TEMPO            120.0f
# define BANK7_TEMPO            126.0f
# define BANK8_TEMPO            126.0f
# define BANK9_TEMPO            85.0f
# define BANK10_TEMPO           85.0f





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

# define LIN_ACC_THRESHOLD      8.0f





//===== Buffer Size and Other Effect Macros =====//

# define DELAY_MAX_SAMPLES       131072
# define GRANULAR_MAX_SAMPLES    88200
# define GRANULAR_MIN_SAMPLES    882
# define LIMITER_MAX_SAMPLES     5
# define WAH_BUFFER_SIZE         1024

# define STREAMING_BUFFER_SIZE   32768

# define VIBRATO_MAX_MOD_WIDTH   250

# define DEFAULT_SAMPLE_RATE     44100.0f
# define NUM_CHANNELS            2

//=========================================================================================



#endif
