//
//  SampleButton.m
//  SampleButton
//
//  Created by Govinda Ram Pingali on 7/6/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import "SampleButton.h"
#import "UIFont+Additions.h"


@implementation SampleButton

@synthesize buttonID, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
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


- (void) setIdentifier:(int)identifier {
    
    buttonID = identifier;
    
    // Initialization code
    
    playButton = [[PlayButton alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.frame.size.width - 40.0f, self.frame.size.height) : buttonID];
    [playButton setTag:(buttonID + 100)];
    [playButton setDelegate:self];
    [self addSubview:playButton];
    
//    NSLog(@"Button %d. X: %f, Y: %f, W: %f, H: %f", buttonID, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    
    dragArrowBack0 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20.0f, 0.0f, 20.0f, 100.0f)];
    [dragArrowBack0 setUserInteractionEnabled:NO];
    
//    dragArrowBack1 = [[UIView alloc] initWithFrame:CGRectMake((2.0 * self.frame.size.width) - 20.0f, 0.0f, 20.0f, 100.0f)];
//    [dragArrowBack1 setUserInteractionEnabled:NO];
    
    switch (buttonID) {
        case 0:
            [dragArrowBack0 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack0.png"]]];
//            [dragArrowBack1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack0.png"]]];
            break;
            
        case 1:
            [dragArrowBack0 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack1.png"]]];
//            [dragArrowBack1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack1.png"]]];
            break;
            
        case 2:
            [dragArrowBack0 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack2.png"]]];
//            [dragArrowBack1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack2.png"]]];
            break;
            
        case 3:
            [dragArrowBack0 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack3.png"]]];
//            [dragArrowBack1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DragArrowBack3.png"]]];
            break;
            
        default:
            break;
    }
    [self addSubview:dragArrowBack0];
//    [self addSubview:dragArrowBack1];
    
    
    
    settingsButton = [[SettingsButton alloc] initWithFrame:CGRectMake(self.frame.size.width + 20.0f, 0.0f, self.frame.size.width - 40.0f, self.frame.size.height) : buttonID];
    [settingsButton setDelegate:self];
    [settingsButton setTag:(buttonID + 200)];
    [self addSubview:settingsButton];
    
    modeButton = [[ModeButton alloc] initWithFrame: CGRectMake((2.0 * self.frame.size.width) + 20.0f, 0.0f, self.frame.size.width - 40.0f, self.frame.size.height) : buttonID];
    [modeButton setDelegate:self];
    [self addSubview:modeButton];
    
    
    dragArrowButton0 = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 20.0f, 0.0f, 20.0f, 100.0f)];
    [dragArrowButton0 setImage:[UIImage imageNamed:@"DragArrowUp.png"] forState:UIControlStateNormal];
    [dragArrowButton0 setImage:[UIImage imageNamed:@"DragArrowDown.png"] forState:UIControlStateHighlighted];
    [dragArrowButton0 setAlpha:0.8f];
    [self addSubview:dragArrowButton0];
    
    dragArrowButton1 = [[UIButton alloc] initWithFrame:CGRectMake((2.0f * self.frame.size.width) - 20.0f, 0.0f, 20.0f, 100.0f)];
    [dragArrowButton1 setImage:[UIImage imageNamed:@"DragArrowUp.png"] forState:UIControlStateNormal];
    [dragArrowButton1 setImage:[UIImage imageNamed:@"DragArrowDown.png"] forState:UIControlStateHighlighted];
    [dragArrowButton1 setAlpha:0.8f];
    [self addSubview:dragArrowButton1];
    
    
    
    statusLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 4.0f, 60.0f, 16.0f)];
    [statusLabel1 setBackgroundColor:[UIColor clearColor]];
    [statusLabel1 setTextAlignment:NSTextAlignmentCenter];
    [statusLabel1 setTextColor:[UIColor blackColor]];
    [statusLabel1 setNumberOfLines:1];
    [statusLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
//    [statusLabel1 setFont:[UIFont systemFontOfSize:10.0f]];
    [statusLabel1 setFont:[UIFont lightDefaultFontOfSize:10.0f]];
    [statusLabel1 setText:@"Recording..."];
    [statusLabel1 setHidden:YES];
    [self addSubview:statusLabel1];
    
    statusLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width) + 30.0f, 4.0f, 60.0f, 16.0f)];
    [statusLabel2 setBackgroundColor:[UIColor clearColor]];
    [statusLabel2 setTextAlignment:NSTextAlignmentCenter];
    [statusLabel2 setTextColor:[UIColor lightGrayColor]];
    [statusLabel2 setNumberOfLines:1];
    [statusLabel2 setLineBreakMode:NSLineBreakByWordWrapping];
//    [statusLabel2 setFont:[UIFont systemFontOfSize:10.0f]];
    [statusLabel2 setFont:[UIFont lightDefaultFontOfSize:10.0f]];
    [statusLabel2 setText:@"Recording..."];
    [statusLabel2 setHidden:YES];
    [self addSubview:statusLabel2];
    
    
    [self setContentSize:CGSizeMake(self.frame.size.width * 3.0, self.frame.size.height)];
    [self setPagingEnabled:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    [self setDelaysContentTouches:NO];
    [self setCanCancelContentTouches:YES];
    
    
//    int position = _backendInterface->getButtonPagePosition(buttonID);
//    CGRect initialFrame = self.frame;
//    initialFrame.origin.y = 0.0f;
//    initialFrame.origin.x = self.frame.size.width;
//    [self scrollRectToVisible:initialFrame animated:NO];
}


- (void)postInitialize {
    [playButton postInitialize:_backendInterface->getSamplePlaybackStatus(buttonID)];
    [modeButton postInitialize:_backendInterface->getSampleParameter(buttonID, PARAM_PLAYBACK_MODE)];
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    
    return YES;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    BOOL returnVal = YES;
    
    if(view.tag == (buttonID+100) || (view.tag == (buttonID+200)))
    {
        returnVal = NO;
    }
    
    return returnVal;
}


- (void)startPlayback {
    _backendInterface->startPlayback(buttonID);
}

- (void)stopPlayback {
    _backendInterface->stopPlayback(buttonID);
}


- (void)startRecording {
    _backendInterface->startRecording(buttonID);
    [statusLabel1 setHidden:NO];
    [statusLabel2 setHidden:NO];
}

- (void)stopRecording {
    _backendInterface->stopRecording(buttonID);
    [statusLabel1 setHidden:YES];
    [statusLabel2 setHidden:YES];
}

- (void)startResampling {
    
}


- (void)launchFXView {
    [delegate launchFXView:buttonID];
}

- (void)launchImportView {
    [delegate launchImportView:buttonID];
}

- (void)toggleGestureControl {
    [delegate toggleGestureControl:buttonID];
}



- (void)launchFXView:(int)sampleID {
    
}

- (void)launchImportView:(int)sampleID {
    
}

- (void) toggleGestureControl:(int)sampleID {
    
}


- (void) setButtonMode:(int)mode {
    [delegate buttonModeChanged:buttonID:mode];
}


- (void)buttonModeChanged:(int)sampleID :(int)buttonMode {
    
}



- (void) updateProgress:(float)value {
    [playButton updateProgress:value];
}

- (void)reloadFromBackground {
    [playButton reloadFromBackground];
}

- (void) dealloc {
    
    [statusLabel1 release];
    [statusLabel2 release];
    [settingsButton release];
    [dragArrowBack0 release];
    [dragArrowButton0 release];
    [dragArrowButton1 release];
    
    [super dealloc];
}
@end
