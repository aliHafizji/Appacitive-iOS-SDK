//
//  Appacitive.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. All rights reserved.
//

#import "Appacitive.h"

#define HOST_NAME @"apis.appacitive.com"

NSString *const SessionReceivedNotification = @"SessionReceivedNotification";

@interface Appacitive() {
    NSString *_apiKey;
}
- (id) initWithApiKey:(NSString*)apiKey deploymentId:(NSString*)deploymentId;
@end

static Appacitive *sharedObject = nil;

@implementation Appacitive

+ (id) appacitiveWithApiKey:(NSString*)apiKey deploymentId:(NSString*)deploymentId {
    if (apiKey != nil && deploymentId != nil && ![apiKey isEqualToString:@""] && ![deploymentId isEqualToString:@""]) {
        @synchronized(self) {
            if (sharedObject == nil) {
                sharedObject = [[Appacitive alloc] initWithApiKey:apiKey deploymentId:deploymentId];
            }
        }
    }
    return sharedObject;
}

+ (id) sharedObject {
    return sharedObject;
}

+ (void) setSharedObject:(Appacitive *)object {
    sharedObject = object;
}

- (id) initWithApiKey:(NSString*)apiKey deploymentId:(NSString*)deploymentId {
    self = [super initWithHostName:HOST_NAME];
    if (self) {
        _apiKey = apiKey;
        _deploymentId = deploymentId;
        [self fetchSession];
    }
    return self;
}

- (void) fetchSession {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _apiKey, @"apikey",
                                   @NO, @"isnonsliding",
                                   @-1, @"usagecount",
                                   @60, @"windowtime", 
                                   nil];
    
    MKNetworkOperation *op = [self operationWithPath:@"v0.9/core/Application.svc/v2/session"
                                              params:params
                                              httpMethod:@"PUT"];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    [op onCompletion:^(MKNetworkOperation *completedOperation){
        
        NSDictionary *dictionary = (NSDictionary*) completedOperation.responseJSON;
        NSDictionary *session = dictionary[@"session"];
        _session = session[@"sessionkey"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SessionReceivedNotification object:self];
    } onError:^(NSError *error){
        DLog(@"%@", error);
    }];
    [self enqueueOperation:op];
}
@end
