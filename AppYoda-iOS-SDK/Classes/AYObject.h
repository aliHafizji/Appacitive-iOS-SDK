//
//  AYObject.h
//  AYoda-iOS example
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "AYResponseBlocks.h"

@class AYError;

@interface AYObject : NSObject

@property (nonatomic, strong, readonly) NSString *createdBy;
@property (nonatomic, strong, readonly) NSNumber *objectId;
@property (nonatomic, strong, readonly) NSString *lastUpdatedBy;
@property (nonatomic, strong, readonly) NSDate *utcDateCreated;
@property (nonatomic, strong, readonly) NSDate *utcLastUpdatedDate;
@property (nonatomic, strong, readonly) NSNumber *revision;

@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, strong) NSNumber *schemaId;
@property (nonatomic, strong) NSString *schemaType;
@property (nonatomic, strong) NSArray *tags;

+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName failureHandler:(AYFailureBlock)failureBlock;
+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName successHandler:(AYSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock;

+ (void) fetchObjectWithObjectId:(NSNumber*)objectId schemaName:(NSString*)schemaName successHandler:(AYResultSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock;
+ (void) fetchObjectsWithObjectIds:(NSArray*)objectIds schemaName:(NSString *)schemaName successHandler:(AYResultSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock;

// create an object of a particular schema type NOTE: This is not synonimous to an article
+ (id) objectWithSchemaName:(NSString*)schemaName;
- (id) initWithSchemaName:(NSString*)schemaName;

// save an Object
- (void) saveObject;
- (void) saveObjectWithFailureHandler:(AYFailureBlock)failureBlock;
- (void) saveObjectWithSuccessHandler:(AYSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock;
- (void) saveObjectWithFullSuccessHandler:(AYFullResponseSuccessBlock)fullResponseSuccessBlock fullFailureHandler:(AYFullResponseFailureBlock)fullFailureBlock;

// deleting objects
- (void) deleteObject;
- (void) deleteObjectWithFailureHandler:(AYFailureBlock)failureBlock;
- (void) deleteObjectWithSuccessHandler:(AYSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock;

// fetch methods
- (void) fetch;
- (void) fetchWithFailureHandler:(AYFailureBlock)failureBlock;
@end
