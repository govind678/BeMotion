//
//  BMSettingsViewController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/26/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMSettingsViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "BMAppSettingsViewController.h"
#import "BMMotionSettingsViewController.h"

#import "BMAudioController.h"
#import "BMSequencer.h"
#import "BMConstants.h"
#import "BMSettings.h"

#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

static NSString* const kHorizontalSeparatorImage        =   @"HorizontalSeparator.png";
static NSString* const kSettingsOptionImage             =   @"FXTitleBackground.png";

@interface BMSettingsViewController() <UITableViewDataSource, UITableViewDelegate>
{
    BMHeaderView*           _headerView;
    
    UISegmentedControl*     _segmentedControl;
    UITableView*            _tableView;
}
@end


@implementation BMSettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    float xMargin = self.margin;
    float yPos = self.margin;
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.headerHeight)];
    [_headerView setTitle:@"Settings / Projects"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    
    // App Settings
    yPos += self.headerHeight + self.yGap;
    UIButton* appSettingsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), self.buttonHeight)];
    [appSettingsButton setBackgroundImage:[UIImage imageNamed:kSettingsOptionImage] forState:UIControlStateNormal];
    [appSettingsButton.titleLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [appSettingsButton setTitleColor:[UIColor textWhiteColor] forState:UIControlStateNormal];
    [appSettingsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [appSettingsButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    [appSettingsButton setTitle:@"App Settings" forState:UIControlStateNormal];
    [appSettingsButton addTarget:self action:@selector(appSettingsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appSettingsButton];
    
    // User Settings
    yPos += self.buttonHeight;
    UIButton* userSettingsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), self.buttonHeight)];
    [userSettingsButton setBackgroundImage:[UIImage imageNamed:kSettingsOptionImage] forState:UIControlStateNormal];
    [userSettingsButton.titleLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [userSettingsButton setTitleColor:[UIColor textWhiteColor] forState:UIControlStateNormal];
    [userSettingsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [userSettingsButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    [userSettingsButton setTitle:@"No User" forState:UIControlStateNormal];
    [userSettingsButton addTarget:self action:@selector(userSettingsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userSettingsButton];
    
    
    // Separator
    yPos += self.buttonHeight + self.yGap;
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), self.verticalSeparatorHeight)];
    [separatorView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHorizontalSeparatorImage]]];
    [self.view addSubview:separatorView1];
    
    // Save Project
    yPos += self.yGap;
    UIButton* saveProjectButton = [[UIButton alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), 40.0f)];
    [saveProjectButton.titleLabel setFont:[UIFont lightDefaultFontOfSize:12.0f]];
    [saveProjectButton setTitleColor:[UIColor textWhiteColor] forState:UIControlStateNormal];
    [saveProjectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [saveProjectButton setTitle:@"Save Project As" forState:UIControlStateNormal];
    [saveProjectButton setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.8f]];
    [saveProjectButton addTarget:self action:@selector(saveProjectButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [saveProjectButton addTarget:self action:@selector(saveProjectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveProjectButton];
    
    
    yPos += saveProjectButton.frame.size.height + self.yGap;
    NSArray* segments = [NSArray arrayWithObjects:@"Projects", @"Sample Sets", nil];
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont semiboldDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    [_segmentedControl setFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), 29.0f)];
    [_segmentedControl setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl setTintColor:[UIColor textWhiteColor]];
    [_segmentedControl addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    
    yPos += _segmentedControl.frame.size.height + self.yGap;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.view.frame.size.height - yPos) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setScrollEnabled:YES];
    [_tableView setAllowsMultipleSelectionDuringEditing:NO];
    [_tableView setRowHeight:self.buttonHeight];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Did Receive Memory Warning at BMSettingsViewController");
}

#pragma mark - UIActions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentValueChanged {
    [_tableView reloadData];
//    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * _segmentedControl.selectedSegmentIndex, 0.0f, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return [[[BMSettings sharedInstance] getListOfSavedProjects] count];
    } else if (_segmentedControl.selectedSegmentIndex == 1) {
        return [[[BMAudioController sharedController] getListOfSampleTitles] count];
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
    }
    
    NSString* title;
    if (_segmentedControl.selectedSegmentIndex == 0) {
        title = [[[BMSettings sharedInstance] getListOfSavedProjects] objectAtIndex:indexPath.row];
    } else if (_segmentedControl.selectedSegmentIndex == 1) {
        title = [[[BMAudioController sharedController] getListOfSampleTitles] objectAtIndex:indexPath.row];
    }
    [[cell textLabel] setText:title];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [[BMSettings sharedInstance] loadProjectAtIndex:indexPath.row];
    } else if (_segmentedControl.selectedSegmentIndex == 1) {
        [self loadSampleSet:indexPath];
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction* delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            [[BMSettings sharedInstance] deleteProjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    [delete setBackgroundColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f]];
    [delete setBackgroundEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    UITableViewRowAction* share = share = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self launchShareActionSheet:indexPath];
    }];
    [share setBackgroundColor:[UIColor colorWithRed:0.0f green:0.7f blue:0.0f alpha:0.5f]];
    [share setBackgroundEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    NSArray* array = [NSArray arrayWithObjects:delete, share, nil];
    return array;
}

