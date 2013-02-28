#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"
#import "APFile.h"

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
        NSData *myData = [NSData dataWithContentsOfFile:uploadPath];
    
        [APFile uploadFileWithName:@"Image2"
                    data:myData
                    validUrlForTime:@10
                    contentType:@"image/png"
                    successHandler:^(NSDictionary *dictionary){
                        isUploadSuccessful = YES;
                    } failureHandler:^(APError *error){
                        isUploadSuccessful = NO;
            }];
        [[expectFutureValue(theValue(isUploadSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should not return an error for uploading a file with a valid property name and existing object", ^{
        __block BOOL isUploadSuccessful = NO;
        
        NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
        NSString *uploadPath = [myBundle pathForResource:@"test_image" ofType:@"png"];
        NSData *myData = [NSData dataWithContentsOfFile:uploadPath];
        APObject *taskObject = [APObject objectWithSchemaName:@"Tasks"];
        [taskObject addPropertyWithKey:@"text" value:@"Test file upload"];
        [taskObject saveObjectWithSuccessHandler:^(){
            [APFile uploadFileWithName:@"Image2" data:myData contentType:@"image/png" withProperty:@"url" forObject:taskObject successHandler:^(NSString * url){
                isUploadSuccessful = YES;
            } failureHandler:^(APError * error){
                isUploadSuccessful = NO;
            }];
        } failureHandler:^(APError *error){
            isUploadSuccessful = NO;
        }];
        [[expectFutureValue(theValue(isUploadSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
#pragma mark DOWNLOAD_TESTS
    it(@"should not return an error for downloading a file with a valid url", ^{
            __block BOOL isDownloadSuccesful = NO;
    
    [APFile downloadFileWithName:@"Image2" validUrlForTime:@10 successHandler:^(NSData *data) {
            isDownloadSuccesful = YES;
        } failureHandler:^(APError *error) {
            isDownloadSuccesful = NO;
        }];
     [[expectFutureValue(theValue(isDownloadSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
#pragma mark GET_DOWNLOAD_URL_TESTS
    
    it(@"should not return an error for downloading file with a valid file name", ^{
        __block BOOL isDownloadSuccessful = NO;
        
        [APFile getLongLastingPublicDownloadUrlForFile:@"Image2" successHandler:^(NSString * url) {
            isDownloadSuccessful = YES;
        } failureHandler:^(APError *error) {
            isDownloadSuccessful = NO;
        }];
        [[expectFutureValue(theValue(isDownloadSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
});
SPEC_END