//
//  ModeButton.m
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/21/14.
//  Copyright (c) 2014 BeatMotion. All rights reserved.
//

#import "ModeButton.h"
#import "Macros.h"
#import "UIFont+Additions.h"

#define BUTTON_RADIUS 55.0f

@implementation ModeButton

@synthesize buttonID, delegate;

- (id)initWithFrame:(CGRect)frame : (int)identifier
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        buttonID = identifier;
        
        
        sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, frame.size.height)];
        [self addSubview:sideBar];
        
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBackground.png":self]]];
        
        
        loopModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loopModeButton setBackgroundImage:[UIImage imageNamed:@"Loop.png"] forState:UIControlStateNormal];
        [loopModeButton addTarget:self action:@selector(loopModeClicked) forControlEvents:UIControlEventTouchUpInside];
        loopModeButton.frame = CGRectMake(20.0f, 12.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        [self addSubview:loopModeButton];
        
        UILabel* loopModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 12.0f + BUTTON_RADIUS, 60.0f, 16.0f)];
        [loopModeLabel setBackgroundColor:[UIColor clearColor]];
        [loopModeLabel setTextAlignment:NSTextAlignmentCenter];
        [loopModeLabel setTextColor:[UIColor lightGrayColor]];
        [loopModeLabel setNumberOfLines:1];
        [loopModeLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [loopModeLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [loopModeLabel setFont:[UIFont lightDefaultFontOfSize: 10.0f]];
        [loopModeLabel setText:@"Loop"];
        [self addSubview:loopModeLabel];
        
        oneShotModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [oneShotModeButton setBackgroundImage:[UIImage imageNamed:@"Trigger.png"] forState:UIControlStateNormal];
        [oneShotModeButton addTarget:self action:@selector(oneShotModeClicked) forControlEvents:UIControlEventTouchUpInside];
        oneShotModeButton.frame = CGRectMake((frame.size.width/2.0f) - (BUTTON_RADIUS/2.0f), 12.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        [self addSubview:oneShotModeButton];
        
        UILabel* oneShotModeLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width/2.0f) - 30.0f, 12.0f + BUTTON_RADIUS, 60.0f, 16.0f)];
        [oneShotModeLabel setBackgroundColor:[UIColor clearColor]];
        [oneShotModeLabel setTextAlignment:NSTextAlignmentCenter];
        [oneShotModeLabel setTextColor:[UIColor lightGrayColor]];
        [oneShotModeLabel setNumberOfLines:1];
        [oneShotModeLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [oneShotModeLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [oneShotModeLabel setFont:[UIFont lightDefaultFontOfSize: 10.0f]];
        [oneShotModeLabel setText:@"One Shot"];
        [self addSubview:oneShotModeLabel];

        
        beatRepeatModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [beatRepeatModeButton setBackgroundImage:[UIImage imageNamed:@"BeatRepeat.png"] forState:UIControlStateNormal];
        [beatRepeatModeButton addTarget:self action:@selector(beatRepeatModeClicked) forControlEvents:UIControlEventTouchUpInside];
        beatRepeatModeButton.frame = CGRectMake(frame.size.width - 20.0f - BUTTON_RADIUS, 12.0f, BUTTON_RADIUS, BUTTON_RADIUS);
        [self addSubview:beatRepeatModeButton];
        
        UILabel* beatRepeatModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 78.0f, 12.0f + BUTTON_RADIUS, 60.0f, 16.0f)];
        [beatRepeatModeLabel setBackgroundColor:[UIColor clearColor]];
        [beatRepeatModeLabel setTextAlignment:NSTextAlignmentCenter];
        [beatRepeatModeLabel setTextColor:[UIColor lightGrayColor]];
        [beatRepeatModeLabel setNumberOfLines:1];
        [beatRepeatModeLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [beatRepeatModeLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [beatRepeatModeLabel setFont:[UIFont lightDefaultFontOfSize:10.0f]];
        [beatRepeatModeLabel setText:@"Note Repeat"];
        [self addSubview:beatRepeatModeLabel];
        
        
        switch (buttonID) {
            case 0:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar0.png":sideBar]]];
                [loopModeButton setImage:[UIImage imageNamed:@"SettingsSelect0.png"] forState:UIControlStateSelected];
                [oneShotModeButton setImage:[UIImage imageNamed:@"SettingsSelect0.png"] forState:UIControlStateSelected];
                [beatRepeatModeButton setImage:[UIImage imageNamed:@"SettingsSelect0.png"] forState:UIControlStateSelected];
                break;
                
            case 1:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar1.png":sideBar]]];
                [loopModeButton setImage:[UIImage imageNamed:@"SettingsSelect1.png"] forState:UIControlStateSelected];
                [oneShotModeButton setImage:[UIImage imageNamed:@"SettingsSelect1.png"] forState:UIControlStateSelected];
                [beatRepeatModeButton setImage:[UIImage imageNamed:@"SettingsSelect1.png"] forState:UIControlStateSelected];
                break;
                
            case 2:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar2.png":sideBar]]];
                [loopModeButton setImage:[UIImage imageNamed:@"SettingsSelect2.png"] forState:UIControlStateSelected];
                [oneShotModeButton setImage:[UIImage imageNamed:@"SettingsSelect2.png"] forState:UIControlStateSelected];
                [beatRepeatModeButton setImage:[UIImage imageNamed:@"SettingsSelect2.png"] forState:UIControlStateSelected];
                break;
                
            case 3:
                [sideBar setBackgroundColor:[UIColor colorWithPatternImage:[self getResizedImage:@"SettingsBar3.png":sideBar]]];
                [loopModeButton setImage:[UIImage imageNamed:@"SettingsSelect3.png"] forState:UIControlStateSelected];
                [oneShotModeButton setImage:[UIImage imageNamed:@"SettingsSelect3.png"] forState:UIControlStateSelected];
                [beatRepeatModeButton setImage:[UIImage imageNamed:@"SettingsSelect3.png"] forState:UIControlStateSelected];
                break;
                
            default:
                break;
        }

        
    }
    return self;
}

- (void)postInitialize :(int)buttonMode {
    currentMode = buttonMode;
    [self displayCurrentMode];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)loopModeClicked {
    currentMode = MODE_LOOP;
    [delegate setButtonMode:currentMode];
    [self displayCurrentMode];
}

- (void)oneShotModeClicked {
    currentMode = MODE_TRIGGER;
    [delegate setButtonMode:currentMode];
    [self displayCurrentMode];
}

- (void)beatRepeatModeClicked {
    currentMode = MODE_BEATREPEAT;
    [delegate setButtonMode:currentMode];
    [self displayCurrentMode];
}



- (void)setButtonMode:(int)mode {
    
}


- (void) dealloc
{
    
    [super dealloc];
}



- (UIImage*) getResizedImage : (NSString*)filename : (UIView*)view {
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:filename] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



- (void) displayCurrentMode {
    
    switch (currentMode) {
        case MODE_LOOP:
            [loopModeButton setSelected:YES];
            [oneShotModeButton setSelected:NO];
            [beatRepeatModeButton setSelected:NO];
            break;
            
        case MODE_TRIGGER:
            [loopModeButton setSelected:NO];
            [oneShotModeButton setSelected:YES];
            [beatRepeatModeButton setSelected:NO];
            break;
            
        case MODE_BEATREPEAT:
            [loopModeButton setSelected:NO];
            [oneShotModeButton setSelected:NO];
            [beatRepeatModeButton setSelected:YES];
            break;
            
        default:
            break;
    }
}


@end
