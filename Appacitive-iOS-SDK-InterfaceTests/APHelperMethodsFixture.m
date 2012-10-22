//
//  APHelperMethodTest.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APHelperMethodsFixture.h"
#import "APHelperMethods.h"
#import "APError.h"

/**
 Test methods to test the interface of the AYHelperMethods class
 */
@implementation APHelperMethodsFixture

/**
 @purpose Test for nil response
 @expected The method should return nil
 */
- (void) testForNilResponse {
    APError *error = [APHelperMethods checkForErrorStatus:nil];
    STAssertNil(error, @"Test case for nil response object failed");
}

/**
 @purpose Test with error JSON
 @expected Should return an error
 */
- (void) testWithErrorResponse {
    NSDictionary *statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSArray array], @"additionalmessages",
                                      @"400", @"code",
                                      @"Unsuccessful", @"message",
                                      @"9e56903c-0b68-4ee9-afbc-c045ab4a708a", @"referenceid", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                statusDictionary, @"status", nil];
    APError *error = [APHelperMethods checkForErrorStatus:dictionary];
    STAssertNotNil(error, @"Test case for response object with error status failed");
}

/**
 @purpose Test with valid JSON
 @expected Should return nil
 */
- (void) testWithValidResponse {
    NSDictionary *statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSArray array], @"AdditionalMessages",
                                      @"200", @"Code",
                                      @"Successful", @"Message",
                                      @"9e56903c-0b68-4ee9-afbc-c045ab4a708a", @"ReferenceId", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                nil, @"Article",
                                statusDictionary, @"Status", nil];
    APError *error = [APHelperMethods checkForErrorStatus:dictionary];
    STAssertNil(error, @"Test case for valid response object failed");
}
@end
