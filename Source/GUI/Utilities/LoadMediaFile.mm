//
//  LoadMediaFile.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/23/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "LoadMediaFile.h"
#import "BeMotionAppDelegate.h"


@interface LoadMediaFile ()
{
    BeMotionAppDelegate*   appDelegate;
}
@end


@implementation LoadMediaFile

@synthesize currentSampleID;

- (id) init
{
    if (self = [super init])
    {
        //--- Get Reference to Backend and Metronome ---//
        appDelegate = [[UIApplication sharedApplication] delegate];
        _backendInterface   =  [appDelegate getBackendReference];
        
        
        [self setDelegate:self];
        [self setAllowsPickingMultipleItems:NO];
//        [self presentViewController:self animated:YES completion:NULL];
        
        
//        //--- Get Reference to Backend ---//
//        appDelegate = [[UIApplication sharedApplication] delegate];
//        _backendInterface   =  [appDelegate getBackendReference];
        
        currentSampleID = 0;
        
    }
    
    return self;
}


- (void) mediaPicker:(MPMediaPickerController *)inputMediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
//    NSString* title = [mediaItemCollection.items[0] valueForProperty:MPMediaItemPropertyTitle];
//    NSString* artist = [mediaItemCollection.items[0] valueForProperty:MPMediaItemPropertyArtist];
//    double duration = [[mediaItemCollection.items[0] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    
    currentSongURL = [mediaItemCollection.items[0] valueForProperty:MPMediaItemPropertyAssetURL];
    
    [self loadMediaFile];
    
    
    // Dismiss media picker view
    [inputMediaPicker dismissViewControllerAnimated:YES completion:NULL];
    
    
    // Tell whoever's listening that we're done with the media picker
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mediaPickerFinished" object:nil];
}

- (void) mediaPickerDidCancel:(MPMediaPickerController *)inputMediaPicker
{
    [inputMediaPicker dismissViewControllerAnimated:YES completion:NULL];
}



- (void) loadMediaFile
{
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:currentSongURL options:options];
    
    NSError *error = nil;
    AVAssetReader* fileReader = [AVAssetReader assetReaderWithAsset:(AVAsset *)asset error:&error];
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSNumber numberWithFloat:DEFAULT_SAMPLE_RATE], AVSampleRateKey,
                                  [ NSNumber numberWithInt:NUM_CHANNELS], AVNumberOfChannelsKey,
                                  [ NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                  [ NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                  [ NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                  [ NSData data], AVChannelLayoutKey, nil ];
    
    if (error)
    {
        NSLog(@"Read Error");
        // Problem with Audio
    }
    
    AVAssetReaderAudioMixOutput* audioMixOutput = [AVAssetReaderAudioMixOutput
                                                   assetReaderAudioMixOutputWithAudioTracks:(asset.tracks)
                                                   audioSettings:audioSetting];
    
    if ([fileReader canAddOutput:(AVAssetReaderOutput *)audioMixOutput] == NO)
    {
        NSLog(@"Cannot Add Reader Output");
        // Problem with Audio
    }
    
    [fileReader addOutput:(AVAssetReaderOutput *)audioMixOutput];
    
    if ([fileReader startReading] == NO)
    {
        NSLog(@"Not Started Reading");
        // Problem with Audio
    }
    
    
    
    //-- Write to WAV File --//
    
    NSString* outputAudioPath = [self returnOutputFilePath];
    NSURL* outputURL = [NSURL fileURLWithPath:outputAudioPath];
    
    NSError* writerError;
    AVAssetWriter *fileWriter = [AVAssetWriter assetWriterWithURL:outputURL
                                                         fileType:AVFileTypeWAVE
                                                            error:&writerError];
    
    if (writerError)
    {
        NSLog(@"Write Error");
        // Problem with Audio
    }
    
    AVAssetWriterInput *assetWriterInput = [ AVAssetWriterInput assetWriterInputWithMediaType :AVMediaTypeAudio
                                                                                outputSettings:audioSetting];
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    if (![fileWriter canAddInput:assetWriterInput])
    {
        NSLog(@"Cannot add Writer Output");
        // Problem with Audio
    }
    
    [fileWriter addInput :assetWriterInput];
    
    if (![fileWriter startWriting])
    {
        NSLog(@"Not Started Writing");
        // Problem with Audio
    }
    
    [fileReader retain];
    [fileWriter retain];
    
    [fileWriter startSessionAtSourceTime:kCMTimeZero ];
    
    dispatch_queue_t queue = dispatch_queue_create( "assetWriterQueue", NULL );
    
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
        
        NSLog(@"Start Copying Audio");
        
        while (1)
        {
            if ([assetWriterInput isReadyForMoreMediaData]) {
                
                CMSampleBufferRef sampleBuffer = [audioMixOutput copyNextSampleBuffer];
                
                if (sampleBuffer) {
                    [assetWriterInput appendSampleBuffer :sampleBuffer];
                    CFRelease(sampleBuffer);
                } else {
                    [assetWriterInput markAsFinished];
                    break;
                }
            }
        }
        
        [fileWriter finishWritingWithCompletionHandler:^{
            NSLog(@"Finish Copying Audio");
            
            //--- Load Backend ---//
            if( (_backendInterface->loadAudioFile(currentSampleID, outputAudioPath)) != 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Audio File"
                                                                message:@"Retry Loading or wait after selecting media"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
            
        }];
        
        
        [fileReader release ];
        [fileWriter release ];
        
    }];
    
    
    
    dispatch_release(queue);
    
}




- (NSString *) returnOutputFilePath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/Media%i.wav", documentPath, currentSampleID];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    return filePath;
}


- (void)dealloc
{
    
    
    
    [super dealloc];
}


@end
