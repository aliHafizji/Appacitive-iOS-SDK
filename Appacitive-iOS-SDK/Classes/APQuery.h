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

+ (NSString*) queryStringForEqualCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

+ (NSString*) queryStringForequalCondition:(NSString*)propertyName date:(NSDate*)date;

+ (NSString*) queryStringForLikeCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

+ (NSString*) queryStringForGreaterThanCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

+ (NSString*) queryStringForLessThanCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue;

+ (NSString*) queryStringForPageSize:(NSUInteger*)pageSize;

+ (NSString*) queryStringForPageNumber:(NSUInteger*)pageNumber;

+ (NSString*) queryStringForGeoCodeProperty:(NSString*)propertyName location:(CLLocation*)location distance:(DistanceMetric)distanceMetric raduis:(NSNumber*)raduis;

+ (NSString*) queryStringForPolygonSearch:(NSString*)propertyName withPolygonCoordinates:(NSArray*)coordinates;

+ (NSString*) queryStringForSearchWithOneOrMoreTags:(NSArray*)tags;

+ (NSString*) queryStringForSearchWithAllTags:(NSArray*)tags;

+ (NSString*) queryStringForBetweenCondition:(NSString*)propertyName value:(NSArray*)values;

+ (NSString*) queryStringForSearchWithFreeText:(NSArray*)freeTextTokens;
@end
