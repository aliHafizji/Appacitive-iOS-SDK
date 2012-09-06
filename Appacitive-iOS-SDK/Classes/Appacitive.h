//
//  Appacitive.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. All rights reserved.
//

#import "MKNetworkKit.h"

extern NSString *const SessionReceivedNotification;

/**
 This class is the Appacitive engine.
 It is the entry point to use the SDK
 */
@interface Appacitive : MKNetworkEngine

/**
 Readonly property to store the session id.
 */
@property (nonatomic, strong, readonly) NSString *session;

/**
 Readonly property to store the deployment id.
 */
@property (nonatomic, strong, readonly) NSString *deploymentId;

/**
 Method used to create a shared appacitive object.
 
 @param apiKey Api key generated while app setup
 @param deploymentId Deployment id generated when app is deployed.
 */
+ (id) appacitiveWithApiKey:(NSString*)apiKey deploymentId:(NSString*)deploymentId;

/**
 Method to get the initialized appactive object.
 
 @discussion This method will return nil if +appacitiveWithApiKey: deploymentId: is not called.
 */
+ (id) sharedObject;
@end
