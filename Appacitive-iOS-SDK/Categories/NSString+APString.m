//
//  NSString+APString.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 25/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "NSString+APString.h"
#import "NSDictionary+APDictionary.h"

@implementation NSString (APString)

- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)queryParameters {
    if ([queryParameters count] > 0) {
        return [NSString stringWithFormat:@"%@?%@", self, [queryParameters stringWithURLEncodedEntries]];
    }
    return [NSString stringWithString:self];
}

- (NSString *)appendQueryParams:(NSDictionary *)queryParams {
    return [self stringByAppendingQueryParameters:queryParams];
}

- (NSDictionary *)queryParameters {
    return [self queryParametersUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)queryParametersUsingEncoding:(NSStringEncoding)encoding {
    return [self queryParametersUsingArrays:NO encoding:encoding];
}

- (NSString *)stringByAddingURLEncoding
{
    CFStringRef legalURLCharactersToBeEscaped = CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`\n\r");
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (CFStringRef)self,
                                                                        NULL,
                                                                        legalURLCharactersToBeEscaped,
                                                                        kCFStringEncodingUTF8);
    if (encodedString) {
        return (__bridge NSString *)encodedString;
    }
    
    // TODO: Log a warning?
    return @"";
}

- (NSDictionary *)queryParametersUsingArrays:(BOOL)shouldUseArrays encoding:(NSStringEncoding)encoding
{
    NSString *stringToParse = self;
    NSRange chopRange = [stringToParse rangeOfString:@"?"];
    if (chopRange.length > 0) {
        chopRange.location += 1; // we want inclusive chopping up *through *"?"
        if (chopRange.location < [stringToParse length])
            stringToParse = [stringToParse substringFromIndex:chopRange.location];
    }
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:stringToParse];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        
        if (!shouldUseArrays) {
            if (kvPair.count == 2) {
                NSString *key = [[kvPair objectAtIndex:0]
                                 stringByReplacingPercentEscapesUsingEncoding:encoding];
                NSString *value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [pairs setObject:value forKey:key];
            }
        }
        else {
            if (kvPair.count == 1 || kvPair.count == 2) {
                NSString *key = [[kvPair objectAtIndex:0]
                                 stringByReplacingPercentEscapesUsingEncoding:encoding];
                NSMutableArray *values = [pairs objectForKey:key];
                if (nil == values) {
                    values = [NSMutableArray array];
                    [pairs setObject:values forKey:key];
                }
                if (kvPair.count == 1) {
                    [values addObject:[NSNull null]];
                    
                } else if (kvPair.count == 2) {
                    NSString *value = [[kvPair objectAtIndex:1]
                                       stringByReplacingPercentEscapesUsingEncoding:encoding];
                    [values addObject:value];
                }
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}
@end
