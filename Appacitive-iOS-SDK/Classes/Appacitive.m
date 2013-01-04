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
@end

static Appacitive *sharedObject = nil;

@implementation Appacitive

+ (id) appacitiveWithApiKey:(NSString*)apiKey {
    if (apiKey != nil && ![apiKey isEqualToString:@""]) {
        @synchronized(self) {
            if (sharedObject == nil) {
                sharedObject = [[Appacitive alloc] initWithApiKey:apiKey];
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

- (id) initWithApiKey:(NSString*)apiKey {
    self = [super initWithHostName:HOST_NAME];
    if (self) {
        _apiKey = apiKey;
        [self fetchSession];
        _enableLiveEnvironment = NO;
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
    
    MKNetworkOperation *op = [self operationWithPath:@"application/session"
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

- (NSString*) environmentToUse {
    if (_enableLiveEnvironment) {
        return @"live";
    }
    return @"sandbox";
}
@end
