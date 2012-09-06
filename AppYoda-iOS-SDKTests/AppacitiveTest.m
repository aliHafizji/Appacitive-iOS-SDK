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

/*
 Test methods to check the interface of the AppYoda class
 */
@implementation AppYodaTest

/*
 @purpose Test for nil API_KEY and DEPLOYMENT_ID
 @expected AppYoda object should be nil
 */
- (void) testInitMethodForNilApiKeyAndDeploymentId {
    AppYoda *yoda = [AppYoda yodaWithApiKey:nil deploymentId:nil];
    STAssertNil(yoda, @"Test case for nil api key and deployment id failed");
}

/*
 @purpose Test for nil API_KEY
 @expected AppYoda object should be nil
 */
- (void) testInitMethodForNilApiKey {
    AppYoda *yoda = [AppYoda yodaWithApiKey:nil deploymentId:DEPLOYMENT_ID];
    STAssertNil(yoda, @"Test case for nil api key failed");
}

/*
 @purpose Test for nil DEPLOYMENT_ID
 @expected AppYoda object should be nil
 */
- (void) testInitMethodForNilDeploymentKey {
    AppYoda *yoda = [AppYoda yodaWithApiKey:API_KEY deploymentId:nil];
    STAssertNil(yoda, @"Test case for nil deploment id failed");
}
@end
