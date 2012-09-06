//
//  APQuery.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 05/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APQuery.h"

@implementation APQuery

+ (NSString*) queryStringForEqualCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue {
    if (propertyName != nil && propertyValue != nil) {
        return [NSString stringWithFormat:@"*%@ == '%@'", propertyName, propertyValue];
    }
    return nil;
}

+ (NSString*) queryStringForEqualCondition:(NSString*)propertyName date:(NSDate*)date {
    return nil;
}

+ (NSString*) queryStringForLikeCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue {
    if (propertyName != nil && propertyValue != nil) {
        return [NSString stringWithFormat:@"*%@ like '%@'", propertyName, propertyValue];
    }
    return nil;
}

+ (NSString*) queryStringForGreaterThanCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue {
    if (propertyName != nil && propertyValue != nil) {
        return [NSString stringWithFormat:@"*%@ > '%@'", propertyName, propertyValue];
    }
    return nil;
}

+ (NSString*) queryStringForLessThanCondition:(NSString*)propertyName propertyValue:(NSString*)propertyValue {
    if (propertyName != nil && propertyValue != nil) {
        return [NSString stringWithFormat:@"*%@ < '%@'", propertyName, propertyValue];
    }
    return nil;
}

+ (NSString*) queryStringForPageSize:(NSUInteger)pageSize {
    return [NSString stringWithFormat:@"psize = %d", pageSize];
}

+ (NSString*) queryStringForPageNumber:(NSUInteger)pageNumber {
    return [NSString stringWithFormat:@"pnum = %d", pageNumber];
}

+ (NSString*) queryStringForGeoCodeProperty:(NSString*)propertyName location:(CLLocation*)location distance:(DistanceMetric)distanceMetric raduis:(NSNumber*)radius {
    return nil;
}

+ (NSString*) queryStringForPolygonSearch:(NSString*)propertyName withPolygonCoordinates:(NSArray*)coordinates {
    return nil;
}

+ (NSString*) queryStringForSearchWithOneOrMoreTags:(NSArray*)tags {
    return nil;
}

+ (NSString*) queryStringForSearchWithAllTags:(NSArray*)tags {
    return nil;
}

+ (NSString*) queryStringForBetweenCondition:(NSString*)propertyName value:(NSArray*)values {
    return nil;
}

+ (NSString*) queryStringForSearchWithFreeText:(NSArray*)freeTextTokens {
    return nil;
}

@end
