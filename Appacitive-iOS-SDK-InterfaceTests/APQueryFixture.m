//
//  APQueryTest.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 06/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APQueryFixture.h"
#import "APQuery.h"
#import <CoreLocation/CoreLocation.h>

/**
 Test methods to test the interface of the APQuery class
 */
@implementation APQueryFixture

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

/**
 @purpose Test for nil property name.
 @expected Query string should be nil
 */
- (void) testEqualityDateHelperMethodForNilPropertyName {
    NSString *query = [APQuery queryStringForEqualCondition:nil date:[NSDate date]];
    STAssertNil(query, @"Test case for nil property name failed");
}

/**
 @purpose Test for nil date.
 @expected Query string should be nil
 */
- (void) testEqualityDateHelperMethodForNilDate {
    NSString *query = [APQuery queryStringForEqualCondition:@"date" date:nil];
    STAssertNil(query, @"Test case for nil date parameter failed");
}

/**
 @purpose Test date equality helper method
 */
- (void) testEqualityDateHelperMethod {
    NSDate *date = [NSDate date];
    NSString *query = [APQuery queryStringForEqualCondition:@"date" date:date];
    
    NSString *expectedQuery = [NSString stringWithFormat:@"*date == date('%@')", date.description];
    STAssertEqualObjects(query, expectedQuery, 
                         @"Test case for equality date helper method failed");
}

/**
 @purpose Test polygon search helper method for nil property name
 @expected Nil query string
 */
- (void) testPolygonSearchForNilPropertyName {
    NSString *query = [APQuery queryStringForPolygonSearch:nil withPolygonCoordinates:[NSArray array]];
    STAssertNil(query, @"Test for nil property name failed");
}

/**
 @purpose Test polygon search helper method for nil coordinates
 @expected Nil query string
 */
- (void) testPolygonSearchForNilCoordinates {
    NSString *query = [APQuery queryStringForPolygonSearch:@"location" withPolygonCoordinates:nil];
    STAssertNil(query, @"Test for nil coordinates failed");
}

/**
 @purpose Test polygon search helper method with less than 3 coordinates
 @expected Nil query string
 */
- (void) testPolygonSearchForLessThan3Coordinates {
    NSString *query = [APQuery queryStringForPolygonSearch:@"location" withPolygonCoordinates:[NSArray array]];
    STAssertNil(query, @"Test for less than 3 coordinates failed");
}

/**
 @purpose Test polygon search helper method
 */
- (void) testPolygonSearchHelperMethod {
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:123 longitude:444];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:200 longitude:300];
    CLLocation *location3 = [[CLLocation alloc] initWithLatitude:400 longitude:500];
    NSArray *coordinates = [NSArray arrayWithObjects:location1, location2, location3, nil];
    
    NSString *expectedString = @"*location within_polygon 123.000000,444.000000|200.000000,300.000000|400.000000,500.000000";
    NSString *query = [APQuery queryStringForPolygonSearch:@"location" withPolygonCoordinates:coordinates];
    
    STAssertEqualObjects(query, expectedString, @"Test case for polygon search failed");
}

/**
 @purpose Test free text helper method for nil tokens
 @expected Query string should be nil
 */
- (void) testFreeTextHelperMethodForNilTokens {
    NSString *queryString = [APQuery queryStringForSearchWithFreeText:nil];
    STAssertNil(queryString, @"Test case for nil free text tokens failed");
}

/**
 @purpose Test free text helper method
 */
- (void) testFreeTextHelperMethod {
    NSString *expectedString = @"freeText=a b c";
    NSString *queryString = [APQuery queryStringForSearchWithFreeText:[NSArray arrayWithObjects:@"a", @"b", @"c", nil]];
    STAssertEqualObjects(queryString, expectedString, @"Test case for free text failed");
}

/**
 @purpose Test one or more tags helper method for nil tags
 @expected Nil query string
 */
- (void) testOneOrMoreTagsHelperMethodForNilTags {
    NSString *queryString = [APQuery queryStringForSearchWithOneOrMoreTags:nil];
    STAssertNil(queryString, @"Test for nil tags failed");
}

/**
 @purpose Test one or more tags helper method
 */
- (void) testOneOrMoreTagsHelperMethod {
    NSArray *tags = [NSArray arrayWithObjects:@"a", @"b", nil];
    
    NSString *expectedString = @"tagged_with_one_or_more ('a,b')";
    NSString *queryString = [APQuery queryStringForSearchWithOneOrMoreTags:tags];
    STAssertEqualObjects(queryString, expectedString, @"Test case for one or more tags helper method failed");
}

/**
 @purpose Test for all tags search helper method
 */
- (void) testTagsWithAllHelperMethod {
    NSArray *tags = [NSArray arrayWithObjects:@"a", @"b", nil];
    
    NSString *expectedString = @"tagged_with_all ('a,b')";
    NSString *queryString = [APQuery queryStringForSearchWithAllTags:tags];
    STAssertEqualObjects(queryString, expectedString, @"Test case for all tags helper method failed");
}

/**
 @purpose Test for geocode helper method
 */
- (void) testGeoCodeHelperMethod {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:123 longitude:200];
    NSString *expectedString = @"*location within_circle 123.000000, 200.000000, 12.000000 km";
    NSString *queryString = [APQuery queryStringForGeoCodeProperty:@"location" location:location distance:kKilometers raduis:[NSNumber numberWithInt:12]];
    
    STAssertEqualObjects(queryString, expectedString, @"Test case for geo code helper method failed");
}
@end
