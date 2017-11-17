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


static NSString* const kLoopNormalImage             = @"Options-Loop-Normal.png";
static NSString* const kLoopSelectedImage           = @"Options-Loop-Selected.png";
static NSString* const kOneShotNormalImage          = @"Options-OneShot-Normal.png";
static NSString* const kOneShotSelectedImage        = @"Options-OneShot-Selected.png";
static NSString* const kBeatRepeatNormalImage       = @"Options-BeatRepeat-Normal.png";
static NSString* const kMBeatRepeatSelectedImage    = @"Options-BeatRepeat-Selected.png";

static NSString* const kHorizontalSeparatorImage    =   @"HorizontalSeparator.png";


@interface BMLoadFileViewController() <UITableViewDataSource, UITableViewDelegate>
{
    BMHeaderView*           _headerView;
    
    UIButton*               _loopButton;
    UIButton*               _oneShotButton;
    UIButton*               _beatRepeatButton;
    
    UISegmentedControl*     _segmentedControl;
    UITableView*            _tableView;
    UIColor*                _foregroundColor;
    
    BMPlaybackMode          _currentPlaybackMode;
    BMLibrary              _currentLibrary;
    
    NSString*               _masterRecordingsDirectory;
    NSString*               _tempMicRecordingsDirectory;
    NSString*               _savedMicRecordingsDirectory;
    NSMutableArray*         _tempMicRecordings;
    NSMutableArray*         _savedMicRecordings;
    NSMutableArray*         _masterRecordings;
}
@end


@implementation BMLoadFileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat xMargin = self.margin;
    CGFloat yPos = self.margin;
    
    // Header
    _headerView = [[BMHeaderView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.headerHeight)];
    [_headerView setTitle:@"Load Audio File"];
    [_headerView addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    
    
    // Playback Option Select
    
    yPos += self.headerHeight + self.yGap;
    
    CGFloat xOptionMargin = xMargin * 2.0f;
    CGFloat xOptionWidth = self.view.frame.size.width - (2.0f * xOptionMargin);
    CGFloat xOptionGap = (xOptionWidth - (3.0f * self.optionButtonSize)) / 2.0f;
    
//    float optionSelectButtonGap = (self.view.frame.size.width - (2.0f * xMargin) - (4.0f * kOptionButtonSize)) / 3.0f;
//    float xOffset = (self.view.frame.size.width - (kOptionButtonSize * 3.0f) + (optionSelectButtonGap * 2.0f)) / 2.0f;
    
    _loopButton = [[UIButton alloc] initWithFrame:CGRectMake(xOptionMargin, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_loopButton setImage:[UIImage imageNamed:kLoopNormalImage] forState:UIControlStateNormal];
    [_loopButton setImage:[UIImage imageNamed:kLoopSelectedImage] forState:UIControlStateSelected];
    [_loopButton setTag:BMPlaybackMode_Loop];
    [_loopButton addTarget:self action:@selector(playbackOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loopButton];
    
    _oneShotButton = [[UIButton alloc] initWithFrame:CGRectMake(xOptionMargin + self.optionButtonSize + xOptionGap, yPos, self.optionButtonSize, self.optionButtonSize)];
    [_oneShotButton setImage:[UIImage imageNamed:kOneShotNormalImage] forState:UIControlStateNormal];
    [_oneShotButton setImage:[UIImage imageNamed:kOneShotSelectedImage] forState:UIControlStateSelected];
    [_oneShotButton setTag:BMPlaybackMode_OneShot];
    [_oneShotButton addTarget:self action:@selector(playbackOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_oneShotButton];

    _beatRepeatButton = [[UIButton alloc] initWithFrame:CGRectMake(xOptionMargin + (2.0f * (self.optionButtonSize + xOptionGap)), yPos, self.optionButtonSize, self.optionButtonSize)];
    [_beatRepeatButton setImage:[UIImage imageNamed:kBeatRepeatNormalImage] forState:UIControlStateNormal];
    [_beatRepeatButton setImage:[UIImage imageNamed:kMBeatRepeatSelectedImage] forState:UIControlStateSelected];
    [_beatRepeatButton setTag:BMPlaybackMode_BeatRepeat];
    [_beatRepeatButton setUserInteractionEnabled:NO];
    [_beatRepeatButton setEnabled:NO];
    [_beatRepeatButton setAlpha:0.3f];
//    [_beatRepeatButton addTarget:self action:@selector(playbackOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_beatRepeatButton];
    
    
    
    // Separator
    yPos += self.optionButtonSize + self.yGap;
    UIView* separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(self.margin, yPos, self.view.frame.size.width - (2.0f * self.margin), self.verticalSeparatorHeight)];
    [separatorView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kHorizontalSeparatorImage]]];
    [self.view addSubview:separatorView1];
    
    
    
    // Library Segmented Control
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont semiboldDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];

    NSArray* segments = [NSArray arrayWithObjects:@"Stock", @"Mic", @"Song", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    yPos += self.verticalSeparatorHeight + self.yGap;
    [_segmentedControl setFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), 29.0f)];
    [_segmentedControl setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [_segmentedControl setTintColor:[UIColor darkGrayColor]];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl setTintColor:_foregroundColor];
    [_segmentedControl addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    
    
    // Samples Table
    yPos += _segmentedControl.frame.size.height + self.yGap;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(xMargin, yPos, self.view.frame.size.width - (2.0f * xMargin), self.view.frame.size.height - yPos) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setScrollEnabled:YES];
    [_tableView setRowHeight:self.buttonHeight];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    _currentPlaybackMode = BMPlaybackMode_Loop;
    _currentLibrary = [[BMAudioController sharedController] getAudioFileLibraryOnTrack:_trackID];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents = [NSString stringWithString:(NSString*)[paths objectAtIndex:0]];
    _masterRecordingsDirectory = [[NSString alloc] initWithString:[documents stringByAppendingPathComponent:@"MasterRecordings"]];
    _savedMicRecordingsDirectory = [[NSString alloc] initWithString:[documents stringByAppendingPathComponent:@"SavedMicRecordings"]];
    _tempMicRecordingsDirectory = [[NSString alloc] initWithString:[[BMAudioController sharedController] getTempMicRecordingDirectory]];
    
    _tempMicRecordings = [[NSMutableArray alloc] init];
    _savedMicRecordings = [[NSMutableArray alloc] init];
    _masterRecordings = [[NSMutableArray alloc] init];
}


