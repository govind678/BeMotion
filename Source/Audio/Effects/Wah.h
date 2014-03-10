//
//  Wah.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __GestureController__Wah__
#define __GestureController__Wah__



class CWah
{
    
public:
    
    CWah();
    ~CWah();
    
    
    void prepareToPlay(float sampleRate);
    void process(float** audioBuffer, int numSample, bool bypassState);
    void finishedPlaying();
    
    
private:
    
    
};

#endif /* defined(__GestureController__Wah__) */
