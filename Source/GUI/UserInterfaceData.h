//
//  UserInterfaceData.h
//  SharedLibrary
//
//  Created by Anand on 3/9/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__UserInterface__
#define __SharedLibrary__UserInterface__

#import  <Foundation/Foundation.h>

@interface cDelay : NSObject

@property (nonatomic,retain) NSNumber *time;
@property (nonatomic,retain) NSNumber *feedback;
@property (nonatomic,retain) NSNumber *wetdry;
@property (nonatomic,retain) NSNumber *bypass;

@end

@interface cTremolo : NSObject

@property (nonatomic,retain) NSNumber *depth;
@property (nonatomic,retain) NSNumber *frequency;
@property (nonatomic,retain) NSNumber *signal;
@property (nonatomic,retain) NSNumber *bypass;

@end

@interface cVibrato : NSObject

@property (nonatomic,retain) NSNumber *width;
@property (nonatomic,retain) NSNumber *frequency;
@property (nonatomic,retain) NSNumber *signal;
@property (nonatomic,retain) NSNumber *bypass;

@end

@interface cWah : NSObject

@property (nonatomic,retain) NSNumber *frequency;
@property (nonatomic,retain) NSNumber *gain;
@property (nonatomic,retain) NSNumber *resonance;
@property (nonatomic,retain) NSNumber *bypass;

@end

@interface UserInterfaceData : NSObject
@property (nonatomic,retain) cDelay   *delayEffect;
@property (nonatomic,retain) cTremolo *tremoloEffect;
@property (nonatomic,retain) cVibrato *vibratoEffect;
@property (nonatomic,retain) cWah     *wahEffect;
@end

@interface SampleInfo : UserInterfaceData

@property (nonatomic,retain) NSNumber       *sampleID;
@property (nonatomic,retain) NSNumber       *sampleGain;
@property (nonatomic,retain) NSString       *fileURL;
@property (nonatomic,retain) NSMutableArray *effectChain;
@property (nonatomic,retain) NSMutableArray *effectObjects;


@end


//struct UIDelay {
//    float delay_time;
//    float delay_feedback;
//    float dry_wet;
//    bool  bypass;
//};
//
//struct UIVibrato {
//    float mod_width;
//    float mod_freq;
//    float dry_wet;
//    bool  bypass;
//};
//
//struct UITremolo {
//    float amp_mod;
//    float mod_freq;
//    float dry_wet;
//    bool  bypass;
//};
//
//class UIEffects {
//public:
//    UIEffects();
//    ~UIEffects();
//    UIDelay    delayEffect;
//    UIVibrato  vibratoEffect;
//    UITremolo  tremoloEffect;
//        
//};
//
//class UISampleInfo : public UIEffects {
//public:
//    UISampleInfo();
//    ~UISampleInfo();
//    int    sampleID;
//    string fileURL;
//};
#endif
