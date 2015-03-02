//
//  SampleSelect.m
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/18/14.
//  Copyright (c) 2014 BeatMotionLLC. All rights reserved.
//

#import "SampleSelect.h"
#import "BeatMotionAppDelegate.h"

@implementation SampleSelect
{
    BeatMotionAppDelegate*   appDelegate;
}

@synthesize buttonID;

- (id)initWithFrame:(CGRect)frame : (int) identifier
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        buttonID = identifier;
        
        //--- Get Reference to Backend ---//
        appDelegate = [[UIApplication sharedApplication] delegate];
        _backendInterface   =  [appDelegate getBackendReference];
        sampleBanks = [appDelegate sampleSets];
        sampleSectionTitles = [[NSMutableArray alloc] initWithArray:[sampleBanks allKeys]];
        
        
        presetSamplesTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [presetSamplesTable setDelegate:self];
        [presetSamplesTable setDataSource:self];
        [presetSamplesTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [presetSamplesTable setRowHeight:18.0f];
        [presetSamplesTable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:presetSamplesTable];
        
        userSamplesTable = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width, 0.0, frame.size.width, frame.size.height)];
        [userSamplesTable setDelegate:self];
        [userSamplesTable setDataSource:self];
        [userSamplesTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [userSamplesTable setRowHeight:18.0f];
        [userSamplesTable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:userSamplesTable];
        
        [self setContentSize:CGSizeMake(frame.size.width * 3.0, frame.size.height)];
        [self setPagingEnabled:YES];
        
        [self setBackgroundColor:[UIColor darkGrayColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


//--- Sample Table Stuff ---//

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == presetSamplesTable) {
        return [sampleSectionTitles count];
    } else if (tableView == userSamplesTable) {
        return 1;
    } else {
        return 1;
    }
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == presetSamplesTable) {
        return 5;
    } else if (tableView == userSamplesTable) {
        return (_backendInterface->getNumberOfUserRecordings());
    } else {
        return 1;
    }
}


//- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if (tableView == presetSamplesTable) {
//        return [sampleSectionTitles objectAtIndex:section];
//    } else {
//        return @"";
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    [view setTintColor:[UIColor blackColor]];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [[header textLabel] setTextColor:[UIColor whiteColor]];
    
    NSString* sectionTitle;
    if (tableView == presetSamplesTable) {
        sectionTitle = [sampleSectionTitles objectAtIndex:section];
    } else {
        sectionTitle = @"";
    }
    
    [[header textLabel] setText:sectionTitle];
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView* headerView = [tableView headerViewForSection:section];
//    
//    NSString* sectionTitle;
//    if (tableView == presetSamplesTable) {
//        sectionTitle = [sampleSectionTitles objectAtIndex:section];
////        return [sampleSectionTitles objectAtIndex:section];
//    } else {
//        sectionTitle = @"";
//    }
//
////    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
//    [headerView setBackgroundColor:[UIColor blackColor]];
//    [[headerView textLabel] setText:sectionTitle];
//    [[headerView textLabel] setTextColor:[UIColor lightGrayColor]];
//
//    return headerView;
//}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //-- Configure Cell --//
    
    if (tableView == presetSamplesTable) {
        
        NSString *sectionTitle  = [sampleSectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionSamples = [sampleBanks objectForKey:sectionTitle];
        NSString *sample        = [sectionSamples objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:sample];
        
    } else if (tableView == userSamplesTable) {
        
        NSString *sample        = _backendInterface->getUserRecordingFileName((int)[indexPath row]);
        [[cell textLabel] setText:sample];
    }
    
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    switch (buttonID)
    {
        case 0:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f]];
            break;
            
        case 1:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.15f green:0.39f blue:0.78f alpha:1.0f]];
            break;
            
        case 2:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f]];
            break;
            
        case 3:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f]];
            break;
            
        default:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == presetSamplesTable) {
        
        NSString *sectionTitle  = [sampleSectionTitles objectAtIndex:[indexPath section]];
        NSArray *sectionSamples = [sampleBanks objectForKey:sectionTitle];
        NSString *samplePath    = [[NSBundle mainBundle] pathForResource:[sectionSamples objectAtIndex:[indexPath row]] ofType:@"wav"];
        
        _backendInterface->loadAudioFile(buttonID, samplePath);
    }
    
    else if (tableView == userSamplesTable) {
        _backendInterface->loadUserRecordedFile(buttonID, (int)[indexPath row]);
    }
    
    
    [_waveformView setArrayToDrawWaveform : _backendInterface->getSamplesToDrawWaveform(buttonID)];
    
    if (_backendInterface->getSamplePlaybackStatus(buttonID)) {
        _backendInterface->startPlayback(buttonID);
    }
}


@end
