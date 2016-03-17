//
//  BMSettingsViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/26/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMSettingsViewController.h"
#import "BMAudioController.h"
#import "BMConstants.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

static const float kRowHeight = 40.0f;

@interface BMSettingsViewController() <UITableViewDataSource, UITableViewDelegate>
{
    BMHeaderView*           _headerView;
    
    UISegmentedControl*     _segmentedControl;
    UIScrollView*           _scrollView;
    UITableView*            _samplesTable;
}
@end


@implementation BMSettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(0.0f, self.margin, self.view.frame.size.width, self.headerHeight)];
    [_headerView setTitle:@"Settings"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont semiboldDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];
    
    NSArray* segments = [NSArray arrayWithObjects:@"Sample Sets", @"Effect Presets", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [_segmentedControl setFrame:CGRectMake(self.margin, self.headerHeight + self.margin + 20.0f, self.view.frame.size.width - (2.0f * self.margin), 29.0f)];
    [_segmentedControl setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_segmentedControl setTintColor:[UIColor darkGrayColor]];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl setTintColor:[UIColor textWhiteColor]];
    [_segmentedControl addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    float contentYPos = _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height + 20.0f;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.margin, contentYPos, self.view.frame.size.width - (2.0f * self.margin), self.view.frame.size.height - contentYPos)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBackgroundColor:[UIColor colorWithWhite:0.5f alpha:0.5f]];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * segments.count, _scrollView.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    
    _samplesTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _scrollView.frame.size.width, _scrollView.frame.size.height) style:UITableViewStylePlain];
    [_samplesTable setBackgroundColor:[UIColor clearColor]];
    [_samplesTable setDataSource:self];
    [_samplesTable setDelegate:self];
    [_samplesTable setScrollEnabled:YES];
    [_samplesTable setRowHeight:kRowHeight];
    [_samplesTable setLayoutMargins:UIEdgeInsetsZero];
    [_samplesTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_scrollView addSubview:_samplesTable];
    
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Did Receive Memory Warning at BMSettingsViewController");
}

#pragma mark - UIActions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentValueChanged {
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * _segmentedControl.selectedSegmentIndex, 0.0f, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _samplesTable) {
        return [[[BMAudioController sharedController] getSampleSetTitles] count];
    } else {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"SettingsCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setIndentationLevel:1];
        [[cell textLabel] setTextColor:[UIColor textWhiteColor]];
        [[cell textLabel] setFont:[UIFont lightDefaultFontOfSize:12.0f]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIView* selectionColor = [[UIView alloc] init];
        [selectionColor setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.15f]];
        [cell setSelectedBackgroundView: selectionColor];

        if (tableView == _samplesTable) {
            NSString* title = [[[BMAudioController sharedController] getSampleSetTitles] objectAtIndex:indexPath.row];
            [[cell textLabel] setText:title];
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _samplesTable) {
        
        for (int track=0; track < kNumTracks; track++) {
            
            BMIndexPath* path = [[BMAudioController sharedController] getIndexPathForTrack:track];
            path.library = 0;
            path.section = indexPath.row;
            path.index   = track;
            
            if ([[BMAudioController sharedController] loadAudioFileIntoTrack:track atIndexPath:path] != 0) {
                NSLog(@"Error Loading Audio File at SettingsViewController");
            }
        }
    }
}

@end
