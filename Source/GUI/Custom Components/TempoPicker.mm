//
//  TempoPicker.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 7/16/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "TempoPicker.h"

@implementation TempoPicker

@synthesize picker, audioSwitch, toggleSwitch;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *toggleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, frame.size.width / 2.0f, 31.0f)];
        [toggleLabel setTextColor:[UIColor blackColor]];
        [toggleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
        [toggleLabel setText:@"Metronome"];
        [self addSubview:toggleLabel];
        
        toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(frame.size.width - 61.0f, 10.0f, 51.0f, 31.0f)];
        [toggleSwitch addTarget:self action:@selector(toggleSwitchChanged) forControlEvents:UIControlEventValueChanged];
        [toggleSwitch setSelected:NO];
        [self addSubview:toggleSwitch];
        
        UILabel *audioLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 46.0f, frame.size.width / 2.0f, 31.0f)];
        [audioLabel setTextColor:[UIColor blackColor]];
        [audioLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
        [audioLabel setText:@"Audio"];
        [self addSubview:audioLabel];
        
        audioSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(frame.size.width - 61.0f, 46.0f, 51.0f, 31.0f)];
        [audioSwitch addTarget:self action:@selector(audioSwitchChanged) forControlEvents:UIControlEventValueChanged];
        [audioSwitch setSelected:NO];
        [self addSubview:audioSwitch];
        
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, frame.size.height - 160.0f, 200.0f, 160.0f)];
        [picker setDataSource:self];
        [picker setDelegate:self];
        [[picker layer] setBorderWidth:1.5f];
        [[picker layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [self addSubview:picker];
        
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
        for (int i=0; i < 3; i++) {
            pickerValue[i] = 0;
        }
        tempo = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Picker View Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return TEMPO_DIGITS;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return 3;
            break;
            
        case 1:
            return 10;
            break;
            
        case 2:
            return 10;
            break;
            
        default:
            return 0;
            break;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString* returnString = [NSString stringWithFormat:@"%d",row];
    return returnString;
}


//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
//    label.backgroundColor = [UIColor lightGrayColor];
//    label.textColor = [UIColor blackColor];
//    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
//    label.text = [NSString stringWithFormat:@"%d", row];
//    return label;
//}


// PickerView Callback
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerValue[component] = row;
    [self calculateTempo];
}





- (void) toggleSwitchChanged {
    [delegate toggleMetronome:[toggleSwitch isOn]];
}

- (void) audioSwitchChanged {
    [delegate toggleMetronomeAudio:[audioSwitch isOn]];
}


- (void) toggleMetronome : (BOOL)value {
    
}

- (void) toggleMetronomeAudio : (BOOL)value {
    
}


- (void) calculateTempo {
    tempo = (100 * pickerValue[0]) + (10 * pickerValue [1]) + pickerValue[2];
    
    if (tempo < 60) {
        tempo = 60;
        [self updateTempo];
    } else if (tempo > 240) {
        tempo = 240;
        [self updateTempo];
    }
    [delegate setTempo:tempo];
}


- (void) updateTempo {
    
    pickerValue[0] = tempo / 100;
    pickerValue[1] = (tempo % 100) / 10;
    pickerValue[2] = tempo % 10;
    
    for (NSInteger column = 0; column < 3; column++) {
        [picker selectRow:pickerValue[column] inComponent:column animated:YES];
    }
}


- (void) setTempo:(int)newTempo {
    
    if (newTempo < 60) {
        tempo = 60;
    } else if (newTempo > 240) {
        tempo = 240;
    } else {
        tempo = newTempo;
    }
    
    [self updateTempo];
}



- (void) dealloc {
    [picker release];
    [audioSwitch release];
    [toggleSwitch release];
    [super dealloc];
}

@end
