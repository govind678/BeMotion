//
//  SampleSelect.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/18/14.
//  Copyright (c) 2014 BeatMotionLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BeatMotionInterface.h"
#include "WaveformView.h"

@interface SampleSelect : UIScrollView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView* userSamplesTable;
    UITableView* presetSamplesTable;
    
    NSMutableDictionary     *sampleBanks;
    NSMutableArray          *sampleSectionTitles;
}

- (id)initWithFrame:(CGRect)frame : (int)identifier;
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;

@property (nonatomic, assign) int buttonID;
@property (nonatomic, assign) BeatMotionInterface* backendInterface;
@property (nonatomic, assign) WaveformView* waveformView;

@end
