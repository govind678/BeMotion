//
//  LoadMediaFile.h
//  BeatMotion
//
//  Created by Govinda Ram Pingali on 6/23/14.
//  Copyright (c) 2014 PlasmatioTech. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#include "Macros.h"

#include "BeatMotionInterface.h"

@interface LoadMediaFile : MPMediaPickerController <MPMediaPickerControllerDelegate>
{
    NSURL* currentSongURL;
}

@property (nonatomic, assign) BeatMotionInterface*  backendInterface;
@property (nonatomic, assign) int currentSampleID;

@end
