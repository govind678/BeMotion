//
//  BMPlayButton.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMPlayButton : UIView

@property (nonatomic) int trackID;

- (void)updatePlaybackProgress:(float)timeInterval;
- (void)reset;
- (void)tick:(int)count;
- (void)reloadWaveform;

@end
