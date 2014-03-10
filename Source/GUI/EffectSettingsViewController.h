//
//  EffectSettingsViewController.h
//  SharedLibrary
//
//  Created by Anand on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import  <UIKit/UIKit.h>
#include  "UserInterfaceData.h"
#include "GestureControllerInterface.h"
#include "Macros.h"


@interface EffectSettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{

//    BOOL  m_bEffectBypassToggle[NUM_EFFECTS];
//    int   m_iCurrentEffectChosen;
//    int   m_iCurrentEffectPosition;
//    float m_fSliderValues[NUM_EFFECTS_PARAMS]; // these are just indicators, they will be mapped to actual effects params
//                                        // which will be passed from the UserInterfaceData class
    
}

@property (nonatomic, assign) GestureControllerInterface* backEndInterface;
@property (nonatomic, assign) int  m_iCurrentSampleID;

@property (nonatomic,assign) SampleInfo *currentData;

@property (retain, nonatomic) IBOutlet UISlider *slider1Object;
@property (retain, nonatomic) IBOutlet UISlider *slider2Object;
@property (retain, nonatomic) IBOutlet UISlider *slider3Object;
@property (retain, nonatomic) IBOutlet UISwitch *bypassButtonObject;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerObject;
@end

