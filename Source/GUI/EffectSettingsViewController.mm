//==============================================================================
//
//  EffectSettingsViewController.mm
//  BeMotion
//
//  Created by Anand Mahadevan on 3/9/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//============================================================================


#import  "EffectSettingsViewController.h"
#import "BeMotionAppDelegate.h"


@interface EffectSettingsViewController ()
{
    BeMotionAppDelegate*   appDelegate;
}

@end




@implementation EffectSettingsViewController

@synthesize currentSampleID;

@synthesize effectNames;
@synthesize gainSliderObject, playbackModeObject, quantizationSliderObject;
@synthesize pickerObject, bypassButtonObject;
@synthesize slider1Object, slider2Object, slider3Object;
@synthesize slider1CurrentValue, slider2CurrentValue, slider3CurrentValue;
@synthesize slider1EffectParam, slider2EffectParam, slider3EffectParam;
@synthesize gainGestureObject, quantGestureObject, param1GestureObject, param2GestureObject, param3GestureObject;
@synthesize gainLabel, quantizationLabel;
@synthesize activityIndicator;





- (void)awakeFromNib
{
    self.effectNames  = @[@"None", @"Tremolo", @"Delay", @"Vibrato", @"Wah", @"Granularizer"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //--- Get Reference to Backend ---//
    appDelegate = [[UIApplication sharedApplication] delegate];
    _backendInterface   =  [appDelegate getBackendReference];
    
    
    //--- Set Background ---//
    switch (currentSampleID)
    {
        case 0:
            [[self view] setBackgroundColor:[UIColor colorWithRed:0.5f green:0.2f blue:0.2f alpha:1.0f]];
            break;
            
        case 1:
            [[self view] setBackgroundColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.5f alpha:1.0f]];
            break;
            
        case 2:
            [[self view] setBackgroundColor:[UIColor colorWithRed:0.2f green:0.5f blue:0.2f alpha:1.0f]];
            break;
            
        case 3:
            [[self view] setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.2f alpha:1.0f]];
            break;
            
        default:
            break;
    }
    
     m_iCurrentEffectPosition        =   0;
    
    
    //--- Get Sample Parameters ---//
    float gain = _backendInterface->getSampleParameter(currentSampleID, PARAM_GAIN);
    [gainSliderObject setValue:gain];
    [gainLabel setText:[@(gain) stringValue]];
    
    [playbackModeObject setSelectedSegmentIndex:_backendInterface->getSampleParameter(currentSampleID, PARAM_PLAYBACK_MODE)];
    
    float quantization = _backendInterface->getSampleParameter(currentSampleID, PARAM_QUANTIZATION);
    [quantizationSliderObject setValue:quantization];
    [quantizationLabel setText:[@( powf(2, (int)quantization) ) stringValue]];
    
    
    //--- Get Sample Gesture Control Toggles ---//
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN))
    {
        [gainGestureObject setAlpha: 1.0f];
        [gainSliderObject setEnabled:NO];
    }
    
    else
    {
        [gainGestureObject setAlpha: 0.4f];
        [gainSliderObject setEnabled:YES];
    }
    
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT))
    {
        [quantGestureObject setAlpha: 1.0f];
        [quantizationSliderObject setEnabled:NO];
    }
    
    else
    {
        [quantGestureObject setAlpha: 0.4f];
        [quantizationSliderObject setEnabled:YES];
    }
    
    
    
    //--- Get Effect Parameters ---//
    [pickerObject selectRow:_backendInterface->getEffectType(currentSampleID, m_iCurrentEffectPosition) inComponent:0 animated:YES];
    [self updateSlidersAndLabels];
}





//--- Sample Parameter Changes ---//

// Set Gain
- (IBAction)gainSliderChanged:(UISlider *)sender
{
    _backendInterface->setSampleParameter(currentSampleID, PARAM_GAIN, sender.value);
    [gainLabel setText:[@(sender.value) stringValue]];
}


// Segmented Control for Button Mode
- (IBAction)buttonModeChanged:(UISegmentedControl *)sender
{
    _backendInterface->setSampleParameter(currentSampleID, PARAM_PLAYBACK_MODE, (int)sender.selectedSegmentIndex);
}


// Set Quantization Time for Note Repeat
- (IBAction)quantizationSliderChanged:(UISlider *)sender
{
    _backendInterface->setSampleParameter(currentSampleID, PARAM_QUANTIZATION, (int)sender.value);
    [quantizationLabel setText:[@( pow(2, (int)sender.value) ) stringValue]];
}






//--- Audio Effect Parameter Changes ---//


// Effect Position Segmented View - Display parameters based on effect position
- (IBAction)SegementControl:(UISegmentedControl *)sender
{
    m_iCurrentEffectPosition    =   (int)sender.selectedSegmentIndex;
    int effectType = _backendInterface->getEffectType(currentSampleID, m_iCurrentEffectPosition);
    [pickerObject selectRow:effectType inComponent:0 animated:YES];
    [self updateSlidersAndLabels];
}



//--- UI Picker View Stuff for Choosing Audio Effect ---//

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // Only 1 component
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return NUM_EFFECTS;
}

// Fill Picker View with effect names
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return effectNames[row];
}

// Callback when picker row is changed
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _backendInterface->addAudioEffect(currentSampleID, m_iCurrentEffectPosition, (int)row);
    [self updateSlidersAndLabels];
}



- (IBAction)bypassToggleButtonChanged:(UISwitch *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_BYPASS, sender.on);
}

- (IBAction)Slider1Changed:(UISlider *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_1, sender.value);
    [slider1CurrentValue setText:[@(sender.value) stringValue]];
}

- (IBAction)Slider2Changed:(UISlider *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_2, sender.value);
    [slider2CurrentValue setText:[@(sender.value) stringValue]];
}

