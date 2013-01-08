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

/**
 Returns the current authenticated user.
 
 @return APUser or nil
 */
+ (APUser*) currentUser;

/**
 Helper method to set the current user.
 
 @param user The new current user
 */
+ (void) setCurrentUser:(APUser*) user;

/** @name Authenticating a user */

/**
 @see authenticateUserWithUserName:password:successHandler:failureHandler
 */
+ (void) authenticateUserWithUserName:(NSString*) userName password:(NSString*) password successHandler:(APSuccessBlock) successBlock;

/**
 Method to authenticate a user
 
 If successful the currentUser is set to the authenticated user.
 
 @param userName The username of the user to authenticate.
 @param password The password of the user to authenticate.
 @param successBlock Block invoked when authentication is successful.
 @param failureBlock Block invoked when authentication is unsuccessful.
 */
+ (void) authenticateUserWithUserName:(NSString*) userName password:(NSString*) password successHandler:(APSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see authenticateUserWithFacebook:successHandler:failureHandler:
 */
+ (void) authenticateUserWithFacebook:(NSString *) accessToken successHandler:(APSuccessBlock) successBlock;

/**
 Method to authenticate a user with facebook.
 
 If successful the currentUser is set to the authenticated user.
 
 @param accessToken The access token retrieved after a succesful facebook login.
 @param successBlock Block invoked when authentication with facebook is successful.
 @param failureBlock Block invoked when authentication with facebook is unsuccessful.
 */
+ (void) authenticateUserWithFacebook:(NSString *) accessToken successHandler:(APSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see authenticateUserWithTwitter:oauthSecret:successHandler:failureHandler:
 */
+ (void) authenticateUserWithTwitter:(NSString*) oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APSuccessBlock) successBlock;

/**
 Method to authenticate a user with Twitter.
 
 If successful the currentUser is set to the authenticated user.
 
 @param oauthToken The oauth token retrieved after twitter login.
 @param oauthSecret The oauth secret.
 @param successBlock Block invoked when login with twitter is successful.
 @param failureBlock Block invoked when login with twitter is unsuccessful.
 */
+ (void) authenticateUserWithTwitter:(NSString*) oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see authenticateUserWithTwitter:oauthSecret:consumerKey:consumerSecret:successHandler:failureHandler:
 */
+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APSuccessBlock)successBlock;

/**
 Method to authenticate a user with Twitter.
 
 If successful the currentUser is set to the authenticated user.
 
 @param oauthToken The oauth token retrieved after twitter login.
 @param oauthSecret The oauth secret.
 @param consumerKey The consumer key of the application created on twitter.
 @param consumerSecret The consumer secret of the application created on twitter.
 @param successBlock Block invoked when authentication with twitter is successful.
 @param failureBlock Block invoked when authentication with twitter is unsuccessful.
 */
+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Create a new user */

/**
 @see createUserWithDetails:successHandler:failuderHandler:
 */
+ (void) createUserWithDetails:(APUserDetails *)userDetails successHandler:(APUserSuccessBlock) successBlock;

/**
 Method to create a new user
 
 If successful the an object of APUser is returned in the successBlock.
 
 @note This method does not set the current user as the new user.
 
 @param userDetails The details of the new user.
 @param successBlock Block invoked when the create request is successful.
 @param failureBlock Block invoked when the create request is unsuccessful.
 */
+ (void) createUserWithDetails:(APUserDetails *)userDetails successHandler:(APUserSuccessBlock) successBlock failuderHandler:(APFailureBlock) failureBlock;
@end
