//
//  AYError.h
//  AYoda-iOS example
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@interface AYError : NSError
@property (nonatomic, strong) NSString *referenceId;
@property (nonatomic, strong) NSString *version;
@end
