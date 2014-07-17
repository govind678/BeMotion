//
//  LoadSampleViewController.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 5/21/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "BeMotionInterface.h"

#import "WaveformView.h"
#import "LoadMediaFile.h"

@interface LoadSampleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    CGPoint lastLocation;
    NSMutableDictionary     *sampleBanks;
    NSMutableArray          *sampleSectionTitles;
    
    LoadMediaFile*                  mediaPicker;
}

@property (nonatomic, retain) IBOutlet WaveformView *waveformView;

@property (retain, nonatomic) IBOutlet UITableView *samplesTable;

@property (nonatomic, assign) BeMotionInterface* backendInterface;
@property (nonatomic, assign) int  sampleID;

@property (nonatomic, assign) NSIndexPath* checkedPath;

- (IBAction)launchMediaLibrary:(UIButton *)sender;

@end
