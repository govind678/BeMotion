//
//  BMAudioController.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMAudioController.h"
#import "BMSequencer.h"
#import <AVFoundation/AVFoundation.h>

#import "JuceHeader.h"
#import "AudioController.h"
#import "BMMotionController.h"

//static NSString* const kMicRecordingDirectory       = @"MicRecordings";
//static NSString* const kAudioSamplesDirectory       = @"AudioSamples";
//static NSString* const kSongRecordingsDirectory     = @"SongRecordings";

@interface BMAudioController() <BMMotionControllerDelegate>
{
    ScopedPointer<AudioController>      _audioController;
    
    // File/Folder Paths
    NSString*                           _tempMasterRecordingFilepath;
    NSString*                           _savedMasterRecordingsDir;
    NSString*                           _savedMicRecordingsDir;
    NSString*                           _tempMicRecordingsDir;
    NSArray*                            _tempMicRecordingFilepathArray;
    
    NSDictionary*                       _sampleSetDictionary;
    NSArray*                            _sampleSetTitles;
    
    NSMutableArray*                     _currentTrackArray;
    
    NSMutableArray*                     _motionMapArray;
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
        
        
        // Check and create directories
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [[NSString alloc] initWithString:(NSString*)[paths objectAtIndex:0]];
        
        _savedMicRecordingsDir = [documentsDirectory stringByAppendingPathComponent:@"SavedMicRecordings"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_savedMicRecordingsDir isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_savedMicRecordingsDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _savedMasterRecordingsDir = [documentsDirectory stringByAppendingPathComponent:@"MasterRecordings"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_savedMasterRecordingsDir isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_savedMasterRecordingsDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString* tempDirectory = [[[NSFileManager defaultManager] temporaryDirectory] path];
        _tempMicRecordingsDir = [tempDirectory stringByAppendingPathComponent:@"TemporaryMicRecordings"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_tempMicRecordingsDir isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_tempMicRecordingsDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSMutableArray* tempMicRecordingPaths = [NSMutableArray array];
        for (int track=0; track < kNumButtonTracks; track++) {
            NSString* filename = [NSString stringWithFormat:@"Mic Recording at %d.wav", track+1];
            [tempMicRecordingPaths addObject:[_tempMicRecordingsDir stringByAppendingPathComponent:filename]];
        }
        _tempMicRecordingFilepathArray = [[NSArray alloc] initWithArray:tempMicRecordingPaths];
        
        _tempMasterRecordingFilepath = [tempDirectory stringByAppendingPathComponent:@"bm_tempMasterRecording.wav"];
        
        
        
        
        // Load Stock Sample Sets
        NSString* samplesPath = [[NSBundle mainBundle] pathForResource:@"SampleSetsList" ofType:@"plist"];
        _sampleSetDictionary = [[NSDictionary alloc] initWithContentsOfFile:samplesPath];
        _sampleSetTitles = [[NSArray alloc] initWithArray:[_sampleSetDictionary allKeys]];
        
        // Store Currently Loaded Track Name, Library and Index
        _currentTrackArray = [[NSMutableArray alloc] init];
        for (int track=0; track < kNumButtonTracks + kNumMotionTracks; track++) {
            NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
            dictionary[@"Library"] = @(BMLibrary_BuiltIn);
            dictionary[@"Name"] = @"<none>";
            dictionary[@"Section"] = @(BMMicLibrary_NotApplicable);
            [_currentTrackArray addObject:dictionary];
        }
        
        
        // Setup Motion Map Array
        _motionMapArray = [[NSMutableArray alloc] init];
        for (int track=0; track < kNumButtonTracks; track++) {
            NSMutableArray* trackArray = [NSMutableArray array];
            for (int effect=0; effect < kNumEffectsPerTrack; effect++) {
                NSMutableArray* effectArray = [NSMutableArray array];
                for (int param=0; param < kNumParametersPerEffect; param++) {
                    NSMutableDictionary* motionDictionary = [[NSMutableDictionary alloc] init];
                    motionDictionary[@"Map"] = @(BMMotionMode_None);
                    motionDictionary[@"Min"] = @(0.0f);
                    motionDictionary[@"Max"] = @(1.0f);
                    [effectArray addObject:motionDictionary];
                }
                [trackArray addObject:effectArray];
            }
            [_motionMapArray addObject:trackArray];
        }
        
        
        // Initialise Sequencer
        [BMSequencer sharedSequencer];
        
        
        // Initialize Motion Controller
        [[BMMotionController sharedController] setMotionDelegate:self];
        [[BMMotionController sharedController] start];
        
        _delegate = nil;
    }
    
    return self;
}

- (void)close {
    
    // Deallocate Audio Classes
    _audioController = nullptr;
    
    // Close JUCE Application
    shutdownJuce_GUI();
}

- (void)stop {
    
    [[BMMotionController sharedController] stop];
    [[BMSequencer sharedSequencer] stopClock];

    for (int i=0; i < kNumButtonTracks + kNumMotionTracks; i++) {
        _audioController->stopPlaybackOfTrack(i);
        if (i < kNumButtonTracks) {
            _audioController->stopRecordingAtTrack(i);
        }
    }

    _audioController->closeSession();
}

- (void)restart {
    _audioController->openSession();
    [[BMMotionController sharedController] start];
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

- (NSArray*)getListOfSampleTitles {
    return _sampleSetTitles;
}

- (NSArray*)getAllSamplesForTitle:(NSString *)title {
    NSDictionary* set = (NSDictionary*)[_sampleSetDictionary objectForKey:title];
    return (NSArray*)[set objectForKey:@"Samples"];
}

- (NSDictionary*)getTimeDictionaryForTitle:(NSString *)title {
    NSDictionary* set = [_sampleSetDictionary objectForKey:title];
    return (NSDictionary*)[set objectForKey:@"Time"];
}

- (BMLibrary)getAudioFileLibraryOnTrack:(int)track {
    return (BMLibrary)[_currentTrackArray[track][@"Library"] intValue];
}

- (BMMicLibrary)getAudioFileSectionOnTrack:(int)track {
    return (BMMicLibrary)[_currentTrackArray[track][@"Section"] intValue];
}

- (NSString*)getAudioFileNameOnTrack:(int)track {
    return (NSString*)_currentTrackArray[track][@"Name"];
}

- (void)saveTempMicRecordingAtTrack:(int)track withName:(NSString*)filename {
    NSString* fromFilepath = _tempMicRecordingFilepathArray[track];
    NSString* toFilepath = [[_savedMicRecordingsDir stringByAppendingPathComponent:filename] stringByAppendingPathExtension:@"wav"];
    if ([[NSFileManager defaultManager] copyItemAtPath:fromFilepath toPath:toFilepath error:nil]) {
        _currentTrackArray[track][@"Name"] = filename;
        _currentTrackArray[track][@"Section"] = @(BMMicLibrary_Saved);
        _currentTrackArray[track][@"Library"] = @(BMLibrary_MicRecordings);
    }
}

- (NSString*)getTempMicRecordingDirectory {
    return _tempMicRecordingsDir;
}


//------------------------------------------------------------------------------------
// AudioController Class Methods
//------------------------------------------------------------------------------------

#pragma mark - Track Audio Methods

- (BOOL)loadAudioFileIntoTrack:(int)track fromLibrary:(BMLibrary)library withName:(NSString*)name optionalSection:(BMMicLibrary)section {
    
    NSString* filepath;
    BOOL success = NO;
    
    switch (library) {
        case BMLibrary_BuiltIn:
            filepath = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
            break;
            
        case BMLibrary_MicRecordings:
            if (section == BMMicLibrary_Temporary) {
                filepath = [_tempMicRecordingsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.wav", name]];
            } else if (section == BMMicLibrary_Saved) {
                filepath = [_savedMicRecordingsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.wav", name]];
            }
            break;
            
        case BMLibrary_MasterRecordings:
            filepath = [_savedMasterRecordingsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.wav", name]];
            break;
            
        default:
            break;
    }
    
    
    if ([[NSFileManager defaultManager] isReadableFileAtPath:filepath]) {
       success = [self loadAudioFileIntoTrack:track withPath:filepath];
    } else {
        NSLog(@"LoadAudioFileIntoTrack: Error! File not readable!");
    }
    
    if (success) {
        [_currentTrackArray[track] setObject:@(library) forKey:@"Library"];
        [_currentTrackArray[track] setObject:name forKey:@"Name"];
        [_currentTrackArray[track] setObject:@(section) forKey:@"Section"];
        
        if (_delegate && [_delegate respondsToSelector:@selector(didFinishLoadingAudioFileAtTrack:)]) {
            [_delegate didFinishLoadingAudioFileAtTrack:track];
        }
    } else {
        NSLog(@"Error LoadAudioFileIntoTrack %d with: %@", track, filepath);
    }
    
    return success;
}

- (void)startPlaybackOfTrack:(int)track {
    _audioController->startPlaybackOfTrack(track);
}

- (void)stopPlaybackOfTrack:(int)track {
    _audioController->stopPlaybackOfTrack(track);
}

- (BOOL)isTrackPlaying:(int)track {
    return _audioController->isTrackPlaying(track);
}

- (float)getNormalizedPlaybackProgress:(int)track {
    return _audioController->getNormalizedPlaybackProgress(track);
}

- (float)getTotalTime:(int)track {
    return _audioController->getTotalTimeOfTrack(track);
}

- (void)startRecordingAtTrack:(int)track {
    NSString* filepath = _tempMicRecordingFilepathArray[track];
    _audioController->startRecordingAtTrack(track, [self fromNSString:filepath]);
}

- (void)stopRecordingAtTrack:(int)track {
    _audioController->stopRecordingAtTrack(track);
    NSString* filename = [[(NSString*)_tempMicRecordingFilepathArray[track] lastPathComponent] stringByDeletingPathExtension];
    [self loadAudioFileIntoTrack:track fromLibrary:BMLibrary_MicRecordings withName:filename optionalSection:BMMicLibrary_Temporary];
}

- (BOOL)isTrackRecording:(int)track {
    return _audioController->isTrackRecording(track);
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

- (void)setPlaybackModeOnTrack:(int)track withMode:(BMPlaybackMode)mode {
    _audioController->setPlaybackModeOfTrack(track, mode);
}

- (int)getPlaybackModeOnTrack:(int)track {
    return _audioController->getPlaybackModeOfTrack(track);
}

- (const float*)getSamplesForWaveformAtTrack:(int)track {
    return _audioController->getSamplesForWaveformAtTrack(track);
}

#pragma mark - Audio Effect Methods

- (void)setEffectOnTrack:(int)track AtSlot:(int)slot withEffect:(int)effectID {
    _audioController->setEffect(track, slot, effectID);
    _audioController->setTempo([[BMSequencer sharedSequencer] tempo]);
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

- (void)setTempo:(float)tempo {
    _audioController->setTempo(tempo);
}

- (void)setShouldQuantizeTimeOnTrack:(int)track AtSlot:(int)slot WithValue:(BOOL)value {
    _audioController->setShouldQuantizeTime(track, slot, value);
}


#pragma mark - Audio Effect Motion Control Methods

- (void)setMotionMapOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID withMap:(int)motionMap {
    _motionMapArray[track][slot][parameterID][@"Map"] = @(motionMap);
}

- (void)setMotionMinOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID withValue:(float)value {
    _motionMapArray[track][slot][parameterID][@"Min"] = @(value);
}

- (void)setMotionMaxOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID withValue:(float)value {
    _motionMapArray[track][slot][parameterID][@"Max"] = @(value);
}


- (int)getMotionMapOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID {
    return [_motionMapArray[track][slot][parameterID][@"Map"] intValue];
}

- (float)getMotionMinOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID {
    return [_motionMapArray[track][slot][parameterID][@"Min"] floatValue];
}

- (float)getMotionMaxOnTrack:(int)track AtEffectSlot:(int)slot ForParameter:(int)parameterID {
    return [_motionMapArray[track][slot][parameterID][@"Max"] floatValue];
}

- (void)debugPrint {
    for (int track = 0; track < kNumButtonTracks; track++) {
        for (int effect = 0; effect < kNumEffectsPerTrack; effect++) {
            NSLog(@"Track %d. Effect %d. (P0: %d, %.2f, %.2f), (P1: %d, %.2f, %.2f), (P2: %d, %.2f, %.2f)",
                  track, effect,
                  [_motionMapArray[track][effect][0][0] intValue], [_motionMapArray[track][effect][0][1] floatValue], [_motionMapArray[track][effect][0][2] floatValue],
                  [_motionMapArray[track][effect][1][0] intValue], [_motionMapArray[track][effect][1][1] floatValue], [_motionMapArray[track][effect][1][2] floatValue],
                  [_motionMapArray[track][effect][2][0] intValue], [_motionMapArray[track][effect][2][1] floatValue], [_motionMapArray[track][effect][2][2] floatValue]);
        }
    }
}


#pragma mark - Master Audio Track Methods

- (void)startRecordingMaster {
    _audioController->startRecordingMaster([self fromNSString:_tempMasterRecordingFilepath]);
}

- (void)stopRecordingMaster {
    _audioController->stopRecordingMaster();
}

- (BOOL)saveMasterRecordingAtFilepath:(NSString*)filepath {
    return [[NSFileManager defaultManager] copyItemAtPath:_tempMasterRecordingFilepath toPath:filepath error:nil];
}


#pragma mark - Motion Control Delegate

//- (void)attitudeUpdate:(float)pitch :(float)roll :(float)yaw {
//    for (int track = 0; track < kNumButtonTracks; track++) {
//        for (int effect = 0; effect < kNumEffectsPerTrack; effect++) {
//            for (int param = 0; param < kNumParametersPerEffect; param++) {
//                int motionMap = [_motionMapArray[track][effect][param][@"Map"] intValue];
//                if (motionMap > 0) {
//                    float lowRange = [_motionMapArray[track][effect][param][@"Min"] floatValue];
//                    float highRange = [_motionMapArray[track][effect][param][@"Max"] floatValue];
//                    float value = 0.0f;
//                    switch (motionMap) {
//                        case BMMotionMode_Pitch:
//                            value = pitch;
//                            break;
//                        case BMMotionMode_Roll:
//                            value = roll;
//                            break;
//                        case BMMotionMode_Yaw:
//                            value = yaw;
//                            break;
//                        default:
//                            break;
//                    }
//                    value = (value * (highRange - lowRange)) + lowRange;
//                    [self setEffectParameterOnTrack:track AtSlot:effect ForParameter:param withValue:value];
//                }
//            }
//        }
//    }
//}

- (void)attitudeUpdate:(float *)attitude {
    
    for (int track = 0; track < kNumButtonTracks; track++) {
        for (int effect = 0; effect < kNumEffectsPerTrack; effect++) {
            for (int param = 0; param < kNumParametersPerEffect; param++) {
                int motionMap = [_motionMapArray[track][effect][param][@"Map"] intValue];
                if (motionMap > 0) {
                    float lowRange = [_motionMapArray[track][effect][param][@"Min"] floatValue];
                    float highRange = [_motionMapArray[track][effect][param][@"Max"] floatValue];
                    float value = (attitude[motionMap] * (highRange - lowRange)) + lowRange;
                    [self setEffectParameterOnTrack:track AtSlot:effect ForParameter:param withValue:value];
                }
            }
        }
    }
}

- (void)xDirectionTrigger:(int)direction {
    _audioController->startPlaybackOfTrack(direction + kNumButtonTracks - 1);
}


#pragma mark - Private Methods

- (BOOL)loadAudioFileIntoTrack:(int)track withPath:(NSString*)filepath {
    return _audioController->loadAudioFileIntoTrack([self fromNSString:filepath], track);
}

- (juce::String)fromNSString:(NSString*)string {
    return juce::String(string.UTF8String);
}

- (NSString*)toNSString:(juce::String)string {
    return [NSString stringWithUTF8String:string.toUTF8()];
}

@end

