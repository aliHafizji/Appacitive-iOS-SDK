#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"
#import "APBlob.h"

SPEC_BEGIN(APBlobTests)

describe(@"APBlobTests", ^{
    
    beforeAll(^() {
        __block Appacitive *appacitive = [Appacitive appacitiveWithApiKey:API_KEY];
        [[Appacitive sharedObject] setEnableLiveEnvironment:NO];
        [[expectFutureValue(appacitive.session) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
    });
    
    afterAll(^(){
        [Appacitive setSharedObject:nil];
    });
    
#pragma mark UPLOAD_TESTS
    
    it(@"should not return an error for uploading a file with a valid mime type", ^{
        __block BOOL isUploadSuccessful = NO;
        
        NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
        NSString *uploadPath = [myBundle pathForResource:@"test_image" ofType:@"png"];
        [APBlob uploadFileWithName:uploadPath mimeType:@"image/png"
               uploadProgressBlock:^(double progress) {
                   NSLog(@"Progress made %f", progress);
               } successHandler:^(NSDictionary *result) {
                   isUploadSuccessful = YES;
               } failureHandler:^(APError *error) {
                   isUploadSuccessful = NO;
               }];
        [[expectFutureValue(theValue(isUploadSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
#pragma mark DOWNLOAD_TESTS
    
    it(@"should not return an error for downloading a file with a valid url", ^{
        __block BOOL isDownloadSuccesful = NO;
        
        
        [APBlob downloadFileFromRemoteUrl:@""
                toFile:@"tempfile"
                downloadProgressBlock:^(double progress) {
                    NSLog(@"Download progress %f", progress);
                } successHandler:^() {
                    isDownloadSuccesful = YES;
                } failureHandler:^(APError *error){
                    isDownloadSuccesful = NO;
                }];
        
        [[expectFutureValue(theValue(isDownloadSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should not return an error for downloading a valid image", ^{
        __block BOOL isDownloadSuccesful = NO;
        
        
        [APBlob downloadImageFromRemoteUrl:@"https://portal.appacitive.com/dealfinder/article.file?fileurl=http%3A//apis.appacitive.com/articleservice.svc/blob/14530713013584212/15702745784910084/content"
                successHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                    isDownloadSuccesful = YES;
                }];
        
        [[expectFutureValue(theValue(isDownloadSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
});
SPEC_END