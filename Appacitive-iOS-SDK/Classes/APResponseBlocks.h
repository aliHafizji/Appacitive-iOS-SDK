//
//  APResponseBlocks.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@class APError, APUser, UIImage, APConnection;

/**
 Success block that returns nothing.
 */
typedef void (^APSuccessBlock)();

/**
 Block parameter expected for a success response which returns an 'NSDictionary'.
 */
typedef void (^APResultSuccessBlock)(NSDictionary *result);

/**
 Block parameter expected for a success response. It returns an array of APObjects
 */
typedef void (^APObjectsSuccessBlock)(NSArray *array);

/**
 Block parameter expected for a success response. It returns an APConnection.
 */
typedef void (^APConnectionSuccessBlock)(APConnection *connection);

/**
 Block parameter expected for a success response. It returns an array of APConnections
 */
typedef void (^APConnectionsSuccessBlock)(NSArray *array);

/**
 Block parameter expected for a success response which returns a 'NSData'.
 */
typedef void (^APFileDownloadSuccessBlock)(NSData *data);

/**
 Block parameter expected for a failure response which returns a 'AYError'.
 */
typedef void (^APFailureBlock)(APError *error);

/**
 Block parameter expected for a success response which returns a 'APUser'.
 */
typedef void (^APUserSuccessBlock)(APUser* user);

/**
 Block parameter expected for image download
 */
typedef void (^APImageBlock) (UIImage* fetchedImage, NSURL* url, BOOL isInCache);

/**
 * Block parameter for getting download url of a file
 */
typedef void (^APFileDownloadUrlBlock) (NSString *url);

