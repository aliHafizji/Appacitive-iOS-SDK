//
//  AYError.h
//  AYoda-iOS example
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@interface AYError : NSObject
@property NSNumber *statusCode;
@property NSString *message;
@property NSString *referenceId;
@property NSString *version;
@end
