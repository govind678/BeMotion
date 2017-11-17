//
//  BMSampleButton.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 9/26/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMConstants.h"

@protocol BMSampleButtonDelegate <NSObject>
- (void)effectsButtonTappedAtTrack:(int)trackID;
- (void)loadSampleButtonTappedAtTrack:(int)trackID;
@end


@interface BMSampleButton : UIView

@property (nonatomic) int trackID;
@property (nonatomic, retain) UIColor* foregroundColor;
@property (nonatomic) BMSampleMode  currentMode;
@property (nonatomic, weak) id <BMSampleButtonDelegate> sampleDelegate;

- (void)updatePlaybackProgress:(float)timeInterval;
- (void)reset;
- (void)viewWillAppear;
- (void)tick:(int)count;

- (void)updateTitle;
- (void)updateWaveform:(BOOL)shouldDraw;

@end
