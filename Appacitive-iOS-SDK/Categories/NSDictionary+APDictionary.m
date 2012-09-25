//
//  NSDictionary+APDictionary.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 25/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "NSDictionary+APDictionary.h"
#import "NSString+APString.h"

@implementation NSDictionary (APDictionary)

- (void)URLEncodePart:(NSMutableArray *)parts path:(NSString *)path value:(id)value
{
    NSString *encodedPart = [[value description] stringByAddingURLEncoding];
    [parts addObject:[NSString stringWithFormat:@"%@=%@", path, encodedPart]];
}

- (void)URLEncodeParts:(NSMutableArray *)parts path:(NSString *)inPath
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *encodedKey = [[key description] stringByAddingURLEncoding];
        NSString *path = inPath ? [inPath stringByAppendingFormat:@"[%@]", encodedKey] : encodedKey;
        
        if ([value isKindOfClass:[NSArray class]]) {
            for (id item in value) {
                if ([item isKindOfClass:[NSDictionary class]] || [item isKindOfClass:[NSMutableDictionary class]]) {
                    [item URLEncodeParts:parts path:[path stringByAppendingString:@"[]"]];
                } else {
                    [self URLEncodePart:parts path:[path stringByAppendingString:@"[]"] value:item];
                }
                
            }
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]) {
            [value URLEncodeParts:parts path:path];
        }
        else {
            [self URLEncodePart:parts path:path value:value];
        }
    }];
}

- (NSString *)stringWithURLEncodedEntries
{
    NSMutableArray *parts = [NSMutableArray array];
    [self URLEncodeParts:parts path:nil];
    return [parts componentsJoinedByString:@"&"];
}
@end
