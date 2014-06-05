//
//  EffectsTable.m
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/4/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import "EffectsTable.h"

@implementation EffectsTable

@synthesize effectsArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.effectsArray  = @[@"None", @"Tremolo", @"Delay", @"Vibrato", @"Wah", @"Granularizer"];
        [self setDataSource:self];
        [self setDelegate:self];
        [self setAllowsSelection:YES];
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUM_EFFECTS_TYPES;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] autorelease];
    }
    
    cell.textLabel.text = [effectsArray objectAtIndex:[indexPath row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


@end
