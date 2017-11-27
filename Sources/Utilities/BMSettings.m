//
//  BMSettings.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/14/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMSettings.h"
#import "BMConstants.h"
#import "BMAudioController.h"
#import "BMSequencer.h"
#import "BMMotionController.h"

static NSString* const kRanOnceKey              = @"settings.ranOnce";
static NSString* const kProjectKey              = @"settings.dictionary";
static NSString* const kDrawWaveformKey         = @"settings.drawWaveform";
static NSString* const kXTriggerThresholdKey    = @"settings.xTriggerThreshold";

static NSString* const kDefaultProjectFile      = @"Default";

@interface BMSettings()
{
    NSMutableArray*          _savedProjectsList;
}
@end


@implementation BMSettings

#pragma mark - Init

- (id)init {
    
    if ((self = [super init])) {
        
        // Create projects directory - and install bundled project plists.
        NSError* error;
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        _projectsDirectory = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"Projects"]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_projectsDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_projectsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
            if (error) {
                NSLog(@"Settings Init: Error! creating projectsDirectory: %@", error.description);
            }
        }
        if (!error) {
            [self installProjectsFromBundle];
        }
        
        
        // Read User Defaults
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        _ranOnce = [defaults boolForKey:kRanOnceKey];
        _shouldDrawWaveform = [defaults boolForKey:kDrawWaveformKey];
        
        if (!_ranOnce) {
            [self loadDefaultProject];
            _ranOnce = YES;
        } else {
            NSDictionary* dictionary = [defaults dictionaryForKey:kProjectKey];
            if (dictionary == nil) {
                [self loadDefaultProject];
            } else {
                [self loadSettingsFromDictionary:dictionary];
            }
            [[BMMotionController sharedController] setXTriggerThreshold:[defaults floatForKey:kXTriggerThresholdKey]];
        }
        
        [self updateSavedProjectsList];
    }
    
    return self;
}


#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static BMSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[BMSettings alloc] init];
    });
    
    return sharedSettings;
}

- (void)saveToUserDefaults {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_ranOnce] forKey:kRanOnceKey];
    [defaults setObject:[self getSettingsAsDictionary] forKey:kProjectKey];
    [defaults setObject:[NSNumber numberWithBool:_shouldDrawWaveform] forKey:kDrawWaveformKey];
    [defaults setObject:[NSNumber numberWithFloat:[[BMMotionController sharedController] xTriggerThreshold]] forKey:kXTriggerThresholdKey];
    [defaults synchronize];
}


#pragma mark - Project Interface methods

- (BOOL)saveProjectWithName:(NSString*)projectName {
    NSString* filepath = [_projectsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", projectName]];
    _projectName = projectName;
    BOOL success = [[self getSettingsAsDictionary] writeToFile:filepath atomically:YES];
    [self updateSavedProjectsList];
    return success;
}


- (BOOL)loadProjectAtIndex:(NSInteger)index {
    NSString* projectName = [NSString stringWithFormat:@"%@.plist", (NSString*)[_savedProjectsList objectAtIndex:index]];
    NSString* projectPath = [_projectsDirectory stringByAppendingPathComponent:projectName];
    return [self readDictionaryFromFilepathAndLoadSettings:projectPath];
}

- (void)deleteProjectAtIndex:(NSInteger)index {
    NSString* projectName = [NSString stringWithFormat:@"%@.plist", (NSString*)[_savedProjectsList objectAtIndex:index]];
    NSString* projectPath = [_projectsDirectory stringByAppendingPathComponent:projectName];
    if ([[NSFileManager defaultManager] removeItemAtPath:projectPath error:nil]) {
        [_savedProjectsList removeObjectAtIndex:index];
    }
}

- (void)renameProjectAtIndex:(NSInteger)index with:(NSString*)newTitle {
    NSString* oldProjectName = [NSString stringWithFormat:@"%@.plist", (NSString*)[_savedProjectsList objectAtIndex:index]];
    NSString* oldProjectPath = [_projectsDirectory stringByAppendingPathComponent:oldProjectName];
    NSString* newProjectName = [NSString stringWithFormat:@"%@.plist", newTitle];
    NSString* newProjectPath = [_projectsDirectory stringByAppendingPathComponent:newProjectName];
    if ([[NSFileManager defaultManager] moveItemAtPath:oldProjectPath toPath:newProjectPath error:nil]) {
        [_savedProjectsList setObject:newTitle atIndexedSubscript:index];
    }
}

- (NSArray*)getListOfSavedProjects {
    return _savedProjectsList;
}

#pragma mark - Project Utility Methods

- (void)loadDefaultProject {
    NSString* defaultProjectPath = [[NSBundle mainBundle] pathForResource:kDefaultProjectFile ofType:@"plist"];
    [self readDictionaryFromFilepathAndLoadSettings:defaultProjectPath];
}

- (BOOL)readDictionaryFromFilepathAndLoadSettings:(NSString*)filepath {
    NSDictionary* dictionary = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        dictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
        [self loadSettingsFromDictionary:dictionary];
        return YES;
    }
    return NO;
}


