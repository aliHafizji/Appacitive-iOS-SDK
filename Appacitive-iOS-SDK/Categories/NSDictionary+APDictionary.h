//
//  NSDictionary+APDictionary.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 25/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

/**
 Provides useful additions to the NSDictionary interface.
 */
@interface NSDictionary (APDictionary)

/**
 Returns a representation of the dictionary as a URLEncoded string
 
 @returns A UTF-8 encoded string representation of the keys/values in the dictionary
 */
- (NSString *)stringWithURLEncodedEntries;
@end
