//
//  BMLoadFileView.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 11/17/17.
//  Copyright © 2017 Plasmatio Tech. All rights reserved.
//

#import "BMLoadFileView.h"
#import "UIFont+Additions.h"
#import "UIColor+Additions.h"
#import "BMAudioController.h"
#import "BMConstants.h"

static const float kButtonHeight        = 44.0f;
static const float kYGap                = 14.0f;

@interface BMLoadFileView () <UITableViewDataSource, UITableViewDelegate>
{
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



@implementation BMLoadFileView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        float yPos = 0.0f;
        
        NSDictionary* attribute = [NSDictionary dictionaryWithObject:[UIFont semiboldDefaultFontOfSize:12.0f] forKey:NSFontAttributeName];
        NSArray* segments = [NSArray arrayWithObjects:@"Stock", @"Mic", @"Song", nil];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
        [_segmentedControl setFrame:CGRectMake(0.0f, yPos, self.frame.size.width, 29.0f)];
        [_segmentedControl setTitleTextAttributes:attribute forState:UIControlStateNormal];
        [_segmentedControl setTintColor:[UIColor darkGrayColor]];
        [_segmentedControl setSelectedSegmentIndex:0];
        [_segmentedControl setTintColor:_foregroundColor];
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentedControl];
        
        // Samples Table
        yPos += _segmentedControl.frame.size.height + kYGap;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, yPos, self.frame.size.width, self.frame.size.height - yPos) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setScrollEnabled:YES];
        [_tableView setRowHeight:kButtonHeight];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self addSubview:_tableView];
        
        
        
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
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewWillAppear {
    [self readAudioFileDirectories];
    [_segmentedControl setSelectedSegmentIndex:(NSInteger)_currentLibrary];
}

- (void)setTrackID:(int)trackID {
    _trackID = trackID;
    _foregroundColor = (UIColor*)[[UIColor trackColors] objectAtIndex:trackID];
    [_segmentedControl setTintColor:_foregroundColor];
    [_tableView reloadData];
}


#pragma mark - UI Action Methods

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
            return kNumButtonTracks + kNumMotionTracks;
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
    return kButtonHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"LoadFileCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setIndentationLevel:1];
        [[cell textLabel] setTextColor:_foregroundColor];
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
    [delete setBackgroundColor:[UIColor colorWithRed:0.8f green:0.0f blue:0.0f alpha:0.5f]];
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



#pragma mark - Private

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
    
    
    [optionDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setClearButtonMode:UITextFieldViewModeAlways];
    }];
    [optionDialog addAction:confirm];
    [optionDialog addAction:cancel];
    [optionDialog setPreferredAction:confirm];
    
    if (_delegate && [_delegate respondsToSelector:@selector(launchAlertViewController:)]) {
        [_delegate launchAlertViewController:optionDialog];
    }
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(launchAlertViewController:)]) {
        [_delegate launchAlertViewController:confirmDialog];
    }
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
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(launchAlertViewController:)]) {
        [_delegate launchAlertViewController:controller];
    }
}

@end
