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
    if(propertyName != nil && date != nil) {
        return [NSString stringWithFormat:@"*%@ == date('%@')", propertyName, date.description];
    }
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
    return [NSString stringWithFormat:@"psize=%d", pageSize];
}

+ (NSString*) queryStringForPageNumber:(NSUInteger)pageNumber {
    return [NSString stringWithFormat:@"pnum=%d", pageNumber];
}

+ (NSString*) queryStringForGeoCodeProperty:(NSString*)propertyName location:(CLLocation*)location distance:(DistanceMetric)distanceMetric raduis:(NSNumber*)radius {
    if(propertyName != nil && location != nil && radius != nil) {
        NSString *queryString = [NSString stringWithFormat:@"*%@ within_circle ", propertyName];
        queryString = [queryString stringByAppendingFormat:@"%lf, %lf, %lf", location.coordinate.latitude, location.coordinate.longitude, radius.doubleValue];
        if (distanceMetric == kKilometers) {
            queryString = [queryString stringByAppendingFormat:@" km"];
        } else {
            queryString = [queryString stringByAppendingFormat:@" m"];
        }
        return queryString;
    }
    return nil;
}

+ (NSString*) queryStringForPolygonSearch:(NSString*)propertyName withPolygonCoordinates:(NSArray*)coordinates {
    if (propertyName != nil && coordinates != nil && coordinates.count >= 3) {
        __block NSString *query = [NSString stringWithFormat:@"*%@ within_polygon ", propertyName];
        
        [coordinates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[CLLocation class]]) {
                CLLocation *location = (CLLocation*)obj;
                query = [query stringByAppendingFormat:@"%lf,%lf", location.coordinate.latitude, location.coordinate.longitude];
                if (idx != coordinates.count - 1) {
                    query = [query stringByAppendingString:@"|"];
                }
            }
        }];
        return query;
    }
    return nil;
}

+ (NSString*) queryStringForSearchWithOneOrMoreTags:(NSArray*)tags {
    if (tags != nil) {
        __block NSString *queryString = @"tagged_with_one_or_more ('";
        [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                queryString = [queryString stringByAppendingFormat:@"%@", obj];
                if (idx != tags.count - 1) {
                    queryString = [queryString stringByAppendingString:@","];
                } else {
                    queryString = [queryString stringByAppendingString:@"')"];
                }
            }
        }];
        return queryString;
    }
    return nil;
}

+ (NSString*) queryStringForSearchWithAllTags:(NSArray*)tags {
    if (tags != nil) {
        __block NSString *queryString = @"tagged_with_all ('";
        [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                queryString = [queryString stringByAppendingFormat:@"%@", obj];
                if (idx != tags.count - 1) {
                    queryString = [queryString stringByAppendingString:@","];
                } else {
                    queryString = [queryString stringByAppendingString:@"')"];
                }
            }
        }];
        return queryString;
    }
    return nil;
}

+ (NSString*) queryStringForSearchWithFreeText:(NSArray*)freeTextTokens {
    if (freeTextTokens != nil && freeTextTokens.count > 0) {
        __block NSString *queryString = @"freeText=";
        [freeTextTokens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                queryString = [queryString stringByAppendingString:obj];
                if(idx != freeTextTokens.count - 1) {
                    queryString = [queryString stringByAppendingString:@" "];
                }
            }
        }];
        return queryString;
    }
    return nil;
}

+ (NSString*) generateAndQueryString:(NSArray*) array {
    
    return [APQuery generateQueryStringFor:array operator:@"and"];
}

+ (NSString*) generateOrQueryString:(NSArray*) array {
    return [APQuery generateQueryStringFor:array operator:@"or"];
}

+ (NSString*) generateQueryStringFor:(NSArray*) array operator:(NSString*)operator {
    NSString *queryString;
    
    for (NSString *query in array) {
        if (!queryString) {
            queryString = [NSString string];
            queryString = [queryString stringByAppendingString:query];
        } else {
            queryString = [queryString stringByAppendingFormat:@" %@ %@", operator, query];
        }
    }
    if (queryString) {
        queryString = [NSString stringWithFormat:@"(%@)", queryString];
    }
    return queryString;
}
@end
