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
    NSDictionary *status;
    if (response[@"status"]) {
        status = response[@"status"];
    } else {
        status = response;
    }
    NSString *statusCode = status[@"code"];
    if (statusCode && ![statusCode isEqualToString:@"200"]) {
        NSString *referenceId = status[@"referenceid"];
        NSString *message = status[@"message"];
        NSString *version = status[@"version"];
        NSArray *additionalMessages = status[@"additionalmessages"];
        
        NSString *errorMessage = [NSString stringWithFormat:@"Message: %@ Additional messages: %@", message, additionalMessages.description];
        NSDictionary *dictionary = @{NSLocalizedDescriptionKey: errorMessage};
        APError *error = [APError errorWithDomain:ERROR_DOMAIN code:[statusCode integerValue] userInfo:dictionary];
        error.referenceId = referenceId;
        error.version = version;
        return error;
    }
    return nil;
}
@end
