//
//  Appacitive.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. All rights reserved.
//

#import "MKNetworkKit.h"

extern NSString *const SessionReceivedNotification;
extern NSString *const ErrorRetrievingSessionNotification;

/**
 An Appacitive object is the entry point to use the Appacitive SDK.
 All the network requests are queued up here and sent to the remote service.
 */
@interface Appacitive : MKNetworkEngine

@property (nonatomic, strong, readonly) NSString *session;
@property (nonatomic, readwrite) BOOL enableLiveEnvironment;
@property (nonatomic, readwrite) BOOL enableDebugForEachRequest;

/**
 Creates a shared object.
 
 This needs to be initialized when the app starts. No API call will be successful if this object does not exist.
 
 @param apiKey Application API Key.
 */
+ (id) appacitiveWithApiKey:(NSString*)apiKey;

/**
 Retrieve the shared appacitive object.
 
 @discussion This method will return nil if appacitiveWithApiKey:deploymentId: is not called.
 */
+ (id) sharedObject;

/**
 Helper method to set the shared appacitive object.
 */
+ (void) setSharedObject:(Appacitive *)object;

/**
 By default the environment is set to sandbox. To change to live set the enableLiveEnvironment property of the Appacitive object.
 
 @return The environment to use
 */
- (NSString*) environmentToUse;
@end
