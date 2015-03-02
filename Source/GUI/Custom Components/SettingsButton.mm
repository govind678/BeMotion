//
//  SettingsButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import "SettingsButton.h"
#define BUTTON_RADIUS 60.0f

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
        
        
        
        recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordButton setImage:[UIImage imageNamed:@"Record.png"] forState:UIControlStateNormal];
        [recordButton setImage:[UIImage imageNamed:@"RecordSelected.png"] forState:UIControlStateHighlighted];
        [recordButton addTarget:self action:@selector(recordButtonClicked) forControlEvents:UIControlEventTouchDown];
        [recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpInside];
        [recordButton setHighlighted:NO];
//        recordButton.frame = CGRectMake(20.0f, 17.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        [self addSubview:recordButton];
        
        
        UIButton *fxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fxButton setImage:[UIImage imageNamed:@"FX.png"] forState:UIControlStateNormal];
        [fxButton addTarget:self action:@selector(fxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        fxButton.frame = CGRectMake((frame.size.width/2.0f) - (BUTTON_RADIUS/2.0f), 17.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        recordButton.frame = CGRectMake((frame.size.width/2.0f) - (BUTTON_RADIUS/2.0f), 17.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        fxButton.frame = CGRectMake(20.0f, 17.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        [self addSubview:fxButton];
        
        UIButton *importButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [importButton setImage:[UIImage imageNamed:@"Import.png"] forState:UIControlStateNormal];
        [importButton addTarget:self action:@selector(importButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        importButton.frame = CGRectMake(frame.size.width - 78.0f, 17.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        [self addSubview:importButton];

//        UIButton *gestureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [gestureButton setImage:[UIImage imageNamed:@"Motion.png"] forState:UIControlStateNormal];
//        [gestureButton addTarget:self action:@selector(gestureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        gestureButton.frame = CGRectMake(213.0f + 5.0f, 22.0f, 50.0f, 50.0f);
//        [self addSubview:gestureButton];

        
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


//- (void)gestureButtonClicked {
//    [delegate toggleGestureControl];
//}


- (void)recordButtonClicked {
    [delegate startRecording];
    [recordButton setHighlighted:YES];
    
}

- (void)recordButtonReleased {
    [delegate stopRecording];
    [recordButton setHighlighted:NO];
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


//- (void) toggleGestureControl {
//    // Toggle Gesture Control
//}

- (UIImage*) getResizedImage : (NSString*)filename : (UIView*)view {
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:filename] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
