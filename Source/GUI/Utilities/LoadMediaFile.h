//
//  LoadMediaFile.h
//  BeMotion
//
//  Created by Govinda Ram Pingali on 6/23/14.
//  Copyright (c) 2014 BeMotionLLC. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#include "Macros.h"

#include "BeMotionInterface.h"

@interface LoadMediaFile : MPMediaPickerController <MPMediaPickerControllerDelegate>
{
    NSURL* currentSongURL;
}

@property (nonatomic, assign) BeMotionInterface*  backendInterface;
@property (nonatomic, assign) int currentSampleID;

@end
