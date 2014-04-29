//
//  Parameter.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __GestureController__Parameter__
#define __GestureController__Parameter__

#include "Macros.h"

class Parameter
{
    
public:
    
    Parameter();
    ~Parameter();
    
    
    void setSmoothingParameter(float newAlpha);
    
    float process(float value);
    
    void setTempo(int newTempo);
    
    
    
private:
    
    float m_fAlpha;
    float m_fParameter;
    
    float m_iTempo;
};


#endif /* defined(__GestureController__Parameter__) */
