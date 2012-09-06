//
//  APResponseBlocks.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@class APError;

/**
 Success block that returns nothing.
 */
typedef void (^APSuccessBlock)();

/**
 Block parameter expected for a success response which returns an 'NSDictionary'.
 */
typedef void (^APResultSuccessBlock)(NSDictionary *result);

/**
 Block parameter expected for a failure response which returns a 'AYError'.
 */
typedef void (^APFailureBlock)(APError *error);