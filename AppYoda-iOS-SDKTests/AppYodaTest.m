//
//  AppYodaTest.m
//  AppYoda-iOS-SDK
//
//  Created by Kauserali Hafizji on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppYodaTest.h"
#import "AppYoda.h"

#define DEPLOYMENT_ID @"restaurantsearch"
#define API_KEY @"+MmuqVgHVYH7Q+5imsGc4497fiuBAbBeCGYRkiQSCfY="

@implementation AppYodaTest

- (void) testInitMethodForNilApiKeyAndDeploymentId {
    AppYoda *yoda = [AppYoda yodaWithApiKey:nil deploymentId:nil];
    STAssertNotNil(yoda, @"Test case for nil api key and deployment id failed");
}

- (void) testInitMethodForNilApiKey {
    AppYoda *yoda = [AppYoda yodaWithApiKey:nil deploymentId:DEPLOYMENT_ID];
    STAssertNotNil(yoda, @"Test case for nil api key failed");
}

- (void) testInitMethodForNilDeploymentKey {
    AppYoda *yoda = [AppYoda yodaWithApiKey:API_KEY deploymentId:nil];
    STAssertNotNil(yoda, @"Test case for nil deploment id failed");
}
@end