- (void)didReceiveMemoryWarning {
    NSLog(@"Did Receive Memory Warning at BMLoadFileViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self readAudioFileDirectories];
    
    _currentPlaybackMode = (BMPlaybackMode)[[BMAudioController sharedController] getPlaybackModeOnTrack:_trackID];
    [self updatePlaybackModeOptionsUI];
    
    [_segmentedControl setSelectedSegmentIndex:(NSInteger)_currentLibrary];
    
//    BMIndexPath* indexPath = [[BMAudioController sharedController] getIndexPathForTrack:_trackID];
    
//    NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.index inSection:indexPath.section];
//    [_tableView selectRowAtIndexPath:selectedIndexPath animated:animated scrollPosition:UITableViewScrollPositionMiddle];
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

- (void)playbackOptionTapped:(UIButton*)sender {
    _currentPlaybackMode = (BMPlaybackMode)sender.tag;
    [[BMAudioController sharedController] setPlaybackModeOnTrack:_trackID withMode:_currentPlaybackMode];
    [self updatePlaybackModeOptionsUI];
}

- (void)segmentValueChanged {
    _currentLibrary = (BMLibrary)_segmentedControl.selectedSegmentIndex;
    [_tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    switch (_currentLibrary) {
        case BMLibrary_BuiltIn:
            return [[[BMAudioController sharedController] getListOfSampleTitles] count];
            break;
        
        case BMLibrary_MicRecordings:
            return 2;
            break;
            
        case BMLibrary_MasterRecordings:
        default:
            break;
    }
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (_currentLibrary) {
        case BMLibrary_BuiltIn:
            return (NSString*)[[[BMAudioController sharedController] getListOfSampleTitles] objectAtIndex:section];
            break;
        
        case BMLibrary_MicRecordings:
            if (section == BMMicLibrary_Temporary) {
                return @"Temporary";
            } else if (section == BMMicLibrary_Saved) {
                return @"Saved";
            }
            break;
            
        case BMLibrary_MasterRecordings:
        default:
            break;
    }
    
    return @"";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (_currentLibrary) {
        
        case BMLibrary_BuiltIn:
            return kNumButtonTracks;
            break;
        
        case BMLibrary_MicRecordings:
            if (section == BMMicLibrary_Temporary) {
                return _tempMicRecordings.count;
            } else if (section == BMMicLibrary_Saved) {
                return _savedMicRecordings.count;
            }
            break;
            
        case BMLibrary_MasterRecordings:
            return _masterRecordings.count;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView* headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setFont:[UIFont semiboldDefaultFontOfSize:12.0f]];
    [headerView.textLabel setTextColor:_foregroundColor];
    [headerView setTintColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.buttonHeight;
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
    }
    
    
    switch (_currentLibrary) {
        
        case BMLibrary_BuiltIn:
        {
            NSArray* titles = [[BMAudioController sharedController] getListOfSampleTitles];
            NSString* title = [titles objectAtIndex:indexPath.section];
            NSArray* array = [[BMAudioController sharedController] getAllSamplesForTitle:title];
            NSString* name = [array objectAtIndex:indexPath.row];
            [[cell textLabel] setText:name];
            break;
        }
            
        case BMLibrary_MicRecordings:
            if (indexPath.section == BMMicLibrary_Temporary) {
                [[cell textLabel] setText:[_tempMicRecordings objectAtIndex:indexPath.row]];
            } else if (indexPath.section == BMMicLibrary_Saved) {
                [[cell textLabel] setText:[_savedMicRecordings objectAtIndex:indexPath.row]];
            }
            break;
            
        case BMLibrary_MasterRecordings:
            [[cell textLabel] setText:[_masterRecordings objectAtIndex:indexPath.row]];
            break;
            
        default:
            [[cell textLabel] setText:@"<Nothing here>"];
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* currentCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* name = [[currentCell textLabel] text];
    if (![[BMAudioController sharedController] loadAudioFileIntoTrack:_trackID fromLibrary:_currentLibrary withName:name optionalSection:(BMMicLibrary)indexPath.section]) {
        NSLog(@"LoadFileViewController: Error loading audio file: %@", name);
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (_currentLibrary) {
        case BMLibrary_BuiltIn:
            return NO;
            break;
            
        case BMLibrary_MicRecordings:
        case BMLibrary_MasterRecordings:
            return YES;
            break;
            
        default:
            break;
    }
    return NO;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction* delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (_currentLibrary != BMLibrary_BuiltIn) {
            [self deleteFileAtIndex:indexPath inLibrary:_currentLibrary];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    [delete setBackgroundColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f]];
    [delete setBackgroundEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    NSString* optionTitle;
    if (_currentLibrary == BMLibrary_MicRecordings) {
        if (indexPath.section == BMMicLibrary_Temporary) {
            optionTitle = @"Save";
        } else {
            optionTitle = @"Rename";
        }
    } else if (_currentLibrary == BMLibrary_MasterRecordings) {
        optionTitle = @"Rename";
    }

    UITableViewRowAction* option = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:optionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (_currentLibrary != BMLibrary_BuiltIn) {
            [self launchOptionDialog:optionTitle at:indexPath forLibrary:_currentLibrary];
        }
    }];
    [option setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.8f alpha:0.5f]];
    [option setBackgroundEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    
    UITableViewRowAction* share = nil;
    if ((indexPath.section == BMMicLibrary_Saved) || (_currentLibrary == BMLibrary_MasterRecordings)) {
        share = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self launchShareActionSheet:indexPath forLibrary:_currentLibrary];
        }];
        [share setBackgroundColor:[UIColor colorWithRed:0.0f green:0.7f blue:0.0f alpha:0.5f]];
        [share setBackgroundEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    
    
    NSArray* array = [NSArray arrayWithObjects:delete, option, share, nil];
    return array;
}

#pragma mark - Private Methods

- (void)updatePlaybackModeOptionsUI {
    
    switch (_currentPlaybackMode) {
            
        case BMPlaybackMode_Loop:
            [_loopButton setSelected:YES];
            [_oneShotButton setSelected:NO];
            [_beatRepeatButton setSelected:NO];
            break;
            
        case BMPlaybackMode_OneShot:
            [_loopButton setSelected:NO];
            [_oneShotButton setSelected:YES];
            [_beatRepeatButton setSelected:NO];
            break;
            
        case BMPlaybackMode_BeatRepeat:
            [_loopButton setSelected:NO];
            [_oneShotButton setSelected:NO];
            [_beatRepeatButton setSelected:YES];
            break;
            
        default:
            break;
    }
}

- (void)readAudioFileDirectories {
    
    NSArray* masterRecFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_masterRecordingsDirectory error:nil];
    _masterRecordings = nil;
    _masterRecordings = [[NSMutableArray alloc] init];
    for (NSString* filepath in masterRecFiles) {
        if ([[filepath pathExtension] isEqualToString:@"wav"]) {
            NSString* filename = [filepath lastPathComponent];
            [_masterRecordings addObject:[filename stringByDeletingPathExtension]];
        }
    }
    
    NSArray* tempMicRecFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_tempMicRecordingsDirectory error:nil];
    _tempMicRecordings = nil;
    _tempMicRecordings = [[NSMutableArray alloc] init];
    for (NSString* filepath in tempMicRecFiles) {
        if ([[filepath pathExtension] isEqualToString:@"wav"]) {
            NSString* filename = [filepath lastPathComponent];
            [_tempMicRecordings addObject:[filename stringByDeletingPathExtension]];
        }
    }
    
    NSArray* savedMicRecFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_savedMicRecordingsDirectory error:nil];
    _savedMicRecordings = nil;
    _savedMicRecordings = [[NSMutableArray alloc] init];
    for (NSString* filepath in savedMicRecFiles) {
        if ([[filepath pathExtension] isEqualToString:@"wav"]) {
            NSString* filename = [filepath lastPathComponent];
            [_savedMicRecordings addObject:[filename stringByDeletingPathExtension]];
        }
    }
}


