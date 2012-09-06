//
//  APHelperMethods.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. All rights reserved.
//

#import "APHelperMethods.h"
#import "APError.h"

#define ERROR_DOMAIN @"appyoda.appacitive.com"

@implementation APHelperMethods

+ (APError*) checkForErrorStatus:(id)response {
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
        APError *error = [APError errorWithDomain:ERROR_DOMAIN code:[statusCode integerValue] userInfo:dictionary];
        error.referenceId = referenceId;
        error.version = version;
        return error;
    }
    return nil;
}
@end
