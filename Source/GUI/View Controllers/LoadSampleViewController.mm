//
//  LoadSampleViewController.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 5/21/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "LoadSampleViewController.h"
#import "BeMotionAppDelegate.h"

@interface LoadSampleViewController ()
{
    BeMotionAppDelegate*   appDelegate;
}


@end

@implementation LoadSampleViewController

@synthesize waveformView, samplesTable;
@synthesize sampleID;


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
}


- (void)dealloc
{
    [waveformView release];
    [samplesTable release];
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
    
    lastLocation = [touch locationInView: self.view];
    
    if ((lastLocation.x > 20.0f) && (lastLocation.x < 300.0f))
    {
        if ((lastLocation.y > 60.0f) && (lastLocation.y < 124.0f))
        {
            NSLog(@"X: %f, Y: %f", lastLocation.x, lastLocation.y);
        }
    }
    
    
}



- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch.view isEqual: self.view])
    {
        return;
    }
    
    CGPoint location = [touch locationInView: self.view];
    
    CGFloat xDisplacement = location.x - lastLocation.x;
    CGFloat yDisplacement = location.y - lastLocation.y;
    
    NSLog(@"XDisp: %f, YDisp: %f", xDisplacement, yDisplacement);
    //    CGRect frame = touch.view.frame;
    //    frame.origin.x += xDisplacement;
    //    frame.origin.y += yDisplacement;
    //    touch.view.frame = frame;
    
    
}




//--- Sample Table Stuff ---//

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [sampleSectionTitles count];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sampleSectionTitles objectAtIndex:section];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"thisCell"];
    
    //-- Configure Cell --//
    NSString *sectionTitle  = [sampleSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionSamples = [sampleBanks objectForKey:sectionTitle];
    NSString *sample        = [sectionSamples objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:sample];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    
    
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
    
    NSString *sectionTitle  = [sampleSectionTitles objectAtIndex:[indexPath section]];
    NSArray *sectionSamples = [sampleBanks objectForKey:sectionTitle];
    NSString *samplePath    = [[NSBundle mainBundle] pathForResource:[sectionSamples objectAtIndex:[indexPath row]] ofType:@"wav"];
    
    _backendInterface->loadAudioFile(sampleID, samplePath);
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


@end
