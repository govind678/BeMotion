//
//  UserInterfaceData.mm
//  SharedLibrary
//
//  Created by Anand on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "UserInterfaceData.h"

@implementation UserInterfaceData
- (void)dealloc
{
    
    [_delayEffect release];
    [_tremoloEffect release];
    [_vibratoEffect release];
    [_wahEffect release];
    
    [super dealloc];
}
@end

@implementation SampleInfo
- (void)dealloc
{
    

    [_sampleID release];
    [_fileURL release];
    [_sampleGain release];
    [_effectChain release];
    [_effectObjects release];
//    [_Pos1 release];
//    [_Pos2 release];
//    [_Pos3 release];
//    [_Pos4 release];
    
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self){        
        self.effectChain    = [[NSMutableArray alloc] initWithCapacity:4];
        [self.effectChain insertObject:[NSNumber numberWithInt:1] atIndex:0];
        [self.effectChain insertObject:[NSNumber numberWithInt:99] atIndex:1];
        [self.effectChain insertObject:[NSNumber numberWithInt:99] atIndex:2];
        [self.effectChain insertObject:[NSNumber numberWithInt:99] atIndex:3];

        self.effectObjects    = [[NSMutableArray alloc] initWithCapacity:4];

    }
    return self;
}
@end

@implementation cDelay
- (void)dealloc
{
    
    [_time release];
    [_feedback release];
    [_wetdry release];
    [_bypass release];
    
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self){
        self.bypass = [NSNumber numberWithInt:0];
    }
    return self;
}

@end

@implementation cTremolo
- (void)dealloc
{
    
    [_depth     release];
    [_frequency release];
    [_signal    release];
    [_bypass    release];
    
    
    [super dealloc];
}
- (id)init {
    self = [super init];
    if (self){
        self.bypass = [NSNumber numberWithInt:0];
    }
    return self;
}
@end

@implementation cVibrato
- (void)dealloc
{
    
    [_width     release];
    [_frequency release];
    [_signal    release];
    [_bypass    release];
    
    
    [super dealloc];
}
- (id)init {
    self = [super init];
    if (self){
        self.bypass = [NSNumber numberWithInt:0];
    }
    return self;
}
@end

@implementation cWah
- (void)dealloc
{
    
    [_frequency release];
    [_gain      release];
    [_resonance release];
    [_bypass    release];
    
    
    [super dealloc];
}
- (id)init {
    self = [super init];
    if (self){
        self.bypass = [NSNumber numberWithInt:0];
    }
    return self;
}
@end

//UISampleInfo :: UISampleInfo () {
//    sampleID = 0;
//    fileURL  = "";
//}
//
//UIEffects :: UIEffects () {
//    delayEffect.delay_time = 0;
//    delayEffect.delay_feedback = 0;
//    delayEffect.dry_wet = 0;
//    delayEffect.bypass = false;
//    
//    tremoloEffect.amp_mod = 0;
//    tremoloEffect.mod_freq = 0;
//    tremoloEffect.dry_wet = 0;
//    tremoloEffect.bypass = false;
//    
//    vibratoEffect.mod_width = 0;
//    vibratoEffect.mod_freq = 0;
//    vibratoEffect.dry_wet = 0;
//    vibratoEffect.bypass = false;
//}
