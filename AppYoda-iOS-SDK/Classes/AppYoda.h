//
//  AppYodo.h
//  AppYoda-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MKNetworkKit.h"

extern NSString *const SessionReceivedNotification;

/**
 This class is the AppYoda engine.
 It is the entry point to use the SDK
 */
@interface AppYoda : MKNetworkEngine

/**
 Readonly property to store the session id.
 */
@property (nonatomic, strong, readonly) NSString *session;

/**
 Readonly property to store the deployment id.
 */
@property (nonatomic, strong, readonly) NSString *deploymentId;

/**
 Method used to create a YODA!
 
 @param apiKey Api key generated while app setup
 @param deploymentId Deployment id generated when app is deployed.
 */
+ (id) yodaWithApiKey:(NSString*)apiKey deploymentId:(NSString*)deploymentId;

/**
 Method to get the initialized Yoda
 
 @discussion This method will return nil if + yodaWithApiKey: deploymentId: is not called.
 */
+ (id) sharedYoda;
@end
