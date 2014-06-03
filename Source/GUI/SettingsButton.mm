//
//  SettingsButton.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/2/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "SettingsButton.h"

@implementation SettingsButton

@synthesize buttonID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        
        switch (buttonID)
        {
            case 0:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingsBackground0.png"]]];
                break;
                
            case 1:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingsBackground1.png"]]];
                break;
                
            case 2:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingsBackground2.png"]]];
                break;
                
            case 3:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingsBackground3.png"]]];
                break;
                
            default:
                break;
        }
        
        UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordButton setImage:[UIImage imageNamed:@"Record.png"] forState:UIControlStateNormal];
        [recordButton addTarget:self action:@selector(recordButtonClicked) forControlEvents:UIControlEventTouchDown];
        [recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpInside];
        recordButton.frame = CGRectMake(12.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
        [recordButton setClipsToBounds:YES];
        [[recordButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
        
        UIButton *fxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fxButton setImage:[UIImage imageNamed:@"FX.png"] forState:UIControlStateNormal];
        [fxButton addTarget:self action:@selector(fxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        fxButton.frame = CGRectMake(79.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
        [fxButton setClipsToBounds:YES];
        [[fxButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
        
        UIButton *resampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [resampleButton setImage:[UIImage imageNamed:@"Resample.png"] forState:UIControlStateNormal];
        [resampleButton addTarget:self action:@selector(resampleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        resampleButton.frame = CGRectMake(146.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
        [resampleButton setClipsToBounds:YES];
        [[resampleButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
        
        UIButton *importButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [importButton setImage:[UIImage imageNamed:@"Import.png"] forState:UIControlStateNormal];
        [importButton addTarget:self action:@selector(resampleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        importButton.frame = CGRectMake(213.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
        [importButton setClipsToBounds:YES];
        [[importButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];

        
        [self addSubview:recordButton];
        [self addSubview:fxButton];
        [self addSubview:resampleButton];
        [self addSubview:importButton];
        
    }
    
    return self;
}

- (void) setDelegate:(id)newDelegate
{
    delegate = newDelegate;
}


- (void)recordButtonClicked
{
    [delegate startRecording:buttonID];
}

- (void)recordButtonReleased
{
    [delegate stopRecording:buttonID];
}



- (void)fxButtonClicked
{
    [delegate launchFXView:buttonID];
}

- (void)resampleButtonClicked
{
    NSLog(@"Start Resampling %d", buttonID);
}



- (void)startRecording : (int)sampleID
{
    
}

- (void)stopRecording:(int)sampleID
{
    
}

- (void)startResampling:(int)sampleID
{
    
}

- (void)launchFXView:(int)sampleID
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
