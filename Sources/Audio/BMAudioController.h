//
//  BMAudioController.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>


//====================================================================================

@interface BMIndexPath : NSObject

/* Library 0-> Local, 1-> User Recordings */
@property (nonatomic, assign) NSInteger library;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger index;

@end


//====================================================================================

@interface BMAudioController : NSObject

//--------------------------------------------------------------
// Initialization Methods
//--------------------------------------------------------------

/* Returns shared, single instance of the audio controller */
+ (instancetype)sharedController;

/* Destructor */
- (void)close;

/* Enter Background */
- (void)enterBackground;

/* Enter Foreground from Background */
- (void)enterForeground;



//---------------------------------------------------------------
// Files / Properties Utility Methods
//---------------------------------------------------------------

/* Get List of Available Sample Sets */
- (NSArray*)getSampleSetTitles;

/* Get All Sample Names By Title */
- (NSArray*)getSamplesForTitle:(NSString*)title;

/* Get All Sample Names At Index */
- (NSArray*)getSamplesForIndex:(NSInteger)index;

/* Load Audio File Using Index Path, from Tables */
- (BMIndexPath*)getIndexPathForTrack:(int)track;


//----------------------------------------------------------------
// AudioController Class Methods
//----------------------------------------------------------------

/* Audio Track Methods */
- (int)loadAudioFileIntoTrack:(int)track atIndexPath:(BMIndexPath*)indexPath;
- (int)loadAudioFileIntoTrack:(int)track withPath:(NSString*)filepath;
- (void)startPlaybackOfTrack:(int)track;
- (void)stopPlaybackOfTrack:(int)track;
- (float)getNormalizedPlaybackProgress:(int)track;
- (void)startRecordingAtTrack:(int)track;
- (void)stopRecordingAtTrack:(int)track;
- (void)setGainOnTrack:(int)track withGain:(float)gain;
- (float)getGainOnTrack:(int)track;
- (void)setPanOnTrack:(int)track withPan:(float)pan;
- (float)getPanOnTrack:(int)track;
- (float*)getSamplesForWaveformAtTrack:(int)track;

/* Audio Effect Methods */
- (void)setEffectOnTrack:(int)track AtSlot:(int)slot withEffect:(int)effectID;
- (int)getEffectOnTrack:(int)track AtSlot:(int)slot;
- (void)setEffectParameterOnTrack:(int)track AtSlot:(int)slot ForParameter:(int)parameterID withValue:(float)value;
- (float)getEffectParameterOnTrack:(int)track AtSlot:(int)slot ForParameter:(int)parameterID;
- (void)setEffectEnableOnTrack:(int)track AtSlot:(int)slot WithValue:(BOOL)enable;
- (BOOL) getEffectEnableOnTrack:(int)track AtSlot:(int)slot;

/* Audio Master Track Methods */
- (void)startRecordingMaster;
- (void)stopRecordingMaster;
- (BOOL)saveMasterRecordingAtFilepath:(NSString*)filepath;

@end
