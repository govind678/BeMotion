//
//  BMAudioController.h
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMConstants.h"

@protocol BMAudioControllerDelegate <NSObject>
- (void)didFinishLoadingAudioFileAtTrack:(int)track;
- (void)didReachEndOfPlayback:(int)track;
@end


@interface BMAudioController : NSObject

//--------------------------------------------------------------
// Initialization Methods
//--------------------------------------------------------------

/* Returns shared, single instance of the audio controller */
+ (instancetype)sharedController;

/* Destructor */
- (void)close;

/* Stop: stops playback, recording, sequencer, audio I/O and motion controller */
- (void)stop;

/* Restart: audio I/O and motion controller */
- (void)restart;


//---------------------------------------------------------------
// Files / Properties Utility Methods
//---------------------------------------------------------------

/* Get List of Available Sample Sets */
- (NSArray*)getListOfSampleTitles;

/* Get All Sample Names By Title */
- (NSArray*)getAllSamplesForTitle:(NSString*)title;

/* Get Time Dictionary for Title */
- (NSDictionary*)getTimeDictionaryForTitle:(NSString*)title;

/* Get currently loaded audio file name and library */
- (BMLibrary)getAudioFileLibraryOnTrack:(int)track;
- (BMMicLibrary)getAudioFileSectionOnTrack:(int)track;
- (NSString*)getAudioFileNameOnTrack:(int)track;
- (void)saveTempMicRecordingAtTrack:(int)track withName:(NSString*)filename;
- (NSString*)getTempMicRecordingDirectory;


//----------------------------------------------------------------
// AudioController Class Methods
//----------------------------------------------------------------

/* Audio Track Methods */
- (BOOL)loadAudioFileIntoTrack:(int)track fromLibrary:(BMLibrary)library withName:(NSString*)name optionalSection:(BMMicLibrary)section;
- (void)startPlaybackOfTrack:(int)track;
- (void)stopPlaybackOfTrack:(int)track;
- (BOOL)isTrackPlaying:(int)track;
- (float)getNormalizedPlaybackProgress:(int)track;
- (float)getTotalTime:(int)track;
- (void)startRecordingAtTrack:(int)track;
- (void)stopRecordingAtTrack:(int)track;
- (BOOL)isTrackRecording:(int)track;
- (void)setGainOnTrack:(int)track withGain:(float)gain;
- (float)getGainOnTrack:(int)track;
- (void)setPanOnTrack:(int)track withPan:(float)pan;
- (float)getPanOnTrack:(int)track;
- (void)setPlaybackModeOnTrack:(int)track withMode:(BMPlaybackMode)mode;
- (int)getPlaybackModeOnTrack:(int)track;
- (const float*)getSamplesForWaveformAtTrack:(int)track;

/* Audio Effect Methods */
- (void)setEffectOnTrack:(int)track AtSlot:(int)slot withEffect:(int)effectID;
- (int)getEffectOnTrack:(int)track AtSlot:(int)slot;
- (void)setEffectParameterOnTrack:(int)track AtSlot:(int)slot ForParameter:(int)parameterID withValue:(float)value;
- (float)getEffectParameterOnTrack:(int)track AtSlot:(int)slot ForParameter:(int)parameterID;
- (void)setEffectEnableOnTrack:(int)track AtSlot:(int)slot WithValue:(BOOL)enable;
- (BOOL) getEffectEnableOnTrack:(int)track AtSlot:(int)slot;
- (void)setTempo:(float)tempo;
- (void)setShouldQuantizeTimeOnTrack:(int)track AtSlot:(int)slot WithValue:(BOOL)value;

/* Audio Effect Motion Control Methods */
- (void)setMotionMapOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID withMap:(int)motionMap;
- (int)getMotionMapOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID;
- (void)setMotionMinOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID withValue:(float)value;
- (void)setMotionMaxOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID withValue:(float)value;
- (float)getMotionMinOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID;
- (float)getMotionMaxOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID;

/* Audio Master Track Methods */
- (void)startRecordingMaster;
- (void)stopRecordingMaster;
- (BOOL)saveMasterRecordingAtFilepath:(NSString*)filepath;

- (void)debugPrint;

@property (nonatomic, weak) id <BMAudioControllerDelegate> delegate;

@end
