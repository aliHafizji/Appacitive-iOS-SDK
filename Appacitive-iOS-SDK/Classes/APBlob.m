//
//  APBlob.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 10/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APBlob.h"
#import "Appacitive.h"
#import "APHelperMethods.h"
#import "APError.h"

@implementation APBlob

+ (void) uploadFileWithName:(NSString*)fileName mimeType:(NSString*)mimeType {
    [APBlob uploadFileWithName:fileName mimeType:mimeType successHandler:nil failureHandler:nil];
}

+ (void) uploadFileWithName:(NSString *)fileName mimeType:(NSString*)mimeType successHandler:(APResultSuccessBlock)successBlock {
    [APBlob uploadFileWithName:fileName mimeType:mimeType successHandler:successBlock failureHandler:nil];
}

+ (void) uploadFileWithName:(NSString*)fileName mimeType:(NSString*)mimeType successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APBlob uploadFileWithName:fileName mimeType:mimeType uploadProgressBlock:nil successHandler:successBlock failureHandler:failureBlock];
}
 
+ (void) uploadFileWithName:(NSString*)fileName mimeType:(NSString*)mimeType uploadProgressBlock:(MKNKProgressBlock)uploadProgressBlock successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject) {
        NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"blob?deploymentId=%@", sharedObject.deploymentId];
        path = [path stringByAppendingFormat:@"&session=%@", sharedObject.session];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:urlEncodedPath params:nil httpMethod:@"POST"];
        [op addFile:fileName forKey:@"fileUpload" mimeType:mimeType];
        
        [op onUploadProgressChanged:^(double progress) {
            DLog(@"Download progress:%lf", progress);
            if (uploadProgressBlock != nil) {
                uploadProgressBlock(progress);
            }
        }];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation){
            DLog(@"%@", completedOperation.responseJSON);
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock != nil) {
                    successBlock(completedOperation.responseJSON);
                }
            } else {
                DLog(@"%@", error.description);
            }
        } onError:^(NSError *error) {
            DLog(@"%@", error.description);
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

+ (void) downloadFileFromRemoteUrl:(NSString*)url toFile:(NSString*)fileName {
    [APBlob downloadFileFromRemoteUrl:url toFile:fileName successHandler:nil failureHandler:nil];
}

+ (void) downloadFileFromRemoteUrl:(NSString *)url toFile:(NSString *)fileName successHandler:(APSuccessBlock)successBlock {
    [APBlob downloadFileFromRemoteUrl:url toFile:fileName successHandler:successBlock failureHandler:nil];
}

+ (void) downloadFileFromRemoteUrl:(NSString*)url toFile:(NSString*)fileName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APBlob downloadFileFromRemoteUrl:url toFile:fileName downloadProgressBlock:nil successHandler:successBlock failureHandler:failureBlock];
}

+ (void) downloadFileFromRemoteUrl:(NSString*)url toFile:(NSString *)fileName downloadProgressBlock:(MKNKProgressBlock)downloadProgressBlock successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject) {
        NSString *urlWithSession = [NSString stringWithFormat:@"%@?session=%@", url, sharedObject.session];
        NSString *urlEncodedPath = [urlWithSession stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedObject operationWithURLString:urlEncodedPath];
        [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:fileName append:YES]];
        
        [op onDownloadProgressChanged:^(double progress) {
            DLog(@"Download progress:%lf", progress);
            
            if (downloadProgressBlock != nil) {
                downloadProgressBlock(progress);
            }
        }];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation){
            DLog(@"%@", completedOperation.description);
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock != nil) {
                    successBlock();
                }
            } else {
                DLog(@"%@", error.description);
            }
        } onError:^(NSError *error){
            DLog(@"%@", error.description);
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate")
    }
}
@end
