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



//========== Button Modes ==========//
# define MODE_TRIGGER            0
# define MODE_LOOP               1
# define MODE_BEATREPEAT         2



//========== Effects Macros ===========//
# define NUM_EFFECTS_PARAMS     3
# define NUM_EFFECTS            6      // Including 1 for None




//========== Metronome Macros ===========//

//-- Defaults --//
# define DEFAULT_TEMPO          120.0f
# define DEFAULT_NUMERATOR      64
# define MAX_QUANTIZATION       6           //  2^n

//=========================================================================================



#endif
