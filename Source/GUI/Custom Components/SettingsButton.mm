//
//  SettingsButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "SettingsButton.h"

@implementation SettingsButton

@synthesize buttonID, delegate;

- (id)initWithFrame:(CGRect)frame : (int)identifier
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        buttonID = identifier;
        
        
        sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, frame.size.height)];
        
        switch (buttonID) {
            case 0:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar0.png":sideBar]]];
                break;
                
            case 1:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar1.png":sideBar]]];
                break;
                
            case 2:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar2.png":sideBar]]];
                break;
                
            case 3:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar3.png":sideBar]]];
                break;
                
            default:
                break;
        }
        [self addSubview:sideBar];
        
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBackground.png":self]]];
        
        
        
        UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordButton setImage:[UIImage imageNamed:@"Record.png"] forState:UIControlStateNormal];
        [recordButton addTarget:self action:@selector(recordButtonClicked) forControlEvents:UIControlEventTouchDown];
        [recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpInside];
        recordButton.frame = CGRectMake(12.0f + 5.0f, 22.0f, 50.0f, 50.0f);
        [self addSubview:recordButton];
        
        UIButton *fxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fxButton setImage:[UIImage imageNamed:@"FX.png"] forState:UIControlStateNormal];
        [fxButton addTarget:self action:@selector(fxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        fxButton.frame = CGRectMake(79.0f + 5.0f, 22.0f, 50.0f, 50.0f);
        [self addSubview:fxButton];
        
        UIButton *importButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [importButton setImage:[UIImage imageNamed:@"Import.png"] forState:UIControlStateNormal];
        [importButton addTarget:self action:@selector(importButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        importButton.frame = CGRectMake(146.0f + 5.0f, 22.0f, 50.0f, 50.0f);
        [self addSubview:importButton];

        UIButton *gestureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [gestureButton setImage:[UIImage imageNamed:@"Motion.png"] forState:UIControlStateNormal];
        [gestureButton addTarget:self action:@selector(importButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        gestureButton.frame = CGRectMake(213.0f + 5.0f, 22.0f, 50.0f, 50.0f);
        [self addSubview:gestureButton];

        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)fxButtonClicked {
    [delegate launchFXView];
}

- (void)importButtonClicked {
    [delegate launchImportView];
}


- (void)gestureButtonClicked {
    
}


- (void)recordButtonClicked {
    [delegate startRecording];
}

- (void)recordButtonReleased {
    [delegate stopRecording];
}



- (void)startRecording {
    // Start Recording
}

- (void)stopRecording {
    // Stop Recording
}


- (void)launchFXView {
    // Launch FX View
}

- (void)launchImportView {
    // Launch Import View
}


- (UIImage*) getResizedImage : (NSString*)filename : (UIView*)view {
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:filename] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
