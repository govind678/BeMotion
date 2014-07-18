//
//  TempoPicker.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 7/16/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEMPO_DIGITS    3

@interface TempoPicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    int pickerValue [3];
    int tempo;
}

@property (nonatomic, retain) UIPickerView* picker;
@property (nonatomic, retain) UISwitch*     toggleSwitch;
@property (nonatomic, retain) UISwitch*     audioSwitch;

@property (nonatomic, assign) id  delegate;


- (void) toggleSwitchChanged;
- (void) audioSwitchChanged;

- (void) calculateTempo;
- (void) updateTempo;


- (void) toggleMetronome : (BOOL)value;
- (void) toggleMetronomeAudio : (BOOL)value;
- (void) setTempo : (int)newTempo;

- (BOOL) getMetronomeStatus;


@end