- (void)loadSettingsFromDictionary:(NSDictionary*)dictionary {
    
    // Stop audio controller
    [[BMAudioController sharedController] stop];
    
    // Project Name
    _projectName = [dictionary objectForKey:@"Project"];
    
    // Tracks
    NSArray* tracks = [dictionary objectForKey:@"Tracks"];
    
    for (int i=0; i < kNumButtonTracks; i++) {
        
        NSDictionary* track = (NSDictionary*)[tracks objectAtIndex:i];
        
        NSString* name = [track objectForKey:@"Name"];
        BMLibrary library = [[track objectForKey:@"Library"] intValue];
        BMMicLibrary micLibrary = (library == BMLibrary_MicRecordings) ? BMMicLibrary_Saved : BMMicLibrary_NotApplicable;
        if (![[BMAudioController sharedController] loadAudioFileIntoTrack:i fromLibrary:library withName:name optionalSection:micLibrary]) {
            NSLog(@"LoadProject: Error loading audio file: %@, from library: %d", name, library);
        }
        
        float level = [[track objectForKey:@"Level"] floatValue];
        float pan = [[track objectForKey:@"Pan"] floatValue];
        int mode = [[track objectForKey:@"Mode"] intValue];
//        int quantization = [[track objectForKey:@"Quantization"] intValue];
        [[BMAudioController sharedController] setGainOnTrack:i withGain:level];
        [[BMAudioController sharedController] setPanOnTrack:i withPan:pan];
        [[BMAudioController sharedController] setPlaybackModeOnTrack:i withMode:mode];
        
        
        NSArray* effects = (NSArray*)[track objectForKey:@"Effects"];
        
        for (int j=0; j < kNumEffectsPerTrack; j++) {
            
            NSDictionary* effect = (NSDictionary*)[effects objectAtIndex:j];
            
            int effectID = [[effect objectForKey:@"EffectID"] intValue];
            BOOL enable = [[effect objectForKey:@"Enable"] boolValue];
            
            [[BMAudioController sharedController] setEffectOnTrack:i AtSlot:j withEffect:effectID];
            [[BMAudioController sharedController] setEffectEnableOnTrack:i AtSlot:j WithValue:enable];
            
            NSArray* parameters = (NSArray*)[effect objectForKey:@"Parameters"];
            
            for (int k=0; k < kNumParametersPerEffect; k++) {
                
                NSDictionary* parameter = (NSDictionary*)[parameters objectAtIndex:k];
                
                float value = [[parameter objectForKey:@"Value"] floatValue];
                [[BMAudioController sharedController] setEffectParameterOnTrack:i AtSlot:j ForParameter:k withValue:value];
                
                NSDictionary* motion = (NSDictionary*)[parameter objectForKey:@"Motion"];
                int map = [[motion objectForKey:@"Map"] intValue];
                float min = [[motion objectForKey:@"Min"] floatValue];
                float max = [[motion objectForKey:@"Max"] floatValue];
                
                [[BMAudioController sharedController] setMotionMapOnTrack:i AtEffectSlot:j ForParameter:k withMap:map];
                [[BMAudioController sharedController] setMotionMinOnTrack:i AtEffectSlot:j ForParameter:k withValue:min];
                [[BMAudioController sharedController] setMotionMaxOnTrack:i AtEffectSlot:j ForParameter:k withValue:max];
            }
        }
    }
    
    for (int i=kNumButtonTracks; i < kNumButtonTracks + kNumMotionTracks; i++) {
        NSDictionary* track = (NSDictionary*)[tracks objectAtIndex:i];
        NSString* name = [track objectForKey:@"Name"];
        if (![[BMAudioController sharedController] loadAudioFileIntoTrack:i fromLibrary:BMLibrary_BuiltIn withName:name optionalSection:BMMicLibrary_NotApplicable]) {
            NSLog(@"LoadProject: Error loading audio file: %@, from library: %d", name, 0);
        }
//        [[BMAudioController sharedController] setGainOnTrack:i withGain:0.5f];
    }
    
    
    // Time
    NSDictionary* time = [dictionary objectForKey:@"Time"];
    float tempo = [[time objectForKey:@"Tempo"] floatValue];
    int meter = [[time objectForKey:@"Meter"] intValue];
    int interval = [[time objectForKey:@"Interval"] intValue];
    
    [[BMSequencer sharedSequencer] setTempo:tempo];
    [[BMSequencer sharedSequencer] setMeter:meter];
    [[BMSequencer sharedSequencer] setInterval:interval];
    
    // Restart audio controller
    [[BMAudioController sharedController] restart];
}


