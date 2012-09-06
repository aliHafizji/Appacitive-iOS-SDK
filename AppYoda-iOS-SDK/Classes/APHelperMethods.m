//
//  AYHelperMethods.m
//  WhereIGo
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AYHelperMethods.h"
#import "AYError.h"

#define ERROR_DOMAIN @"appyoda.appacitive.com"

@implementation AYHelperMethods

+ (AYError*) checkForErrorStatus:(id)response {
    NSDictionary *status = [response objectForKey:@"Status"];
    NSString *statusCode = [status objectForKey:@"Code"];
    if (statusCode && ![statusCode isEqualToString:@"200"]) {
        NSString *referenceId = [status objectForKey:@"ReferenceId"];
        NSString *message = [status objectForKey:@"Message"];
        NSString *version = [status objectForKey:@"Version"];
        NSArray *additionalMessages = [status objectForKey:@"AdditionalMessages"];
        
        NSString *errorMessage = [NSString stringWithFormat:@"Message: %@ Additional messages: %@", message, additionalMessages.description];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                errorMessage, NSLocalizedDescriptionKey, nil];
        AYError *error = [AYError errorWithDomain:ERROR_DOMAIN code:[statusCode integerValue] userInfo:dictionary];
        error.referenceId = referenceId;
        error.version = version;
        return error;
    }
    return nil;
}
@end
