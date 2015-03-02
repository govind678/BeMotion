//
//  LoadSampleViewController.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 5/21/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "BeatMotionInterface.h"

#import "WaveformView.h"
#import "LoadMediaFile.h"
//#import "SampleSelect.h"

@interface LoadSampleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    CGPoint lastLocation;
    NSMutableDictionary     *sampleBanks;
    NSMutableArray          *sampleSectionTitles;
    
    LoadMediaFile*          mediaPicker;
    
    int                     currentSegment;
//    SampleSelect*           sampleSelector;
}

@property (retain, nonatomic) IBOutlet WaveformView *waveformView;

@property (retain, nonatomic) IBOutlet UITableView *samplesTable;


- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender;

@property (nonatomic, assign) BeatMotionInterface* backendInterface;
@property (nonatomic, assign) int  sampleID;

@property (nonatomic, assign) NSIndexPath* checkedPath;

- (IBAction)launchMediaLibrary:(UIButton *)sender;

@end
