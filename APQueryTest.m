//
//  APQueryTest.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 06/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APQueryTest.h"
#import "APQuery.h"

/**
 Test methods to test the interface of the APQuery class
 */
@implementation APQueryTest

/**
 @purpose To test for nil propertyName
 @expected The generated query should be nil
 */
- (void) testEqualityHelperMethodForNilPropertyName {
    NSString *query = [APQuery queryStringForEqualCondition:nil propertyValue:@"test"];
    STAssertNil(query, @"Test case for nil property name failed.");
}

/**
 @purpose To test for nil propertyValue
 @expected The generated query should be nil
 */
- (void) testEqualityHelperMethodForNilPropertyValue {
    NSString *query = [APQuery queryStringForEqualCondition:@"location" propertyValue:nil];
    STAssertNil(query, @"Test case for nil property value failed.");
}

/**
 @purpose Test if the equality helper method is generating the correct string.
 */
- (void) testEqualityHelperMethod {
    NSString *query = [APQuery queryStringForEqualCondition:@"createdBy" propertyValue:@"John"];
    STAssertEqualObjects(query, @"*createdBy == 'John'",@"Test case for equality helper method failed");
}

/**
 @purpose To test for nil propertyName
 @expected The generated query should be nil
 */
- (void) testLikeHelperMethodForNilPropertyName {
    NSString *query = [APQuery queryStringForLikeCondition:nil propertyValue:@"test"];
    STAssertNil(query, @"Test case for nil property name failed.");
}

/**
 @purpose To test for nil propertyValue
 @expected The generated query should be nil
 */
- (void) testLikeHelperMethodForNilPropertyValue {
    NSString *query = [APQuery queryStringForLikeCondition:@"location" propertyValue:nil];
    STAssertNil(query, @"Test case for nil property value failed.");
}

/**
 @purpose Test if the like helper method is generating the correct string.
 */
- (void) testLikeHelperMethod {
    NSString *query = [APQuery queryStringForLikeCondition:@"createdBy" propertyValue:@"John"];
    STAssertEqualObjects(query, @"*createdBy like 'John'",@"Test case for like helper method failed");
}

/**
 @purpose To test for nil propertyName
 @expected The generated query should be nil
 */
- (void) testGreaterThanHelperMethodForNilPropertyName {
    NSString *query = [APQuery queryStringForGreaterThanCondition:nil propertyValue:@"test"];
    STAssertNil(query, @"Test case for nil property name failed.");
}

/**
 @purpose To test for nil propertyValue
 @expected The generated query should be nil
 */
- (void) testGreaterThanHelperMethodForNilPropertyValue {
    NSString *query = [APQuery queryStringForGreaterThanCondition:@"location" propertyValue:nil];
    STAssertNil(query, @"Test case for nil property value failed.");
}

/**
 @purpose Test if the greater than helper method is generating the correct string.
 */
- (void) testGreaterThanHelperMethod {
    NSString *query = [APQuery queryStringForGreaterThanCondition:@"cost" propertyValue:@"123"];
    STAssertEqualObjects(query, @"*cost > '123'",@"Test case for greater than helper method failed");
}

/**
 @purpose To test for nil propertyName
 @expected The generated query should be nil
 */
- (void) testLessThanHelperMethodForNilPropertyName {
    NSString *query = [APQuery queryStringForLessThanCondition:nil propertyValue:@"test"];
    STAssertNil(query, @"Test case for nil property name failed.");
}

/**
 @purpose To test for nil propertyValue
 @expected The generated query should be nil
 */
- (void) testLessThanHelperMethodForNilPropertyValue {
    NSString *query = [APQuery queryStringForLessThanCondition:@"location" propertyValue:nil];
    STAssertNil(query, @"Test case for nil property value failed.");
}

/**
 @purpose Test if the less than helper method is generating the correct string.
 */
- (void) testLessThanHelperMethod {
    NSString *query = [APQuery queryStringForLessThanCondition:@"cost" propertyValue:@"123"];
    STAssertEqualObjects(query, @"*cost < '123'",@"Test case for like helper method failed");
}

/**
 @purpose Test page size helper method
 */
- (void) testPageSizeHelperMethod {
    NSUInteger integer = 123;
    NSString *query = [APQuery queryStringForPageSize:integer];
    STAssertEqualObjects(query, @"psize = 123", @"Test case for page size helper method failed");
}

/**
 @purpose Test page number helper method
 */
- (void) testPageNumberHelperMethod {
    NSUInteger integer = 123;
    NSString *query = [APQuery queryStringForPageNumber:integer];
    STAssertEqualObjects(query, @"pnum = 123", @"Test case for page number helper method failed");
}
@end
