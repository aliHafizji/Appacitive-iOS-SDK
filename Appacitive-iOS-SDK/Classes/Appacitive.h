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
 An Appacitive object is the entry point to use the Appacitive SDK.
 All the network requests are queued up here and sent to the remote service.
 */
@interface Appacitive : MKNetworkEngine

@property (nonatomic, strong, readonly) NSString *session;
@property (nonatomic, strong, readonly) NSString *deploymentId;
@property (nonatomic, readwrite) BOOL enableDebugForEachRequest;

/**
 Creates a shared object.
 
 This needs to be initialized when the app starts. No API call will be successful if this object does not exist.
 
 @param apiKey Application API Key.
 @param deploymentId Deployment id.
 */
+ (id) appacitiveWithApiKey:(NSString*)apiKey deploymentId:(NSString*)deploymentId;

/**
 Retrieve the shared appacitive object.
 
 @discussion This method will return nil if appacitiveWithApiKey:deploymentId: is not called.
 */
+ (id) sharedObject;

/**
 Helper method to set the shared appacitive object.
 */
+ (void) setSharedObject:(Appacitive *)object;
@end
