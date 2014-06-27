//
//  WaveformView.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 5/22/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Macros.h"


@interface WaveformView : UIView
{
    int         m_iPixelsPerSample;
    long        m_iFileLength;
    float       m_pfArray [2 * WAVEFORM_WIDTH];
}

@property (nonatomic, assign) int sampleID;

-(void)drawInContext:(CGContextRef)context;
-(void)setArrayToDrawWaveform : (float*)array;

@end
