//
//  BMLoadEffectsViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMLoadEffectsViewController.h"
#import "BMAudioController.h"


@interface BMLoadEffectsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BMHeaderView*       _headerView;
    UITableView*        _tableView;
}
@end

@implementation BMLoadEffectsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(self.margin, self.margin, self.view.frame.size.width - (2.0f * self.margin), self.headerHeight)];
    [_headerView setTitle:[NSString stringWithFormat:@"FX %d", _effectSlot + 1]];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_headerView setTitleColor:(UIColor*)[[UIColor trackColors] objectAtIndex:_trackID]];
    [self.view addSubview:_headerView];
    
    // Table View
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.margin, self.headerHeight + self.margin + 15.0f, self.view.frame.size.width - (2.0f * self.margin), self.view.frame.size.height - self.headerHeight - 15.0f - self.margin)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setRowHeight:self.buttonHeight];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Received Memory Warning at BMLoadEffectsViewController");
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    int effectID = [[BMAudioController sharedController] getEffectOnTrack:_trackID AtSlot:_effectSlot];
    _selectedIndexPath = [NSIndexPath indexPathForRow:effectID inSection:0];
    [_tableView selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIButton Actions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_effectsData) {
        return _effectsData.count;
    } else {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"EffectTitleIdentifier";
    
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
    }
    
    if (_effectsData) {
        NSDictionary* effect = (NSDictionary*)[_effectsData objectAtIndex:indexPath.row];
        NSString* title = [effect objectForKey:@"Title"];
        [[cell textLabel] setText:title];
    } else {
        [[cell textLabel] setText:@"Error"];
    }
    
    return cell;
}


#pragma mark = UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
    [[BMAudioController sharedController] setEffectOnTrack:_trackID AtSlot:_effectSlot withEffect:(int)indexPath.row];
    
    if (indexPath.row == 0) {
        for (int i=0; i < kNumParametersPerEffect; i++) {
            [[BMAudioController sharedController] setMotionMapOnTrack:_trackID AtEffectSlot:_effectSlot ForParameter:i withMap:0];
            [[BMAudioController sharedController] setMotionMinOnTrack:_trackID AtEffectSlot:_effectSlot ForParameter:i withValue:0.0f];
            [[BMAudioController sharedController] setMotionMaxOnTrack:_trackID AtEffectSlot:_effectSlot ForParameter:i withValue:1.0f];
        }
    }
}

@end