- (void)deleteFileAtIndex:(NSIndexPath*)indexPath inLibrary:(BMLibrary)library {
    
    NSMutableArray* list;
    NSString* directory;
    
    switch (library) {
        case BMLibrary_MicRecordings:
            if (indexPath.section == BMMicLibrary_Temporary) {
                list = _tempMicRecordings;
                directory = _tempMicRecordingsDirectory;
            } else if (indexPath.section == BMMicLibrary_Saved) {
                list = _savedMicRecordings;
                directory = _savedMicRecordingsDirectory;
            }
            break;
        case BMLibrary_MasterRecordings:
            list = _masterRecordings;
            directory = _masterRecordingsDirectory;
            break;
        default:
            break;
    }
    
    NSString* filename = [NSString stringWithFormat:@"%@.wav", [list objectAtIndex:indexPath.row]];
    NSString* filepath = [directory stringByAppendingPathComponent:filename];
    if ([[NSFileManager defaultManager] removeItemAtPath:filepath error:nil]) {
        [list removeObjectAtIndex:indexPath.row];
    }
}

- (void)renameFileAtRow:(NSUInteger)row withName:(NSString*)name inLibrary:(BMLibrary)library {
    
    NSMutableArray* list;
    NSString* directory;
    
    switch (library) {
        case BMLibrary_MicRecordings:
            list = _savedMicRecordings;
            directory = _savedMicRecordingsDirectory;
            break;
        case BMLibrary_MasterRecordings:
            list = _masterRecordings;
            directory = _masterRecordingsDirectory;
            break;
        default:
            break;
    }
    
    NSString* oldFilename = [NSString stringWithFormat:@"%@.wav", (NSString*)[list objectAtIndex:row]];
    NSString* oldFilepath = [directory stringByAppendingPathComponent:oldFilename];
    NSString* newFilename = [NSString stringWithFormat:@"%@.wav", name];
    NSString* newFilepath = [directory stringByAppendingPathComponent:newFilename];
    if ([[NSFileManager defaultManager] moveItemAtPath:oldFilepath toPath:newFilepath error:nil]) {
        [list setObject:name atIndexedSubscript:row];
    }
    
    [_tableView reloadData];
}

