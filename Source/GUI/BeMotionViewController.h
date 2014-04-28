//
//  BeMotionViewController.h
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/28/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "GestureControllerInterface.h"

@interface BeMotionViewController : UIViewController
{
//    GestureControllerInterface*     m_pcBackEndInterface;
    
    
    BOOL            m_bSettingsToggle;
    BOOL            m_bRecordToggle;
    BOOL            m_bMicrophoneToggle;
}

@property   (nonatomic) GestureControllerInterface*     m_pcBackendInterface;


//--- UI Actions ---//

- (IBAction)redButtonTouchDown:(UIButton *)sender;
- (IBAction)redButtonTouchUp:(UIButton *)sender;

- (IBAction)blueButtonTouchDown:(UIButton *)sender;
- (IBAction)blueButtonTouchUp:(UIButton *)sender;

- (IBAction)greenButtonTouchDown:(UIButton *)sender;
- (IBAction)greenButtonTouchUp:(UIButton *)sender;

- (IBAction)yellowButtonTouchDown:(UIButton *)sender;
- (IBAction)yellowButtonTouchUp:(UIButton *)sender;


- (IBAction)settingsButtonClicked:(UIButton *)sender;

- (IBAction)recordButtonClicked:(UIButton *)sender;

- (IBAction)microphoneButtonClicked:(UIButton *)sender;


//--- Utility Methods ---//
- (void)initializeApplication;

- (void)setBackendInterface:(GestureControllerInterface * )backendInterface;



- (void)dealloc;


@end
