//==============================================================================
//
//  GlobalSettingsViewController.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//
//==============================================================================


#import <UIKit/UIKit.h>
#include "BeatMotionInterface.h"
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


@property (nonatomic, assign) BeatMotionInterface* backendInterface;
@property (nonatomic, assign) Metronome* metronome;



//--- Sample Sets Table ---//
@property (retain, nonatomic) IBOutlet UITableView *sampleSetsTable;


//--- FX Pack Table ---//
@property (retain, nonatomic) IBOutlet UITableView *fxPackTable;



@property (nonatomic, assign) NSIndexPath* samplesCheckedPath;
@property (nonatomic, assign) NSIndexPath* fxCheckedPath;

- (void) loadAudioPresetBank;

@end
