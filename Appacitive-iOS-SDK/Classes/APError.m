//
//  APError.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APError.h"

@implementation APError
@synthesize referenceId = _referenceId;
@synthesize version = _version;

- (NSString*) description {
    return [NSString stringWithFormat:@"Error: %@, ReferenceId: %@, Version: %@", self.localizedDescription, self.referenceId, self.version];
}
@end
