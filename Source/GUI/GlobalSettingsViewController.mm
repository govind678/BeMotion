//
//  GlobalSettingsViewController.m
//  GestureController
//
//  Created by Govinda Ram Pingali on 4/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "GlobalSettingsViewController.h"

@interface GlobalSettingsViewController ()

@end

@implementation GlobalSettingsViewController

@synthesize tempoLabel, tempoSlider;
@synthesize presetBankSelector;

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
    
    m_iTempo                = [_metronome getTempo];
    m_iCurrentPresetBank    = _backendInterface->getCurrentPresetBank();
    [tempoLabel setText:[@(m_iTempo) stringValue]];
    [tempoSlider setValue:m_iTempo];
    [presetBankSelector setSelectedSegmentIndex:(m_iCurrentPresetBank-1)];
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
    [tempoSlider release];
    [tempoLabel release];
    
    [presetBankSelector release];
    [super dealloc];
}


- (IBAction)tempoSliderChanged:(UISlider *)sender
{
    m_iTempo = sender.value;
    
    [_metronome setTempo:m_iTempo];
    [tempoLabel setText:[@(m_iTempo) stringValue]];
}


- (IBAction)presetSampleBankLoader:(UISegmentedControl *)sender
{
    int presetBank    =   (int)sender.selectedSegmentIndex;
    _backendInterface->setCurrentPresetBank(presetBank+1);

    if (presetBank == (PRESET_BANK_1 - 1))
    {
        //--- Preload Audio Samples of Bank1 ---//
        NSString *sample1Path = [[NSBundle mainBundle] pathForResource:@"E_Kit0" ofType:@"wav"];
        NSString *sample2Path = [[NSBundle mainBundle] pathForResource:@"E_Kit1" ofType:@"wav"];
        NSString *sample3Path = [[NSBundle mainBundle] pathForResource:@"E_Kit2" ofType:@"wav"];
        NSString *sample4Path = [[NSBundle mainBundle] pathForResource:@"E_Kit3" ofType:@"wav"];
        NSString *sample5Path = [[NSBundle mainBundle] pathForResource:@"E_Kit4" ofType:@"wav"];
        
        
        _backendInterface->loadAudioFile(0, sample1Path);
        _backendInterface->loadAudioFile(1, sample2Path);
        _backendInterface->loadAudioFile(2, sample3Path);
        _backendInterface->loadAudioFile(3, sample4Path);
        _backendInterface->loadAudioFile(4, sample5Path);
    }

    else if (presetBank == (PRESET_BANK_2 - 1))
    {
        //--- Preload Audio Samples of Bank2 ---//
        NSString *sample1Path = [[NSBundle mainBundle] pathForResource:@"Embryo0" ofType:@"wav"];
        NSString *sample2Path = [[NSBundle mainBundle] pathForResource:@"Embryo1" ofType:@"wav"];
        NSString *sample3Path = [[NSBundle mainBundle] pathForResource:@"Embryo2" ofType:@"wav"];
        NSString *sample4Path = [[NSBundle mainBundle] pathForResource:@"Embryo3" ofType:@"wav"];
        NSString *sample5Path = [[NSBundle mainBundle] pathForResource:@"Embryo4" ofType:@"wav"];
        
        
        _backendInterface->loadAudioFile(0, sample1Path);
        _backendInterface->loadAudioFile(1, sample2Path);
        _backendInterface->loadAudioFile(2, sample3Path);
        _backendInterface->loadAudioFile(3, sample4Path);
        _backendInterface->loadAudioFile(4, sample5Path);
    }

    else if (presetBank == (PRESET_BANK_3 - 1))
    {
        //--- Preload Audio Samples of Bank3 ---//
        NSString *sample1Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion0" ofType:@"wav"];
        NSString *sample2Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion1" ofType:@"wav"];
        NSString *sample3Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion2" ofType:@"wav"];
        NSString *sample4Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion3" ofType:@"wav"];
        NSString *sample5Path = [[NSBundle mainBundle] pathForResource:@"Indian_Percussion4" ofType:@"wav"];
        
        
        _backendInterface->loadAudioFile(0, sample1Path);
        _backendInterface->loadAudioFile(1, sample2Path);
        _backendInterface->loadAudioFile(2, sample3Path);
        _backendInterface->loadAudioFile(3, sample4Path);
        _backendInterface->loadAudioFile(4, sample5Path);
    }
    
    else if (presetBank == (PRESET_BANK_4 - 1))
    {
        //--- Preload Audio Samples of Bank4 ---//
        NSString *sample1Path = [[NSBundle mainBundle] pathForResource:@"E_Kit0" ofType:@"wav"];
        NSString *sample2Path = [[NSBundle mainBundle] pathForResource:@"E_Kit1" ofType:@"wav"];
        NSString *sample3Path = [[NSBundle mainBundle] pathForResource:@"E_Kit2" ofType:@"wav"];
        NSString *sample4Path = [[NSBundle mainBundle] pathForResource:@"E_Kit3" ofType:@"wav"];
        NSString *sample5Path = [[NSBundle mainBundle] pathForResource:@"E_Kit4" ofType:@"wav"];
        
        
        _backendInterface->loadAudioFile(0, sample1Path);
        _backendInterface->loadAudioFile(1, sample2Path);
        _backendInterface->loadAudioFile(2, sample3Path);
        _backendInterface->loadAudioFile(3, sample4Path);
        _backendInterface->loadAudioFile(4, sample5Path);
    }
}
@end
