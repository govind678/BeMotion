//
//  WaveformView.m
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 5/22/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import "WaveformView.h"


@implementation WaveformView

@synthesize sampleID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        
    }
    return self;
}


-(void)drawInContext:(CGContextRef)context
{
    switch (sampleID)
    {
        case 0:
            CGContextSetRGBStrokeColor(context, 0.98f, 0.34f, 0.14f, 1.0);
            break;
            
        case 1:
            CGContextSetRGBStrokeColor(context, 0.15, 0.39f, 0.78f, 1.0);
            break;
            
        case 2:
            CGContextSetRGBStrokeColor(context, 0.0f, 0.74f, 0.42f, 1.0);
            break;
            
        case 3:
            CGContextSetRGBStrokeColor(context, 0.96f, 0.93f, 0.17f, 1.0);
            break;
            
        default:
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
            break;
    }
	
    
    CGContextSetLineWidth(context, 0.5f);
    
    for (int pixel = 0; pixel < (2 * WAVEFORM_WIDTH) - 1; pixel++)
    {
        if (m_pfArray[pixel] >= 0) {
            CGContextMoveToPoint(context, pixel * 0.5f, WAVEFORM_HEIGHT - m_pfArray[pixel]);
            CGContextAddLineToPoint(context, (pixel + 1) * 0.5f, (WAVEFORM_HEIGHT - m_pfArray[pixel+1]));
        }
        
        CGContextStrokePath(context);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)setArrayToDrawWaveform:(float *)array
{
    for (int sample = 0; sample < (2 * WAVEFORM_WIDTH); sample++)
    {
        m_pfArray[sample] = array[sample];
    }
    [self setNeedsDisplay];
}



@end
