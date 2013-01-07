//
//  APUserDetails.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 07/01/13.
//  Copyright (c) 2013 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APUserDetails.h"

@implementation APUserDetails

- (NSMutableDictionary*) createParameters {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"user" forKey:@"__schematype"];//remove this later
    if (self.username) {
        [dictionary setObject:self.username forKey:@"username"];
    }
    if (self.password) {
        [dictionary setObject:self.password forKey:@"password"];
    }
    if (self.firstName) {
        [dictionary setObject:self.firstName forKey:@"firstname"];
    }
    if (self.email) {
        [dictionary setObject:self.email forKey:@"email"];
    }
    if (self.birthDate) {
        [dictionary setObject:self.birthDate forKey:@"birthdate"];
    }
    if (self.lastName) {
        [dictionary setObject:self.lastName forKey:@"lastname"];
    }
    if (self.secretQuestion) {
        [dictionary setObject:self.secretQuestion forKey:@"secretquestion"];
    }
    if (self.secretAnswer) {
        [dictionary setObject:self.secretAnswer forKey:@"secretanswer"];
    }
    if (self.phone) {
        [dictionary setObject:self.phone forKey:@"phone"];
    }
    return dictionary;
}
@end
