//
//  APFile.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 10/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "MKNetworkKit.h"
#import "APObject.h"

@class APResponceBlocks;

@interface APFile : APObject

/** @name Uploading data methods */

/**
 @see uploadFileWithName:data:validUrlForTime:contentType:successHandler:failureHandler:
 */
+ (void)uploadFileWithName:(NSString*)name data:(NSData*)data validUrlForTime:(NSNumber*)minutes;

/**
 @see uploadFileWithName:data:validUrlForTime:contentType:successHandler:failureHandler:
 */
+ (void)uploadFileWithName:(NSString*)name data:(NSData*)data validUrlForTime:(NSNumber*)minutes contentType:(NSString*)contentType;

/**
 @see uploadFileWithName:data:validUrlForTime:contentType:successHandler:failureHandler:
 */
+ (void)uploadFileWithName:(NSString *)name data:(NSData *)data validUrlForTime:(NSNumber*)minutes contentType:(NSString*)contentType successHandler:(APResultSuccessBlock)successBlock;

/**
 Method used to upload data to the remote server
 
 @param name The name of the file
 @param data Data that you want to upload
 @param minutes The time for which the upload url will be valid. If the file size is big make sure to set the value to a large amount
 @param contentType The mimetype of the data being uploaded
 @param successBlock Block invoked when upload is successful
 @param failureBlock Block invoked when upload fails
 */
+ (void)uploadFileWithName:(NSString *)name data:(NSData *)data validUrlForTime:(NSNumber*)minutes contentType:(NSString*)contentType successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Method used to upload data to the remote server
 
 @param name The name of the file
 @param data Data that you want to upload
 @param minutes The time for which the upload url will be valid. If the file size is big make sure to set the value to a large amount
 @param contentType The mimetype of the data being uploaded
 @param propertyName The property name of the saved object for which the download url needs to be persisted
 @param object The APObject for which the file is to be uploaded
 @param successBlock Block invoked when upload is successful
 @param failureBlock Block invoked when upload fails
 */
+ (void) uploadFileWithName:(NSString *)name data:(NSData *)data contentType:(NSString *)contentType withProperty:(NSString *) propertyName forObject:(APObject *)object successHandler:(APFileDownloadUrlBlock)successBlock failureHandler:(APFailureBlock)failureBlock;
/**
 @see downloadFileWithName:validUrlForTime:successHandler:failureHandler:
 */
+ (void) downloadFileWithName:(NSString*)name validUrlForTime:(NSNumber*)minutes successHandler:(APFileDownloadSuccessBlock) successBlock;

/**
 Method used to download data from the remote server
 
 @param name The name of the file you want to download
 @param minutes The time for which the download url will be valid
 @param successBlock Block invoked when download is successful
 @param failureBlock Block invoked when download fails
 */
+ (void) downloadFileWithName:(NSString*)name validUrlForTime:(NSNumber*)minutes successHandler:(APFileDownloadSuccessBlock) successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Method used to get the download url for valid filename
 
 @param name The name of the file you want to download
 @param minutes The time for which the download url will be valid
 @param successBlock Block invoked when download is successful
 @param failureBlock Block invoked when download fails
 */
+ (void) getLongLastingPublicDownloadUrlForFile: (NSString *) fileName successHandler: (APFileDownloadUrlBlock) successBlock failureHandler: (APFailureBlock) failureBlock;
@end
