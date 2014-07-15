//==============================================================================
//
//  GlobalSettingsViewController.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import <UIKit/UIKit.h>
#include "BeMotionInterface.h"
#include "Metronome.h"
#include "Macros.h"

@interface GlobalSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int         m_iTempo;
    
    NSString *currentFXPack;
    NSString *currentSampleBank;
    
    NSMutableArray*   sampleSectionTitles;
    NSMutableDictionary* sampleBanks;
    
    NSMutableArray* fxPackSet;
    
}


@property (nonatomic, assign) BeMotionInterface* backendInterface;
@property (nonatomic, assign) Metronome* metronome;



//--- Sample Sets Table ---//
@property (retain, nonatomic) IBOutlet UITableView *sampleSetsTable;

//--- FX Pack Table ---//
@property (retain, nonatomic) IBOutlet UITableView *fxPackTable;



- (void) loadAudioPresetBank;

@end
