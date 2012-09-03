//
//  AYHelperMethods.h
//  WhereIGo
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@class AYError;
@interface AYHelperMethods : NSObject

/**
 Helper method used to check for any errors.
 
 @param response Response received from the server.
 */
+ (AYError*) checkForErrorStatus:(id)response;
@end
