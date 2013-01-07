//
//  APUser.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 07/01/13.
//  Copyright (c) 2013 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APResponseBlocks.h"
#import "APObject.h"
#import "APUserDetails.h"

@interface APUser : APObject

@property (nonatomic, strong, readonly) NSString *userToken;

+ (APUser*) currentUser;

+ (void) setCurrentUser:(APUser*) user;

+ (void) authenticateUserWithUserName:(NSString*) userName password:(NSString*) password successHandler:(APSuccessBlock) successBlock;

+ (void) authenticateUserWithUserName:(NSString*) userName password:(NSString*) password successHandler:(APSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

+ (void) authenticateUserWithFacebook:(NSString *) accessToken successHandler:(APSuccessBlock) successBlock;

+ (void) authenticateUserWithFacebook:(NSString *) accessToken successHandler:(APSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

+ (void) authenticateUserWithTwitter:(NSString*) oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APSuccessBlock) successBlock;

+ (void) authenticateUserWithTwitter:(NSString*) oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APSuccessBlock)successBlock;

+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

+ (void) createUserWithDetails:(APUserDetails *)userDetails successHandler:(APUserSuccessBlock) successBlock;

+ (void) createUserWithDetails:(APUserDetails *)userDetails successHandler:(APUserSuccessBlock) successBlock failuderHandler:(APFailureBlock) failureBlock;
@end
