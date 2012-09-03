//
//  AYResponseBlocks.h
//  AYoda-iOS example
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@class AYError;

/*
 Success block that returns nothing.
 */
typedef void (^AYSuccessBlock)();

/*
 Block parameter expected for a success response which returns an 'NSDictionary'.
 */
typedef void (^AYResultSuccessBlock)(NSDictionary *result);

/*
 Block parameter expected for a failure response which returns a 'AYError'.
 */
typedef void (^AYFailureBlock)(AYError *error);