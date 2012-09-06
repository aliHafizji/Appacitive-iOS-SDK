//
//  APQuery.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 05/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef enum {
    kKilometers,
    kMiles
} DistanceMetric;

@interface APQuery : NSObject

/**
 Helper method to generate an equal to query string.
 
 @param propertyName name of the property to search for
 @param propertyValue the value of the property to equate to.
 
 Example query would be +[APQuery queryStringForEqualCondition:@"hotelName" propertyValue:@"Le Meridian"]
 This would return "*hotelName == 'Le Meridian'" which is the format Appacitive understands
 */
+ (NSString*) queryStringForEqualCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

/**
 Helper method to generate an equal to query string.
 
 @param propertyName name of the property to search for
 @param date the date to equate to.
 
 Example query would be +[APQuery queryStringForEqualCondition:@"checkinDate" date:someDate]
 This would return "*checkinDate == date(someDate.description)'" which is the format Appacitive understands
 */
+ (NSString*) queryStringForEqualCondition:(NSString*)propertyName date:(NSDate*)date;

/**
 Helper method to generate a query string for like condition.
 
 @param propertyName name of the property to search for
 @param propertyValue the value of the property.
 
 Example query would be +[APQuery queryStringForLikeCondition:@"hotelName" propertyValue:@"Le Meridian"]
 This would return "*hotelName like 'Le Meridian'" which is the format Appacitive understands
 */
+ (NSString*) queryStringForLikeCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

/**
 Helper method to generate a greater than query string.
 
 @param propertyName name of the property to search for
 @param propertyValue value that the property should be greater than.
 
 Example query would be +[APQuery queryStringForGreaterThanCondition:@"cost" propertyValue:[NSString stringWithFormat@"%d", 123]]
 This would return "*cost > '123'" which is the format Appacitive understands
 */
+ (NSString*) queryStringForGreaterThanCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

/**
 Helper method to generate a less than query string.
 
 @param propertyName name of the property to search for
 @param propertyValue the value the property should be less than.
 
 Example query would be +[APQuery queryStringForLessThanCondition:@"cost" propertyValue:[NSString stringWithFormat@"%d", 123]]
 This would return "*cost < '123'" which is the format Appacitive understands
 */
+ (NSString*) queryStringForLessThanCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

/**
 Helper method to generate a query string for page size.
 
 @param pageSize an integer value for the page size.
 
 Example query would be +[APQuery queryStringForPageSize:2]
 This would return "psize=(2)" which is the format Appacitive understands
 */
+ (NSString*) queryStringForPageSize:(NSUInteger)pageSize;

/**
 Helper method to generate a query string for page number.
 
 @param pageNumber the page number to get
 
 Example query would be +[APQuery queryStringForPageNumber:123]
 This would return "pnum=(123)" which is the format Appacitive understands
 */
+ (NSString*) queryStringForPageNumber:(NSUInteger)pageNumber;

/**
 Helper method to generate a query string for geocode search.
 
 @param propertyName name of the property to search for
 @param location the geocode to search for
 @param distanceMetric the distance either in km or miles
 @param radius the radios around the location to look for
 
 Example query would be +[APQuery queryStringForGeoCodeProperty:@"location" location:{123, 123} distance:kilometers raduis:12]
 This would return "*location within_circle 123,123,12" which is the format Appacitive understands
 */
+ (NSString*) queryStringForGeoCodeProperty:(NSString*)propertyName location:(CLLocation*)location distance:(DistanceMetric)distanceMetric raduis:(NSNumber*)radius;

/**
 Helper method to generate a query string for polygon search.
 
 @param propertyName name of the property to search for
 @param coordinates an array of CLLocation coordinates. The array needs to have a minimum of three coordinates.
 
 Example query would be +[APQuery queryStringForPolygonSearch:@"location" withPolygonCoordinates:coordinates]
 This would return "*location within_polygon {lat,long} | {lat,long} | {lat,long}" which is the format Appacitive understands
 */
+ (NSString*) queryStringForPolygonSearch:(NSString*)propertyName withPolygonCoordinates:(NSArray*)coordinates;

/**
 Helper method to generate a query string for search with tags.
 
 @param tags an array of tags to search for.
 
 Example query would be +[APQuery queryStringForSearchWithOneOrMoreTags:array]
 This would return "tagged_with_one_or_more ('tag1,tag2')" where tag1 and tag2 are in array, which is the format Appacitive understands
 */
+ (NSString*) queryStringForSearchWithOneOrMoreTags:(NSArray*)tags;

/**
 Helper method to generate a query string for search with tags.
 
 @param tags an array of tags to search for.
 
 Example query would be +[APQuery queryStringForSearchWithAllTags:array]
 This would return "tagged_with_all ('tag1,tag2')" where tag1 and tag2 are in array, which is the format Appacitive understands
 */
+ (NSString*) queryStringForSearchWithAllTags:(NSArray*)tags;

/**
 Helper method to generate a query string for between condition.
 
 @param propertyName name of the property to search for
 @param values values the property name needs to be in between.
 
 Example query would be +[APQuery queryStringForBetweenCondition:@"cost" value:{123,150}]
 This would return "cost between (123 , 150)" which is the format Appacitive understands
 */
+ (NSString*) queryStringForBetweenCondition:(NSString*)propertyName value:(NSArray*)values;

/**
 Helper method to generate a query string to search for free text.
 
 @param freeTextTokens
 */
+ (NSString*) queryStringForSearchWithFreeText:(NSArray*)freeTextTokens;
@end