- (IBAction)Slider3Changed:(UISlider *)sender
{
    _backendInterface->setEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_3, sender.value);
    [slider3CurrentValue setText:[@(sender.value) stringValue]];
}






- (void) updateSlidersAndLabels
{
    float param1 = _backendInterface->getEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_1);
    float param2 = _backendInterface->getEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_2);
    float param3 = _backendInterface->getEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_3);
    
    [slider1Object setValue:param1];
    [slider2Object setValue:param2];
    [slider3Object setValue:param3];
    
    [slider1CurrentValue setText:[@(param1) stringValue]];
    [slider2CurrentValue setText:[@(param2) stringValue]];
    [slider3CurrentValue setText:[@(param3) stringValue]];
    
    [bypassButtonObject setSelected:_backendInterface->getEffectParameter(currentSampleID, m_iCurrentEffectPosition, PARAM_BYPASS)];
    
    
    //-- Update Gesture Control Buttons --//
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1))
    {
        [param1GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param1GestureObject setAlpha:0.4f];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2))
    {
        [param2GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param2GestureObject setAlpha:0.4f];
    }
    
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3))
    {
        [param3GestureObject setAlpha:1.0f];
    }
    
    else
    {
        [param3GestureObject setAlpha:0.4f];
    }
    
    
    
    
    
    switch (_backendInterface->getEffectType(currentSampleID, m_iCurrentEffectPosition))
    {
        case 0:
            [self.slider1EffectParam setText:@"Null"];
            [self.slider2EffectParam setText:@"Null"];
            [self.slider3EffectParam setText:@"Null"];
            break;
            
        case 1:
            [self.slider1EffectParam setText:@"Frequency"];
            [self.slider2EffectParam setText:@"Depth"];
            [self.slider3EffectParam setText:@"LFO"];
            break;
            
        case 2:
            [self.slider1EffectParam setText:@"Time"];
            [self.slider2EffectParam setText:@"Feedback"];
            [self.slider3EffectParam setText:@"Wet/Dry"];
            break;
            
        case 3:
            [self.slider1EffectParam setText:@"Rate"];
            [self.slider2EffectParam setText:@"Width"];
            [self.slider3EffectParam setText:@"LFO"];
            break;
            
        case 4:
            [self.slider1EffectParam setText:@"Gain"];
            [self.slider2EffectParam setText:@"Frequency"];
            [self.slider3EffectParam setText:@"Resonance"];
            break;
            
            
        case 5:
            [self.slider1EffectParam setText:@"Size"];
            [self.slider2EffectParam setText:@"Interval"];
            [self.slider3EffectParam setText:@"Pool"];
            break;
            
            
        default:
            break;
    }
}




//--- Gesture Control Toggles ---//

- (IBAction)gainGestureToggle:(UIButton *)sender
{
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN))
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN, false);
        sender.alpha = 0.4;
        [gainSliderObject setEnabled:YES];
    }
    
    else
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_GAIN, true);
        sender.alpha = 1.0f;
        [gainSliderObject setEnabled:NO];
    }
}

- (IBAction)quantGestureToggle:(UIButton *)sender
{
    if (_backendInterface->getSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT))
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT, false);
        sender.alpha = 0.4;
        [quantizationSliderObject setEnabled:YES];
    }
    
    else
    {
        _backendInterface->setSampleGestureControlToggle(currentSampleID, PARAM_MOTION_QUANT, true);
        sender.alpha = 1.0f;
        [quantizationSliderObject setEnabled:NO];
    }
}

- (IBAction)param1GestureToggle:(UIButton *)sender
{
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1))
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM1, true);
        sender.alpha = 1.0f;
    }
}

- (IBAction)param2GestureToggle:(UIButton *)sender
{
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2))
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM2, true);
        sender.alpha = 1.0f;
    }
}

- (IBAction)param3GestureToggle:(UIButton *)sender
{
    if (_backendInterface->getEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3))
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3, false);
        sender.alpha = 0.4;
    }
    
    else
    {
        _backendInterface->setEffectGestureControlToggle(currentSampleID, m_iCurrentEffectPosition, PARAM_MOTION_PARAM3, true);
        sender.alpha = 1.0f;
    }
    
}



//--- Media Picker Stuff ---//


- (IBAction) launchMediaLibrary:(UIButton *)sender
{
    mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    [mediaPicker setAllowsPickingMultipleItems:NO];
    [self presentViewController:mediaPicker animated:YES completion:NULL];
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
    
    
    [self startCopyingMediaFile];

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
            [self stopCopyingMediaFile];
            
            
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


- (void) startCopyingMediaFile
{
//    [[self view] setAlpha:0.4f];
//    [activityIndicator startAnimating];
}


- (void) stopCopyingMediaFile
{
//    [[self view] setAlpha:1.0f];
//    [activityIndicator stopAnimating];
}



//--- Destructor ---//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc
{
    [effectNames release];
    [slider1EffectParam release];
    [slider2EffectParam release];
    [slider3EffectParam release];
    [slider1CurrentValue release];
    [slider2CurrentValue release];
    [slider3CurrentValue release];

    [slider1Object release];
    [slider2Object release];
    [slider3Object release];
    [bypassButtonObject release];
    [pickerObject release];
    

    [gainSliderObject release];
    [quantizationSliderObject release];
    [bypassButtonObject release];
    [playbackModeObject release];
    
    
    [gainGestureObject release];
    [quantGestureObject release];
    [param1GestureObject release];
    [param2GestureObject release];
    [param3GestureObject release];
    
    [gainLabel release];
    [quantizationLabel release];
    
    [activityIndicator release];
    
    [super dealloc];
}


@end
