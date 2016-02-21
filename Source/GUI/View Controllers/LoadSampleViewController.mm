//
//  LoadSampleViewController.m
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 5/21/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import "LoadSampleViewController.h"
#import "BMAppDelegate.h"
#import "UIFont+Additions.h"
#import "BMConstants.h"
#import <AWSS3/AWSS3.h>

@interface LoadSampleViewController ()
{
    BMAppDelegate*   appDelegate;
}


@end

@implementation LoadSampleViewController

@synthesize waveformView;
@synthesize sampleID, samplesTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //--- Get Reference to Backend ---//
    appDelegate = [[UIApplication sharedApplication] delegate];
    _backendInterface   =  [appDelegate getBackendReference];
    sampleBanks         =  [appDelegate sampleSets];
    
    
    //--- Set Background Image ---//
    [[self view] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
    
    [self.view setMultipleTouchEnabled:YES];
    
    [waveformView setSampleID:sampleID];
    [waveformView setArrayToDrawWaveform : _backendInterface->getSamplesToDrawWaveform(sampleID)];
    
    //--- Samples Table ---//
    
    sampleSectionTitles = [[NSMutableArray alloc] initWithArray:[sampleBanks allKeys]];
    [samplesTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    currentSegment = 0;
    
    _busyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [_busyView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [_busyView setAlpha:0.0f];
    [self.view addSubview:_busyView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityIndicator setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_activityIndicator];
    
    
    // Create Downloaded Audio Files Subdirectory
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];

    _downloadPath = [documentsDirectory stringByAppendingPathComponent:@"Changes-Guitar.wav"];
    NSError* error;
    [[NSFileManager defaultManager] removeItemAtPath:_downloadPath error:&error];
    NSLog(@"%@", error.description);
    
//    sampleSelector = [[SampleSelect alloc] initWithFrame:CGRectMake(20.0f, 288.0f, 280.0f, 260.0f) : sampleID];
//    [sampleSelector setWaveformView:waveformView];
//    [[self view] addSubview:sampleSelector];
}


- (void)dealloc
{
    [waveformView release];
//    [samplesTable release];
//    [sampleSelector release];
    [samplesTable release];
    [_downloadPath release];
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch.view isEqual: self.view] || touch.view == nil)
    {
        return;
    }
    
    lastLocation = [touch locationInView: waveformView];
    
    
    _backendInterface->setPlayheadPosition(sampleID, lastLocation.x / 280.0f);
    _backendInterface->setSampleParameter(sampleID, PARAM_GAIN, 1.0f - (lastLocation.y / 150.0f));
    
//    if ((lastLocation.x > 20.0f) && (lastLocation.x < 300.0f))
//    {
//        if ((lastLocation.y > 60.0f) && (lastLocation.y < 124.0f))
//        {
//            NSLog(@"X: %f, Y: %f", lastLocation.x, lastLocation.y);
//        }
//    }
    
    
}



- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch.view isEqual: self.view])
    {
        return;
    }
    
    CGPoint location = [touch locationInView: waveformView];
    
//    CGFloat xDisplacement = location.x - lastLocation.x;
//    CGFloat yDisplacement = location.y - lastLocation.y;
    
//    NSLog(@"XDisp: %f, YDisp: %f", xDisplacement, yDisplacement);
//    NSLog(@"XDisp: %f, YDisp: %f", location.x, location.y);
    //    CGRect frame = touch.view.frame;
    //    frame.origin.x += xDisplacement;
    //    frame.origin.y += yDisplacement;
    //    touch.view.frame = frame;
    
    _backendInterface->setPlayheadPosition(sampleID, location.x / 280.0f);
    _backendInterface->setSampleParameter(sampleID, PARAM_GAIN, 1.0f - (location.y / 150.0f));
}




//--- Sample Table Stuff ---//

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (currentSegment == 0) {
        return [sampleSectionTitles count];
    } else if (currentSegment == 1) {
        return 1;
    } else {
        return 1;
    }
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (currentSegment == 0) {
        return 5;
    } else if (currentSegment == 1) {
        return (_backendInterface->getNumberOfUserRecordings());
    } else if (currentSegment == 2) {
        return 1;
    } else {
        return 1;
    }
}


- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (currentSegment == 0) {
        return [sampleSectionTitles objectAtIndex:section];
    } else if (currentSegment == 1) {
        NSString* string = @"";
        return string;
    } else {
        NSString* string = @"";
        return string;
    }
    
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"loadCell"];

    //-- Configure Cell --//
    
    if (currentSegment == 0) {
        NSString *sectionTitle  = [sampleSectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionSamples = [sampleBanks objectForKey:sectionTitle];
        NSString *sample        = [sectionSamples objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:sample];
//        [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [[cell textLabel] setFont:[UIFont lightDefaultFontOfSize: 12.0f]];
    }
    
    else if (currentSegment == 1) {
        NSString *sample = _backendInterface->getUserRecordingFileName((int)[indexPath row]);
        [[cell textLabel] setText:sample];
    }
    
    else if (currentSegment == 2) {
        NSString *sample = @"Changes Guitar";
        [[cell textLabel] setText:sample];
    }
    

    switch (sampleID)
    {
        case 0:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f]];
            break;

        case 1:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.15f green:0.39f blue:0.78f alpha:1.0f]];
            break;
            
        case 2:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f]];
            break;
            
        case 3:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f]];
            break;
            
        default:
            [[cell textLabel] setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (currentSegment == 0) {
        
        NSString *sectionTitle  = [sampleSectionTitles objectAtIndex:[indexPath section]];
        NSArray *sectionSamples = [sampleBanks objectForKey:sectionTitle];
        NSString *samplePath    = [[NSBundle mainBundle] pathForResource:[sectionSamples objectAtIndex:[indexPath row]] ofType:@"wav"];
        
        _backendInterface->loadAudioFile(sampleID, samplePath);
    }
    
    else if (currentSegment == 1) {
        _backendInterface->loadUserRecordedFile(sampleID, (int)[indexPath row]);
    }
    
    else if (currentSegment == 2) {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        _downloadPath = [documentsDirectory stringByAppendingPathComponent:@"Changes-Guitar.wav"];
        NSLog(@"Path: %@", _downloadPath);
        _backendInterface->loadAudioFile(sampleID, _downloadPath);
    }
    
    
    [waveformView setArrayToDrawWaveform : _backendInterface->getSamplesToDrawWaveform(sampleID)];
    
    if (_backendInterface->getSamplePlaybackStatus(sampleID)) {
        _backendInterface->startPlayback(sampleID);
    }
}





//--- Launch iTunes Media ---//


- (IBAction)launchMediaLibrary:(UIButton *)sender {
    mediaPicker = [[LoadMediaFile alloc] initWithMediaTypes:MPMediaTypeMusic];
    [mediaPicker init];
    [mediaPicker setCurrentSampleID:sampleID];
    [self presentViewController:mediaPicker animated:YES completion:NULL];
}


- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    currentSegment = (int)sender.selectedSegmentIndex;
    
    if (currentSegment == 2) {
        [self downloadFromAWSS3];
    } else {
        [samplesTable reloadData];
    }
}


#pragma mark - Private Methods

- (void)downloadFromAWSS3 {
    
    [self showBusyView:YES];
    
    // Create Downloaded Audio Files Subdirectory
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    _downloadPath = [documentsDirectory stringByAppendingPathComponent:@"Changes-Guitar.wav"];
    NSLog(@"Path: %@", _downloadPath);
    
    //--- AWS S3 ---//
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    //--- Download Location of Samples ---//
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:_downloadPath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
//    downloadRequest.bucket = @"s3-us-west-1.amazonaws.com/bemotion";
//    downloadRequest.bucket = @"bemotion.s3-website-us-west-1.amazonaws.com";
    downloadRequest.bucket = kAWSS3BucketName;
    downloadRequest.key = @"samples/Changes/Changes_Guitar.wav";
//    downloadRequest.key = @"audio_files/Changes/Changes_Guitar.wav";
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    
    // Download the file.
    [[transferManager download:downloadRequest]
     continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
         
         if (task.error) {
             
             if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                 switch (task.error.code) {
                     case AWSS3TransferManagerErrorCancelled:
                     case AWSS3TransferManagerErrorPaused:
                         break;
                         
                     default:
                         NSLog(@"Error: %@", task.error);
                         [self showBusyView:NO];
                         break;
                 }
             } else {
                 // Unknown error.
                 NSLog(@"Error: %@", task.error);
                 [self showBusyView:NO];
             }
         }
         
         if (task.result) {
             AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
             //File downloaded successfully.
             [self showBusyView:NO];
             [samplesTable reloadData];
         }
         
         return nil;
     }];
}

- (void)showBusyView:(BOOL)show {
    
    if (show) {
        
        [_activityIndicator startAnimating];
        [UIView animateWithDuration:0.1f animations:^{
            [_busyView setAlpha:1.0f];
        }];
        
    } else {
        
        [_activityIndicator stopAnimating];
        [UIView animateWithDuration:0.1f animations:^{
            [_busyView setAlpha:0.0f];
        }];
        
    }
}

@end
