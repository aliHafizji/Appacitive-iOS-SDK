//
//  APUserDetails.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 07/01/13.
//  Copyright (c) 2013 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APUserDetails : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *secretQuestion;
@property (nonatomic, strong) NSString *secretAnswer;
@property (nonatomic, strong) NSString *phone;

- (NSMutableDictionary*) createParameters;
@end
