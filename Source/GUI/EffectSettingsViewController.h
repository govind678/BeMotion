//
//  EffectSettingsViewController.h
//  SharedLibrary
//
//  Created by Anand on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import  <UIKit/UIKit.h>
#include "GestureControllerInterface.h"
#include "Macros.h"


@interface EffectSettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int             m_iCurrentEffectPosition;

}

@property (nonatomic, assign) GestureControllerInterface* backEndInterface;
@property (nonatomic, assign) int  m_iCurrentSampleID;


@property (nonatomic, retain) NSArray *effectNames;


//--- UI Objects ---//

@property (retain, nonatomic) IBOutlet UISlider *gainSliderObject;
@property (retain, nonatomic) IBOutlet UISegmentedControl *playbackModeObject;
@property (retain, nonatomic) IBOutlet UISlider *quantizationSliderObject;

@property (retain, nonatomic) IBOutlet UILabel *gainLabel;
@property (retain, nonatomic) IBOutlet UILabel *quantizationLabel;

@property (retain, nonatomic) IBOutlet UIPickerView *pickerObject;

@property (retain, nonatomic) IBOutlet UISlider *slider1Object;
@property (retain, nonatomic) IBOutlet UISlider *slider2Object;
@property (retain, nonatomic) IBOutlet UISlider *slider3Object;
@property (retain, nonatomic) IBOutlet UISwitch *bypassButtonObject;


@property (retain, nonatomic) IBOutlet UILabel *slider1EffectParam;
@property (retain, nonatomic) IBOutlet UILabel *slider2EffectParam;
@property (retain, nonatomic) IBOutlet UILabel *slider3EffectParam;

@property (retain, nonatomic) IBOutlet UILabel *slider1CurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *slider2CurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *slider3CurrentValue;



@property (retain, nonatomic) IBOutlet UIButton *gainGestureObject;
@property (retain, nonatomic) IBOutlet UIButton *quantGestureObject;
@property (retain, nonatomic) IBOutlet UIButton *param1GestureObject;
@property (retain, nonatomic) IBOutlet UIButton *param2GestureObject;
@property (retain, nonatomic) IBOutlet UIButton *param3GestureObject;



- (void) updateSlidersAndLabels;





@end

