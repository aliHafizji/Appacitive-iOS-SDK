#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"
#import "APFile.h"

SPEC_BEGIN(APBlobTests)

//describe(@"APBlobTests", ^{
//    
//    beforeAll(^() {
//        __block Appacitive *appacitive = [Appacitive appacitiveWithApiKey:@"ukaAo61yoZoeTJsGacH9TDRHnhf/J9/kH2TStR5sD3k="];
//        [[Appacitive sharedObject] setEnableLiveEnvironment:NO];
//        [[expectFutureValue(appacitive.session) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
//    });
//    
//    afterAll(^(){
//        [Appacitive setSharedObject:nil];
//    });
//    
//#pragma mark UPLOAD_TESTS
//    
//    it(@"should not return an error for uploading a file with a valid mime type", ^{
//        __block BOOL isUploadSuccessful = NO;
//        
//        NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
//        NSString *uploadPath = [myBundle pathForResource:@"test_image" ofType:@"png"];
//        NSData *myData = [NSData dataWithContentsOfFile:uploadPath];
//        
//        [APFile uploadFileWithName:@"Image2"
//                data:myData
//                validUrlForTime:@10
//                contentType:@"image/png"
//                successHandler:^(NSDictionary *dictionary){
//                    NSLog(@"%@", dictionary.description);
//                    isUploadSuccessful = YES;
//                } failureHandler:^(APError *error){
//                    isUploadSuccessful = NO;
//                }];
//        [[expectFutureValue(theValue(isUploadSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
//    });
//    
//#pragma mark DOWNLOAD_TESTS
//    
//    it(@"should not return an error for downloading a file with a valid url", ^{
//        __block BOOL isDownloadSuccesful = NO;
//        
//        [APFile downloadFileWithName:@"Image2" validUrlForTime:@10 successHandler:^(NSData *data) {
//            isDownloadSuccesful = YES;
//        } failureHandler:^(APError *error) {
//            isDownloadSuccesful = NO;
//        }];
//        
//        [[expectFutureValue(theValue(isDownloadSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
//    });
//});
SPEC_END