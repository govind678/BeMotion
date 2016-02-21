//
//  BMLoadFileViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/17/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMLoadFileViewController.h"
#import "BMAudioController.h"
#import "BMConstants.h"

static const float kRowHeight = 40.0f;

@interface BMLoadFileViewController() <UITableViewDataSource, UITableViewDelegate>
{
    BMHeaderView*           _headerView;
    
    UISegmentedControl*     _segmentedControl;
    UITableView*            _tableView;
    UIColor*                _foregroundColor;
}
@end


@implementation BMLoadFileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(0.0f, self.margin, self.view.frame.size.width, self.headerHeight)];
    [_headerView setTitle:@"Load Audio File"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont semiboldDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];

    NSArray* segments = [NSArray arrayWithObjects:@"Library", @"Recordings", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [_segmentedControl setFrame:CGRectMake(self.margin, self.headerHeight + self.margin + 20.0f, self.view.frame.size.width - (2.0f * self.margin), 29.0f)];
    [_segmentedControl setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_segmentedControl setTintColor:[UIColor darkGrayColor]];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl setTintColor:_foregroundColor];
    [_segmentedControl addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    
    float tableYPos = _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height + 20.0f;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.margin, tableYPos, self.view.frame.size.width - (2.0f * self.margin), self.view.frame.size.height - tableYPos) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setScrollEnabled:YES];
    [_tableView setRowHeight:kRowHeight];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}


- (void)didReceiveMemoryWarning {
    NSLog(@"Did Receive Memory Warning at BMLoadFileViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BMIndexPath* indexPath = [[BMAudioController sharedController] getIndexPathForTrack:_trackID];
    
    [_segmentedControl setSelectedSegmentIndex:indexPath.library];
    
    NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.index inSection:indexPath.section];
    [_tableView selectRowAtIndexPath:selectedIndexPath animated:animated scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - Public Methods

- (void)setTrackID:(int)trackID {
    
    _trackID = trackID;
    _foregroundColor = (UIColor*)[[UIColor trackColors] objectAtIndex:trackID];
    
    [_segmentedControl setTintColor:_foregroundColor];
}


#pragma mark - UI Action Methods

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentValueChanged {
    
    [_tableView reloadData];
    
    BMIndexPath* indexPath = [[BMAudioController sharedController] getIndexPathForTrack:_trackID];
    
    if (indexPath.library == _segmentedControl.selectedSegmentIndex) {
        NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.index inSection:indexPath.section];
        [_tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return [[[BMAudioController sharedController] getSampleSetTitles] count];
    } else {
        return 2;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return (NSString*)[[[BMAudioController sharedController] getSampleSetTitles] objectAtIndex:section];
    } else {
        
        if (section == 0) {
            return @"Mic Recordings";
        } else if (section == 1) {
            return @"Song Recordings";
        }
    }
    
    return @"";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return kNumTracks;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView* headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setFont:[UIFont semiboldDefaultFontOfSize:12.0f]];
    [headerView.textLabel setTextColor:_foregroundColor];
    [headerView setTintColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRowHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"LoadFileCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setIndentationLevel:1];
        [[cell textLabel] setTextColor:(UIColor*)[[UIColor trackColors] objectAtIndex:_trackID]];
        [[cell textLabel] setFont:[UIFont lightDefaultFontOfSize:12.0f]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIView* selectionColor = [[UIView alloc] init];
        [selectionColor setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.15f]];
        [cell setSelectedBackgroundView: selectionColor];
        
        if (_segmentedControl.selectedSegmentIndex == 0) {
            
            NSString* title = [[[BMAudioController sharedController] getSamplesForIndex:indexPath.section] objectAtIndex:indexPath.row];
            [[cell textLabel] setText:title];
            
        } else {
            [[cell textLabel] setText:@"TODO"];
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BMIndexPath* path = [[BMAudioController sharedController] getIndexPathForTrack:_trackID];
    path.library = _segmentedControl.selectedSegmentIndex;
    path.section = indexPath.section;
    path.index   = indexPath.row;
    
    if ([[BMAudioController sharedController] loadAudioFileIntoTrack:_trackID atIndexPath:path] != 0) {
        NSLog(@"Error Loading Audio File at LoadFileViewController");
    }
}


@end
