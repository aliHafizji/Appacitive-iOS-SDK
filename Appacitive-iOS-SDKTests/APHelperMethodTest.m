//
//  APHelperMethodTest.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APHelperMethodTest.h"
#import "APHelperMethods.h"
#import "APError.h"

/*
 Test methods to test the interface of the AYHelperMethods class
 */
@implementation APHelperMethodTest

/*
 @pupose Test for nil response
 @expected The method should return nil
 */
- (void) testForNilResponse {
    APError *error = [APHelperMethods checkForErrorStatus:nil];
    STAssertNil(error, @"Test case for nil response object failed");
}

/*
 @pupose Test with Invalid JSON
 @expected Should return an error
 */
- (void) testWithErrorResponse {
    NSDictionary *statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSArray array], @"AdditionalMessages",
                                      @"400", @"Code",
                                      @"Unsuccessful", @"Message",
                                      @"9e56903c-0b68-4ee9-afbc-c045ab4a708a", @"ReferenceId", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                statusDictionary, @"Status", nil];
    APError *error = [APHelperMethods checkForErrorStatus:dictionary];
    STAssertNotNil(error, @"Test case for response object with error status failed");
}

/*
 @pupose Test with valid JSON
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
