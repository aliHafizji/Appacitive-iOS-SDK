//
//  AppYodo.h
//  AppYoda-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MKNetworkKit.h"

extern NSString *const SessionReceivedNotification;

@interface AppYoda : MKNetworkEngine
@property (nonatomic, strong) NSString *session;

+ (id) yodaWithApiKey:(NSString*)apiKey deploymentId:(NSString*)deploymentId;
+ (id) sharedYoda;
@end
