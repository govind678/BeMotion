//
//  SettingsButton.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/2/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "SettingsButton.h"

@implementation SettingsButton

@synthesize buttonID, delegate, recordLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        
        switch (buttonID)
        {
            case 0:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton0.png"]]];
                break;
                
            case 1:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton1.png"]]];
                break;
                
            case 2:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton2.png"]]];
                break;
                
            case 3:
                [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsButton3.png"]]];
                break;
                
            default:
                break;
        }
        
        UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordButton setImage:[UIImage imageNamed:@"Record.png"] forState:UIControlStateNormal];
        [recordButton addTarget:self action:@selector(recordButtonClicked) forControlEvents:UIControlEventTouchDown];
        [recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpInside];
        recordButton.frame = CGRectMake(12.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
//        [recordButton setClipsToBounds:YES];
//        [[recordButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
        
        UIButton *fxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fxButton setImage:[UIImage imageNamed:@"FX.png"] forState:UIControlStateNormal];
        [fxButton addTarget:self action:@selector(fxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        fxButton.frame = CGRectMake(79.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
//        [fxButton setClipsToBounds:YES];
//        [[fxButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
        
        UIButton *resampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [resampleButton setImage:[UIImage imageNamed:@"Resample.png"] forState:UIControlStateNormal];
        [resampleButton addTarget:self action:@selector(resampleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        resampleButton.frame = CGRectMake(146.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
//        [resampleButton setClipsToBounds:YES];
//        [[resampleButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
        
        UIButton *importButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [importButton setImage:[UIImage imageNamed:@"Import.png"] forState:UIControlStateNormal];
        [importButton addTarget:self action:@selector(importButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        importButton.frame = CGRectMake(213.0f, 22.0f, SETTINGS_ICON_RADIUS, SETTINGS_ICON_RADIUS);
//        [importButton setClipsToBounds:YES];
//        [[importButton layer] setCornerRadius:SETTINGS_ICON_RADIUS * 0.5f];
        
        recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 2.0f, 100.0f, 16.0f)];
        [recordLabel setBackgroundColor:[UIColor clearColor]];
        [recordLabel setTextAlignment:NSTextAlignmentLeft];
        [recordLabel setTextColor:[UIColor whiteColor]];
        [recordLabel setNumberOfLines:1];
        [recordLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [recordLabel setFont:[UIFont systemFontOfSize:8.0f]];
        [recordLabel setText:@"Recording..."];
        [recordLabel setUserInteractionEnabled:NO];
        [recordLabel setHidden:YES];
        
        [self addSubview:recordButton];
        [self addSubview:fxButton];
        [self addSubview:resampleButton];
        [self addSubview:importButton];
        [self addSubview:recordLabel];
        
    }
    
    return self;
}


- (void)recordButtonClicked
{
    [delegate startRecording:buttonID];
    [recordLabel setHidden:NO];
    
}

- (void)recordButtonReleased
{
    [delegate stopRecording:buttonID];
    [recordLabel setHidden:YES];
}

- (void)fxButtonClicked
{
    [delegate launchFXView:buttonID];
}

- (void)resampleButtonClicked
{
    NSLog(@"Start Resampling %d", buttonID);
}

- (void)importButtonClicked
{
    NSLog(@"Launch Import View %d", buttonID);
    [delegate launchImportView:buttonID];
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

- (void)launchImportView:(int)sampleID
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
