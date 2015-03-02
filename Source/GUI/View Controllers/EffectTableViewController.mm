//
//  EffectTableViewController.m
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 7/16/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import "EffectTableViewController.h"
#import "BMAppDelegate.h"
#import "EffectSettingsViewController.h"
#import "UIFont+Additions.h"

@interface EffectTableViewController ()
{
    BMAppDelegate* appDelegate;
}

@end

@implementation EffectTableViewController

@synthesize effectTable, sampleID, effectPosition, fxNames;

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
    
    // Reference to App Delegate
    appDelegate = [[UIApplication sharedApplication] delegate];
    fxNames = [[NSArray alloc] initWithArray:[appDelegate fxTypes] copyItems:YES];
    _backendInterface = [appDelegate getBackendReference];
    
    
    //--- Table Settings ---//
    [effectTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    //--- Set Background ---//
    [[self view] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
    
    //--- Select Checked Cell ---//
    self.checkedPath = [NSIndexPath indexPathForRow:_backendInterface->getEffectType(sampleID, effectPosition) inSection:0];
    
    
    //--- Set Text Color ---//
    switch (sampleID)
    {
        case 0:
            currentColor = [UIColor colorWithRed:0.98f green:0.34f blue:0.14f alpha:1.0f];
            break;
            
        case 1:
            currentColor = [UIColor colorWithRed:0.15f green:0.39f blue:0.78f alpha:1.0f];
            break;
            
        case 2:
            currentColor = [UIColor colorWithRed:0.0f green:0.74f blue:0.42f alpha:1.0f];
            break;
            
        case 3:
            currentColor = [UIColor colorWithRed:0.96f green:0.93f blue:0.17f alpha:1.0f];
            break;
            
        default:
            currentColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
            break;
    }
    
    [[self headerLabel] setTextColor:currentColor];
    [[self headerLabel] setText:[NSString stringWithFormat:@"FX %d", effectPosition + 1]];
    
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



#pragma mark - Table View

//--- Table Stuff ---//

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fxNames count];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"effectCell"];
    
    NSString* title = [fxNames objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:title];
//    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [[cell textLabel] setFont:[UIFont lightDefaultFontOfSize: 14.0f]];
    [[cell textLabel] setTextColor:currentColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    if ([self.checkedPath isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.checkedPath = indexPath;
    [tableView reloadData];
    _backendInterface->addAudioEffect(sampleID, effectPosition, (int)[indexPath row]);
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"loadSettingsViewFromTable"]) {
        EffectSettingsViewController* vc = [segue destinationViewController];
        [vc setCurrentSampleID:sampleID];
        [vc setCurrentEffectPosition:effectPosition];
    }
}


- (void)dealloc {
    [fxNames release];
    [effectTable release];
    [_headerLabel release];
    [super dealloc];
}


@end