- (NSDictionary*)getSettingsAsDictionary {
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    @synchronized(self) {
        
        // Name
        dictionary[@"Project"] = _projectName;
        
        // Time
        NSMutableDictionary* time = [[NSMutableDictionary alloc] init];
        time[@"Tempo"] = @([[BMSequencer sharedSequencer] tempo]);
        time[@"Meter"] = @([[BMSequencer sharedSequencer] meter]);
        time[@"Interval"] = @([[BMSequencer sharedSequencer] interval]);
        dictionary[@"Time"] = time;

        // Tracks
        NSMutableArray* tracks = [[NSMutableArray alloc] init];
        
        for (int i=0; i < kNumButtonTracks; i++) {
            
            NSMutableDictionary* track = [[NSMutableDictionary alloc] init];
            
            BMLibrary library = [[BMAudioController sharedController] getAudioFileLibraryOnTrack:i];
            
            if (library == BMLibrary_MicRecordings) {
                BMMicLibrary micLibrary = [[BMAudioController sharedController] getAudioFileSectionOnTrack:i];
                if (micLibrary == BMMicLibrary_Temporary) {
                    NSString* filename = [NSString stringWithFormat:@"%@ - Mic - %d", _projectName, i+1];
                    [[BMAudioController sharedController] saveTempMicRecordingAtTrack:i withName:filename];
                }
            }
            
            track[@"Name"] = [[BMAudioController sharedController] getAudioFileNameOnTrack:i];
            track[@"Library"] = @([[BMAudioController sharedController] getAudioFileLibraryOnTrack:i]);
            track[@"Level"] = @([[BMAudioController sharedController] getGainOnTrack:i]);
            track[@"Pan"] = @([[BMAudioController sharedController] getPanOnTrack:i]);
            track[@"Mode"] = @([[BMAudioController sharedController] getPlaybackModeOnTrack:i]);
//            track[@"Quantization"] = @([[BMAudioController sharedController] getQuantizationOnTrack:i]);

            NSMutableArray* effects = [[NSMutableArray alloc] init];
            for (int j=0; j < kNumEffectsPerTrack; j++) {
                
                NSMutableDictionary* effect = [[NSMutableDictionary alloc] init];
                
                effect[@"EffectID"] = @([[BMAudioController sharedController] getEffectOnTrack:i AtSlot:j]);
                effect[@"Enable"] = @([[BMAudioController sharedController] getEffectEnableOnTrack:i AtSlot:j]);
                
                NSMutableArray* parameters = [[NSMutableArray alloc] init];
                for (int k=0; k < kNumParametersPerEffect; k++) {

                    NSMutableDictionary* parameter = [[NSMutableDictionary alloc] init];
                    
                    parameter[@"Value"] = @([[BMAudioController sharedController] getEffectParameterOnTrack:i AtSlot:j ForParameter:k]);
                    
                    NSMutableDictionary* motion = [[NSMutableDictionary alloc] init];
                    motion[@"Map"] = @([[BMAudioController sharedController] getMotionMapOnTrack:i AtEffectSlot:j ForParameter:k]);
                    motion[@"Min"] = @([[BMAudioController sharedController] getMotionMinOnTrack:i AtEffectSlot:j ForParameter:k]);
                    motion[@"Max"] = @([[BMAudioController sharedController] getMotionMaxOnTrack:i AtEffectSlot:j ForParameter:k]);
        
                    parameter[@"Motion"] = motion;
                    
                    [parameters addObject:parameter];
                }
                effect[@"Parameters"] = parameters;
                
                [effects addObject:effect];
            }
            track[@"Effects"] = effects;
            
            [tracks addObject:track];
        }

        for (int i=kNumButtonTracks; i < kNumButtonTracks + kNumMotionTracks; i++) {
            NSMutableDictionary* track = [[NSMutableDictionary alloc] init];
            track[@"Name"] = [[BMAudioController sharedController] getAudioFileNameOnTrack:i];
            [tracks addObject:track];
        }
        
        dictionary[@"Tracks"] = tracks;
    }
    
    return dictionary;
}


- (void)updateSavedProjectsList {
    NSError* error;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_projectsDirectory error:&error];
    
    if (_savedProjectsList) {
        _savedProjectsList = nil;
    }
    _savedProjectsList = [[NSMutableArray alloc] init];
    for (NSString* filepath in contents) {
        if ([[filepath pathExtension] isEqualToString:@"plist"]) {
            NSString* filename = [filepath lastPathComponent];
            [_savedProjectsList addObject:[filename stringByDeletingPathExtension]];
        }
    }
}

- (void)installProjectsFromBundle {
    
    NSError* error = nil;
    
    NSString* projectsListPath = [[NSBundle mainBundle] pathForResource:@"ProjectsList" ofType:@"plist"];
    NSArray* projectsArray = [NSArray arrayWithContentsOfFile:projectsListPath];
    
    for (NSString* filename in projectsArray) {
        NSString* fromPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSString* toPath = [[_projectsDirectory stringByAppendingPathComponent:filename] stringByAppendingPathExtension:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error];
    }
}

@end
