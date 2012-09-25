//
//  APHelperMethods.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@class APError;
@interface APHelperMethods : NSObject

#define NSStringFromBOOL(aBOOL) aBOOL ? @"YES" : @"NO"

/**
 Helper method used to check for any errors.
 
 @param response Response received from the server.
 */
+ (APError*) checkForErrorStatus:(id)response;
@end
