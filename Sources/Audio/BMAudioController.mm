//
//  BMAudioController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMAudioController.h"

#import <AVFoundation/AVFoundation.h>

#import "JuceHeader.h"
#import "AudioController.h"
//#import "BMSequencer.h"
#import "BMConstants.h"

//static NSString* const kMicRecordingDirectory       = @"MicRecordings";
//static NSString* const kAudioSamplesDirectory       = @"AudioSamples";
//static NSString* const kSongRecordingsDirectory     = @"SongRecordings";

@interface BMAudioController()
{
    ScopedPointer<AudioController>      _audioController;
    
    NSString*                           _documentsDirectory;
    NSDictionary*                       _sampleSetDictionary;
    NSArray*                            _sampleSetTitles;
    
    NSMutableArray*                     _trackIndexPaths;
}
@end


@implementation BMAudioController

- (id)init {
    
    if (self = [super init]) {
        
        // Initialise JUCE Application
        initialiseJuce_GUI();
        
        // Initialise JUCE Audio Controller
        _audioController = new AudioController();
        
        
        // AVAudioSession Set Category
        NSError* error;
        if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]) {
            NSLog(@"%@",error.description);
        }
        
        
        // Setup Directory Structure
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [[NSString alloc] initWithString:(NSString*)[paths objectAtIndex:0]];
        
        
        // Get Sample Sets Dictionary
        NSString* samplesPath = [[NSBundle mainBundle] pathForResource:@"SampleSets" ofType:@"json"];
        NSData* samplesData = [NSData dataWithContentsOfFile:samplesPath options:NSDataReadingUncached error:nil];
        _sampleSetDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:samplesData options:kNilOptions error:nil];
        _sampleSetTitles = [[NSArray alloc] initWithArray:[_sampleSetDictionary allKeys]];
        
        
        // Setup Index Paths for Sample Sets
        _trackIndexPaths = [[NSMutableArray alloc] init];
        for(int i=0; i < kNumTracks; i++) {
            BMIndexPath* indexPath = [[BMIndexPath alloc] init];
            [_trackIndexPaths addObject:indexPath];
        }
        
        // Initialise Sequencer and Set Delegate
//        [BMSequencer sharedSequencer];
    }
    
    return self;
}

- (void)close {
    
    // Deallocate Audio Classes
    _audioController = nullptr;
    
    // Close JUCE Application
    shutdownJuce_GUI();
}

- (void)enterBackground {
    
}

- (void)enterForeground {
    
}


#pragma mark - Singleton

