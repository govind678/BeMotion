//
//  BMDownloadManager.m
//  BeMotion
//
//  Created by Govinda Pingali on 2/15/16.
//  Copyright © 2016 Plasmatio Tech. All rights reserved.
//

#import "BMDownloadManager.h"
#import "BMConstants.h"

#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>


@interface BMDownloadManager()
{
    NSString*   _awsCognitoID;
}
@end


@implementation BMDownloadManager

#pragma mark - Init

- (id)init {
    
    if ((self = [super init])) {
        
        // Initialize AWS Cognito Credentials
        AWSCognitoCredentialsProvider* credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                              initWithRegionType:AWSRegionUSEast1
                                                              identityPoolId:kAWSCognitoIdentityPoolId];
        
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                             credentialsProvider:credentialsProvider];
        
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
        
        
        // Retrieve Amazon Cognito ID.
        _awsCognitoID = [[NSString alloc] initWithString:credentialsProvider.identityId];
        
    }
    
    return self;
}


#pragma mark - Singleton

+ (instancetype)manager {
    static BMDownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BMDownloadManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)getRemoteSampleSets {
    
}

@end
