//
//  BMSampleView.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMSampleViewDelegate <NSObject>

- (void)effectsButtonTappedAtTrack:(int)trackID;
- (void)loadSampleButtonTappedAtTrack:(int)trackID;

@end




@interface BMSampleView : UIScrollView

@property (nonatomic) int trackID;
@property (nonatomic, retain) UIImage* sidebarImage;
@property (nonatomic, retain) UIColor* foregroundColor;
@property (nonatomic) BOOL recordingLock;
@property (nonatomic, weak) id <BMSampleViewDelegate> sampleDelegate;

- (void)updatePlaybackProgress;
- (void)reloadWaveform;

@end
