#import "Appacitive.h"
#import "APError.h"
#import "APUserDetails.h"
#import "APUser.h"

SPEC_BEGIN(APUserTests)

describe(@"APUserTests", ^{
    
    beforeAll(^() {
        __block Appacitive *appacitive = [Appacitive appacitiveWithApiKey:API_KEY];
        [[expectFutureValue(appacitive.session) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
    });
    
    afterAll(^(){
        [Appacitive setSharedObject:nil];
    });
    
#pragma mark AUTHENTICATE_TEST
    
    it(@"should not return an error for retrieving a user with a valid user id", ^{
        __block BOOL isUserAuthenticateSuccesful = NO;

        [APUser authenticateUserWithUserName:@"ali"
                password:@"coolkid1"
                successHandler:^() {
                    isUserAuthenticateSuccesful = YES;
                } failureHandler:^(APError *error) {
                    isUserAuthenticateSuccesful = NO;
                }];
        [[expectFutureValue(theValue(isUserAuthenticateSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    /*
    it(@"should not return an error for authenticating with a valid facebook id", ^{
        __block BOOL isUserAuthenticateSuccesful = NO;

        [APUser authenticateUserWithFacebook:@"AAAERnfCZC8cUBAGwzBczWQy5jhWCeHxpSP2eCx8ULI2TQixtJYwG3XcWCLAIxyZC1UbUQ64uhQzdIhIRZBsFnp6CS8YqBym9UhqMexfsQZDZD"
                        successHandler:^(){
                            isUserAuthenticateSuccesful = YES;
                        } failureHandler:^(APError* error) {
                            isUserAuthenticateSuccesful = NO;
                        }];
        [[expectFutureValue(theValue(isUserAuthenticateSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should not return an error for authenticating with a valid twitter oauth token and oauth secret", ^{
        __block BOOL isUserAuthenticateSuccesful = NO;
        
        [APUser authenticateUserWithTwitter:@"146178332-TjFecTBsmZpFDHHHvbVwVr58if0kMz4vL0oJ0rM1"
                oauthSecret:@"nk8RUYqrKbV4kFFbD0kYNGsadm1iE8ek8BpRQQx3U"
                successHandler:^(){
                    isUserAuthenticateSuccesful = YES;
                } failureHandler:^(APError *error) {
                    isUserAuthenticateSuccesful = NO;
                }];
        
        [[expectFutureValue(theValue(isUserAuthenticateSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should not return an error for authenticating with a valid twitter oauth token, oauth secret, consumer key and consumer secret", ^{
        __block BOOL isUserAuthenticateSuccesful = NO;
        
        [APUser authenticateUserWithTwitter:@"146178332-TjFecTBsmZpFDHHHvbVwVr58if0kMz4vL0oJ0rM1"
                                oauthSecret:@"nk8RUYqrKbV4kFFbD0kYNGsadm1iE8ek8BpRQQx3U"
                                consumerKey:@"dEq8N6RdlV4OrII7dWJjQ"
                                consumerSecret:@"W1DEUIPgRXzcueGkCJOGKcYsE5a3YTNHMah6zFurgA"
                                successHandler:^(){
                                    isUserAuthenticateSuccesful = YES;
                                } failureHandler:^(APError *error) {
                                    isUserAuthenticateSuccesful = NO;
                                }];
        
        [[expectFutureValue(theValue(isUserAuthenticateSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

#pragma mark CREATE_USER
    
    
    it(@"should not return an error for creating a user", ^{
        __block BOOL isUserCreated = NO;
        
        APUserDetails *userDetails = [[APUserDetails alloc] init];
        userDetails.username = @"test11";
        userDetails.birthDate = @"1982-11-17";
        userDetails.firstName = @"giles";
        userDetails.lastName = @"giles";
        userDetails.email = @"giles@test.com";
        userDetails.secretQuestion = @"hello";
        userDetails.secretAnswer = @"hello";
        userDetails.password = @"test123";
        userDetails.phone = @"1234";
        
        [APUser createUserWithDetails:userDetails
                successHandler:^(APUser* user) {
                    isUserCreated = YES;
                } failuderHandler:^(APError* error) {
                    isUserCreated = NO;
                }];
        [[expectFutureValue(theValue(isUserCreated)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
*/    
});
SPEC_END