//#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger page = roundf(_scrollView.contentOffset.x / _scrollView.frame.size.width);
//    [_segmentedControl setSelectedSegmentIndex:page];
//}

#pragma mark - UIButton

- (void)saveProjectButtonTouchDown:(UIButton*)sender {
    [sender setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.8f]];
}
- (void)saveProjectButtonTapped:(UIButton*)sender {
    [self launchSaveProjectDialog];
    [sender setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.8f]];
}

- (void)appSettingsButtonTapped:(UIButton*)sender{
    BMAppSettingsViewController* vc = [[BMAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userSettingsButtonTapped:(UIButton*)sender {
    
}

#pragma mark - Private

- (void)saveProject:(NSString*)name {
    if ([[BMSettings sharedInstance] saveProjectWithName:name]) {
        [_tableView reloadData];
    } else {
        [self launchError:@"Could not save project."];
    }
}

- (void)launchSaveProjectDialog {
    
    NSString* message = @"Save all current track and effect settings as ...";
    UIAlertController* saveDialog = [UIAlertController alertControllerWithTitle:@"Save Project?"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSString* text = saveDialog.textFields.firstObject.text;
                                                           if ([self isExistingProjectName:text]) {
                                                               [self launchOverwriteConfirmation:text];
                                                           } else {
                                                               [self saveProject:text];
                                                           }
                                                       }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        
                                                         }];
    
    
    [saveDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
         [textField setClearButtonMode:UITextFieldViewModeAlways];
    }];
    [saveDialog addAction:saveAction];
    [saveDialog addAction:cancelAction];
    
    [self presentViewController:saveDialog animated:YES completion:nil];
}

- (BOOL)isExistingProjectName:(NSString*)name {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* projectsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Projects"];
    
    NSString* filepath = [projectsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        return YES;
    }
    
    return NO;
}

- (void)launchOverwriteConfirmation:(NSString*)name {
    
    NSString* message = [NSString stringWithFormat:@"Project '%@' already exists", name];
    
    UIAlertController* confirmDialog = [UIAlertController alertControllerWithTitle:@"Confirm Overwrite?"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Confirm"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self saveProject:name];
                                                       }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    [confirmDialog addAction:saveAction];
    [confirmDialog addAction:cancelAction];
    
    [self presentViewController:confirmDialog animated:YES completion:nil];
}



- (void)launchError:(NSString*)message {
    
    UIAlertController* dialog = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [dialog addAction:okAction];
    
    [self presentViewController:dialog animated:YES completion:nil];
}

- (void)loadSampleSet:(NSIndexPath*)indexPath {
    
    // Stop audio controller
    [[BMAudioController sharedController] stop];
    
    NSString* title = (NSString*)[[[BMAudioController sharedController] getListOfSampleTitles] objectAtIndex:indexPath.row];
    NSArray* samples = [[BMAudioController sharedController] getAllSamplesForTitle:title];
    int track = 0;
    for (NSString* name in samples) {
        if (![[BMAudioController sharedController] loadAudioFileIntoTrack:track fromLibrary:BMLibrary_BuiltIn withName:name optionalSection:BMMicLibrary_NotApplicable]) {
            NSLog(@"SettingsViewController: Error Loading Audio File: %@", name);
        }
        track++;
    }
    
    NSDictionary* time = [[BMAudioController sharedController] getTimeDictionaryForTitle:title];
    [[BMSequencer sharedSequencer] setTempo:[time[@"Tempo"] floatValue]];
    [[BMSequencer sharedSequencer] setMeter:[time[@"Meter"] intValue]];
    [[BMSequencer sharedSequencer] setInterval:[time[@"Interval"] intValue]];
    
    // Restart audio controller
    [[BMAudioController sharedController] restart];
}



- (void)launchShareActionSheet:(NSIndexPath*)indexPath {
    
    NSString* filename = [(NSString*)[[[BMSettings sharedInstance] getListOfSavedProjects] objectAtIndex:indexPath.row] stringByAppendingPathExtension:@"plist"];
    NSString* filepath = [[[BMSettings sharedInstance] projectsDirectory] stringByAppendingPathComponent:filename];
    
    NSString* message = [NSString stringWithFormat:@"\"%@\"\n\nProject created for BeMotion on iOS", filename];
    NSURL* fileUrl = [NSURL fileURLWithPath:filepath isDirectory:NO];
    NSArray* items = @[message, fileUrl];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeOpenInIBooks,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePrint,
                                         UIActivityTypeSaveToCameraRoll];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}


@end