+ (instancetype)sharedController {
    static BMAudioController* sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BMAudioController alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Public Methods

//------------------------------------------------------------------------------------
// Files / Properties Utility Methods
//------------------------------------------------------------------------------------

- (NSArray*)getSampleSetTitles {
    return _sampleSetTitles;
}

- (NSArray*)getSamplesForTitle:(NSString *)title {
    NSDictionary* set = (NSDictionary*)[_sampleSetDictionary objectForKey:title];
    return (NSArray*)[set objectForKey:@"Samples"];
}

- (NSArray*)getSamplesForIndex:(NSInteger)index {
    NSString* title = (NSString*)[_sampleSetTitles objectAtIndex:index];
    NSDictionary* set = (NSDictionary*)[_sampleSetDictionary objectForKey:title];
    return (NSArray*)[set objectForKey:@"Samples"];
}

- (BMIndexPath*)getIndexPathForTrack:(int)track {
    return [_trackIndexPaths objectAtIndex:track];
}

//------------------------------------------------------------------------------------
// AudioController Class Methods
//------------------------------------------------------------------------------------

#pragma mark - Track Audio Methods

- (int)loadAudioFileIntoTrack:(int)track atIndexPath:(BMIndexPath*)indexPath {
    
    int returnValue;
    
    if (indexPath.library == 0) { // Default Sample Sets
        
        NSArray* samples = [self getSamplesForIndex:indexPath.section];
        NSString* title = (NSString*)[samples objectAtIndex:indexPath.index];
        
        // Load Audio File
        NSString* filepath = [[NSBundle mainBundle] pathForResource:title ofType:@"wav"];
        returnValue = [self loadAudioFileIntoTrack:track withPath:filepath];
    }
    
    // Store New Index Path
    BMIndexPath* currentPath = (BMIndexPath*)[_trackIndexPaths objectAtIndex:track];
    currentPath.library = indexPath.library;
    currentPath.section = indexPath.section;
    currentPath.index   = indexPath.index;
    
    return returnValue;
}

- (int)loadAudioFileIntoTrack:(int)track withPath:(NSString*)filepath {
    return _audioController->loadAudioFileIntoTrack([self fromNSString:filepath], track);
}

- (void)startPlaybackOfTrack:(int)track {
    _audioController->startPlaybackOfTrack(track);
}

- (void)stopPlaybackOfTrack:(int)track {
    _audioController->stopPlaybackOfTrack(track);
}

- (float)getNormalizedPlaybackProgress:(int)track {
    return _audioController->getNormalizedPlaybackProgress(track);
}

- (float)getTotalTime:(int)track {
    return _audioController->getTotalTimeOfTrack(track);
}

- (void)startRecordingAtTrack:(int)track {
    _audioController->startRecordingAtTrack(track);
}

- (void)stopRecordingAtTrack:(int)track {
    _audioController->stopRecordingAtTrack(track);
}

- (void)setGainOnTrack:(int)track withGain:(float)gain {
    _audioController->setTrackGain(track, gain);
}

- (float)getGainOnTrack:(int)track {
    return _audioController->getTrackGain(track);
}

- (void)setPanOnTrack:(int)track withPan:(float)pan {
    _audioController->setTrackPan(track, pan);
}

- (float)getPanOnTrack:(int)track {
    return _audioController->getTrackPan(track);
}

- (float*)getSamplesForWaveformAtTrack:(int)track {
    return _audioController->getSamplesForWaveformAtTrack(track);
}

#pragma mark - Audio Effect Methods

- (void)setEffectOnTrack:(int)track AtSlot:(int)slot withEffect:(int)effectID {
    _audioController->setEffect(track, slot, effectID);
}

- (int)getEffectOnTrack:(int)track AtSlot:(int)slot {
    return _audioController->getEffect(track, slot);
}

- (void)setEffectParameterOnTrack:(int)track AtSlot:(int)slot ForParameter:(int)parameterID withValue:(float)value {
    _audioController->setEffectParameter(track, slot, parameterID, value);
}

- (float)getEffectParameterOnTrack:(int)track AtSlot:(int)slot ForParameter:(int)parameterID {
    return _audioController->getEffectParameter(track, slot, parameterID);
}

- (void)setEffectEnableOnTrack:(int)track AtSlot:(int)slot WithValue:(BOOL)enable {
    _audioController->setEffectEnable(track, slot, enable);
}

- (BOOL)getEffectEnableOnTrack:(int)track AtSlot:(int)slot {
    return _audioController->getEffectEnable(track, slot);
}

#pragma mark - Master Audio Track Methods

- (void)startRecordingMaster {
    _audioController->startRecordingMaster();
}

- (void)stopRecordingMaster {
    _audioController->stopRecordingMaster();
}

- (BOOL)saveMasterRecordingAtFilepath:(NSString*)filepath {
    return _audioController->saveMasterRecording([self fromNSString:filepath]);
}



#pragma mark - Private Methods

- (juce::String)fromNSString:(NSString*)string {
    return juce::String(string.UTF8String);
}

- (NSString*)toNSString:(juce::String)string {
    return [NSString stringWithUTF8String:string.toUTF8()];
}

@end


//====================================================================================

@implementation BMIndexPath

- (id)init {
    
    if (self = [super init]) {
        
        _library = 0;
        _section = 0;
        _index   = 0;
    }
    
    return self;
}

@end
