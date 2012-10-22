//
//  AppacitiveTest.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 30/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "AppacitiveFixture.h"
#import "Appacitive.h"

#define DEPLOYMENT_ID @"restaurantsearch"
#define API_KEY @"+MmuqVgHVYH7Q+5imsGc4497fiuBAbBeCGYRkiQSCfY="

/**
 Test methods to check the interface of the Appacitive class
 */
@implementation AppacitiveFixture

/**
 @purpose Test for nil API_KEY and DEPLOYMENT_ID
 @expected Appacitive object should be nil
 */
- (void) testInitMethodForNilApiKeyAndDeploymentId {
    Appacitive *yoda = [Appacitive appacitiveWithApiKey:nil deploymentId:nil];
    STAssertNil(yoda, @"Test case for nil api key and deployment id failed");
}

/**
 @purpose Test for nil API_KEY
 @expected Appacitive object should be nil
 */
- (void) testInitMethodForNilApiKey {
    Appacitive *yoda = [Appacitive appacitiveWithApiKey:nil deploymentId:DEPLOYMENT_ID];
    STAssertNil(yoda, @"Test case for nil api key failed");
}

/**
 @purpose Test for nil DEPLOYMENT_ID
 @expected Appacitive object should be nil
 */
- (void) testInitMethodForNilDeploymentKey {
    Appacitive *yoda = [Appacitive appacitiveWithApiKey:API_KEY deploymentId:nil];
    STAssertNil(yoda, @"Test case for nil deploment id failed");
}
@end
