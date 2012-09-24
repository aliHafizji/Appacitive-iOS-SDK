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
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedObject = [[Appacitive alloc] initWithApiKey:apiKey deploymentId:deploymentId];
        });
    }
    return sharedObject;
}

+ (id) sharedObject {
    return sharedObject;
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
                                   _apiKey, @"ApiKey",
                                   @NO, @"IsNonSliding",
                                   @-1, @"UsageCount",
                                   @60, @"WindowTime", 
                                   nil];
    
    MKNetworkOperation *op = [self operationWithPath:@"v0.9/core/Account.svc/session"
                                              params:params
                                              httpMethod:@"PUT"];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    [op onCompletion:^(MKNetworkOperation *completedOperation){
        
        NSDictionary *dictionary = (NSDictionary*) completedOperation.responseJSON;
        NSDictionary *session = dictionary[@"Session"];
        _session = session[@"SessionKey"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SessionReceivedNotification object:self];
        DLog(@"%@", self.session);
    } onError:^(NSError *error){
        DLog(@"%@", error);
    }];
    [self enqueueOperation:op];
}
@end
