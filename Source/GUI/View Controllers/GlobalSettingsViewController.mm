//==============================================================================
//
//  GlobalSettingsViewController.mm
//  BeMotion
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//
//==============================================================================


#import "GlobalSettingsViewController.h"
#import "BeMotionAppDelegate.h"

@interface GlobalSettingsViewController ()
{
    BeMotionAppDelegate*   appDelegate;
}

@end

@implementation GlobalSettingsViewController

@synthesize sampleSetsTable, fxPackTable;


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
    
    //--- Get Reference to Backend and Metronome ---//
    appDelegate = [[UIApplication sharedApplication] delegate];
    _backendInterface   =  [appDelegate getBackendReference];
    _metronome          =  [appDelegate getMetronomeReference];
    sampleBanks         =  [appDelegate sampleSets];
    sampleSectionTitles =  [[NSMutableArray alloc] initWithArray:[sampleBanks allKeys]];
    fxPackSet           =  [appDelegate fxPacks];
    
    
    [sampleSetsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [fxPackTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    m_iTempo                = [_metronome getTempo];
    currentSampleBank       = _backendInterface->getCurrentSampleBank();
    currentFXPack           = _backendInterface->getCurrentFXPack();
    
    
    //--- Set Background Image ---//
    [[self view] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
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


- (void)dealloc
{
    [sampleSetsTable release];
    [fxPackTable release];
    
    [super dealloc];
}





//--- Table Stuff ---//

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == sampleSetsTable) {
        return [sampleSectionTitles count];
    }
    
    if (tableView == fxPackTable) {
        return [fxPackSet count];
    }
    
    return 0;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"thisCell"];
    
    if (tableView == sampleSetsTable) {
        
        //-- Configure Cell --//
        NSString *sectionTitle  = [sampleSectionTitles objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:sectionTitle];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [[cell textLabel] setTextColor:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
        
        NSArray* objects = [sampleBanks objectForKey:sectionTitle];
        NSString* imageTitle = [objects objectAtIndex:7];
        [[cell imageView] setImage:[UIImage imageNamed:imageTitle]];
        
    }
    
    if (tableView == fxPackTable) {
        
        //-- Configure Cell --//
        NSString *sectionTitle  = [fxPackSet objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:sectionTitle];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [[cell textLabel] setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == sampleSetsTable) {
        currentSampleBank = [sampleSectionTitles objectAtIndex:[indexPath row]];
        [self loadAudioPresetBank];
    }
    
    if (tableView == fxPackTable) {
        currentFXPack = [fxPackSet objectAtIndex:[indexPath row]];
        _backendInterface->loadFXPreset([[NSBundle mainBundle] pathForResource:currentFXPack ofType:@"json"]);
    }
    
}




- (void)loadAudioPresetBank
{
    _backendInterface->setCurrentSampleBank(currentSampleBank);
    
    NSArray *sectionSamples = [sampleBanks objectForKey:currentSampleBank];
    
    for (int sample = 0; sample < NUM_SAMPLE_SOURCES; sample++) {
        
        NSString* samplePath = [[NSBundle mainBundle] pathForResource:[sectionSamples objectAtIndex:sample] ofType:@"wav"];
        
        if( (_backendInterface->loadAudioFile(sample, samplePath)) != 0 ) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Audio File"
                                                            message:@"Retry loading"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }
    
    
    //--- Start Playback if Already Playing ---//
    
    for (int i=0; i < NUM_BUTTONS; i++) {
        if (_backendInterface->getSamplePlaybackStatus(i)) {
            _backendInterface->startPlayback(i);
        }
    }
    
    
    
    //--- Set Tempo from Presets ---//
    
    m_iTempo = int([[sectionSamples objectAtIndex:6] integerValue]);
    _backendInterface->setTempo(m_iTempo);
//    [_metronome setTempo:m_iTempo];
}

@end
