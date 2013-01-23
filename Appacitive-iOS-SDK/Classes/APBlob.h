//
//  APBlob.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 10/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "MKNetworkKit.h"
#import "APObject.h"

@class APResponceBlocks;

@interface APBlob : APObject

/**
 @see uploadFileWithName:mimeType:successHandler:
 */
+ (void) uploadFileWithName:(NSString*)fileName mimeType:(NSString*)mimeType;

/**
 Helper method to upload a file to the remote server.
 
 @param fileName The file name with the path to upload.
 @param mimeType Mime type of the file being uploaded.
 @param successBlock Block invoked when upload is successful. It will return an article.
 */
+ (void) uploadFileWithName:(NSString *)fileName mimeType:(NSString*)mimeType successHandler:(APResultSuccessBlock)successBlock;

/**
 Helper method to upload a file to the remote server.
 
 @param fileName The file name with the path to upload.
 @param mimeType Mime type of the file being uploaded.
 @param successBlock Block invoked when upload is successful. It will return an article.
 @param failureBlock Block invoked when upload fails.
 */
+ (void) uploadFileWithName:(NSString*)fileName mimeType:(NSString*)mimeType successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Helper method to upload a file to the remote server.
 
 @param fileName The file name with the path to upload.
 @param mimeType Mime type of the file being uploaded.
 @param uploadProgressBlock Block invoked when upload progress changes.
 @param successBlock Block invoked when upload is successful. It will return an article.
 @param failureBlock Block invoked when upload fails.
 */
+ (void) uploadFileWithName:(NSString*)fileName mimeType:(NSString*)mimeType uploadProgressBlock:(MKNKProgressBlock)uploadProgressBlock successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see downloadFileFromRemoteUrl:toFile:successHandler:failureHandler:
 */
+ (void) downloadFileFromRemoteUrl:(NSString*)url toFile:(NSString*)fileName;

/**
 @see downloadFileFromRemoteUrl:toFile:successHandler:failureHandler:
 */
+ (void) downloadFileFromRemoteUrl:(NSString*)url toFile:(NSString *)fileName successHandler:(APSuccessBlock)successBlock;

/**
 Helper method to download a file from the remote server.
 
 @param url URL string pointing to the remote file.
 @param fileName The file with the path to download to.
 @param successBlock Block invoked when download is successful.
 @param failureBlock Block invoked when download fails.
 */
+ (void) downloadFileFromRemoteUrl:(NSString*)url toFile:(NSString*)fileName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Helper method to download a file from the remote server.
 
 @param url URL string pointing to the remote file.
 @param fileName The file with the path to download to.
 @param downloadProgressBlock Block invoked when the download progress changes.
 @param successBlock Block invoked when download is successful.
 @param failureBlock Block invoked when download fails.
 */
+ (void) downloadFileFromRemoteUrl:(NSString*)url toFile:(NSString *)fileName downloadProgressBlock:(MKNKProgressBlock)downloadProgressBlock successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Helper method to download a image from the remote server
 
 @param imageUrl url of the image to download
 @param successBlock block called when the image is downloaded. This block give a UIImage the and also give information on whether the image was downloaded or served from the image cache.
 */
+ (void) downloadImageFromRemoteUrl:(NSString*)imageUrl successHandler:(APImageBlock)successBlock;
@end