- (void)saveTempMicRecordingAtRow:(NSUInteger)row withName:(NSString*)name {
    
    NSString* oldFilename = [NSString stringWithFormat:@"%@.wav", (NSString*)[_tempMicRecordings objectAtIndex:row]];
    NSString* oldFilepath = [_tempMicRecordingsDirectory stringByAppendingPathComponent:oldFilename];
    NSString* newFilename = [NSString stringWithFormat:@"%@.wav", name];
    NSString* newFilepath = [_savedMicRecordingsDirectory stringByAppendingPathComponent:newFilename];
    if ([[NSFileManager defaultManager] copyItemAtPath:oldFilepath toPath:newFilepath error:nil]) {
        [_savedMicRecordings addObject:name];
    }
    
    [_tableView reloadData];
}

- (void)launchOptionDialog:(NSString*)option at:(NSIndexPath*)indexPath forLibrary:(BMLibrary)library {
    
    NSArray* list = nil;
    
    switch (library) {
        case BMLibrary_MicRecordings:
            if (indexPath.section == BMMicLibrary_Temporary) {
                list = _tempMicRecordings;
            } else if (indexPath.section == BMMicLibrary_Saved) {
                list = _savedMicRecordings;
            }
            break;
        
        case BMLibrary_MasterRecordings:
            list = _masterRecordings;
            break;
            
        case BMLibrary_BuiltIn:
        default:
            break;
    }
    
    
    NSString* message = [list objectAtIndex:indexPath.row];
    
    UIAlertController* optionDialog = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ ?", option]
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* confirm = [UIAlertAction actionWithTitle:option
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        NSString* name = optionDialog.textFields.firstObject.text;
                                                        if ([self isExistingFilename:name inLibrary:library inSection:indexPath.section]) {
                                                            [self launchOverwriteConfirmation:option at:indexPath withName:name forLibrary:library];
                                                        } else {
                                                            if ([option isEqualToString:@"Rename"]) {
                                                                [self renameFileAtRow:indexPath.row withName:name inLibrary:library];
                                                            } else if ([option isEqualToString:@"Save"]) {
                                                                [self saveTempMicRecordingAtRow:indexPath.row withName:name];
                                                            }
                                                        }
                                                    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    
    
    [optionDialog addTextFieldWithConfigurationHandler:nil];
    [optionDialog addAction:confirm];
    [optionDialog addAction:cancel];
    [optionDialog setPreferredAction:confirm];
    
    [self presentViewController:optionDialog animated:YES completion:nil];
}


- (void)launchOverwriteConfirmation:(NSString*)option at:(NSIndexPath*)indexPath withName:(NSString*)name forLibrary:(BMLibrary)library {
    
    NSString* message = [NSString stringWithFormat:@"File '%@' already exists", name];
    
    UIAlertController* confirmDialog = [UIAlertController alertControllerWithTitle:@"Confirm Overwrite?"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* save = [UIAlertAction actionWithTitle:@"Confirm"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     if ([option isEqualToString:@"Rename"]) {
                                                         [self renameFileAtRow:indexPath.row withName:name inLibrary:library];
                                                     } else if ([option isEqualToString:@"Save"]) {
                                                         [self saveTempMicRecordingAtRow:indexPath.row withName:name];
                                                         
                                                     }
                                                 }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    
    [confirmDialog addAction:save];
    [confirmDialog addAction:cancel];
    [confirmDialog setPreferredAction:save];
    
    [self presentViewController:confirmDialog animated:YES completion:nil];
}


- (BOOL)isExistingFilename:(NSString*)filename inLibrary:(BMLibrary)library inSection:(NSInteger)section {
    
    NSString* directory;
    switch (library) {
        case BMLibrary_MicRecordings:
            if (section == BMMicLibrary_Saved) {
                directory = _savedMicRecordingsDirectory;
            } else if (section == BMMicLibrary_Temporary) {
                directory = _tempMicRecordingsDirectory;
            }
            break;
        case BMLibrary_MasterRecordings:
            directory = _masterRecordingsDirectory;
            break;
        default:
            break;
    }
    
    NSString* filepath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", filename]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        return YES;
    }
    
    return NO;
}


- (void)launchShareActionSheet:(NSIndexPath*)indexPath forLibrary:(BMLibrary)library {
    
    NSString* filepath = nil;
    NSString* filename = nil;
    
    switch (library) {
        case BMLibrary_MicRecordings:
            if (indexPath.section == BMMicLibrary_Saved) {
                filename = [(NSString*)[_savedMicRecordings objectAtIndex:indexPath.row] stringByAppendingString:@".wav"];
                filepath = [_savedMicRecordingsDirectory stringByAppendingPathComponent:filename];
            }
            break;
            
        case BMLibrary_MasterRecordings:
        {
            filename = [(NSString*)[_masterRecordings objectAtIndex:indexPath.row] stringByAppendingString:@".wav"];
            filepath = [_masterRecordingsDirectory stringByAppendingPathComponent:filename];
        }
            break;
            
        case BMLibrary_BuiltIn:
        default:
            break;
    }
    
    NSString* message = [NSString stringWithFormat:@"\"%@\"\n\nCreated using BeMotion for iOS", filename];
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
