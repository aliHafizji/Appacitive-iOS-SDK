//
//  APObject.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APResponseBlocks.h"

@class APError;

extern NSString *const ARTICLE_PATH;

/**
 An APObject is a basic unit to store information in.
 It represents an instance of a schema. 
 Data can be stored in key-value pairs in the properties and attributes fields.
 */
@interface APObject : NSObject

@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong, readonly) NSString *lastModifiedBy;
@property (nonatomic, strong, readonly) NSDate *utcDateCreated;
@property (nonatomic, strong, readonly) NSDate *utcLastUpdatedDate;
@property (nonatomic, strong, readonly) NSNumber *revision;
@property (nonatomic, strong, readonly) NSMutableArray *properties;
@property (nonatomic, strong, readonly) NSMutableArray *attributes;
@property (nonatomic, strong) NSNumber *schemaId;
@property (nonatomic, strong) NSString *schemaType;
@property (nonatomic, strong) NSArray *tags;

/** @name Getting the APObject */

/**
 Initialize and return an autoreleased APObject for the provided schema name.
 
 @param schemaName The schema this article represents.
 */
+ (id) objectWithSchemaName:(NSString*)schemaName;

/**
 Initialize and return an autoreleased APObject for the provided schema name.
 
 @param schemaName The schema this article represents.
 */
- (id) initWithSchemaName:(NSString*)schemaName;

/** @name Searching for APObjects */

/**
 @see searchAllObjectsWithSchemaName:successHandler:failureHandler:
 */
+ (void) searchAllObjectsWithSchemaName:(NSString*) schemaName successHandler:(APResultSuccessBlock)successHandler;

/**
 Searches for all APObjects of a particular schema.
 
 @param schemaName The schema that the objects should belong to.
 @param successHandler Block invoked when the search call is successful.
 @param failureBlock Block invoked when search call fails.
 */
+ (void) searchAllObjectsWithSchemaName:(NSString*) schemaName successHandler:(APResultSuccessBlock)successHandler failureHandler:(APFailureBlock)failureBlock;

/**
 @see searchObjectsWithSchemaName:withQueryString:successHandler:failureHandler:
 */
+ (void) searchObjectsWithSchemaName:(NSString*)schemaName withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock;

/**
 Searches for APObjects and filters the results according to the query string.
 
 @param schemaName The schema of the objects you want to search.
 @param queryString SQL kind of query to search for specific objects. For more info http://appacitive.com
 @param successHandler Block invoked when the search call is successful.
 @param failureHandler Block invoked when the search call fails.
 */
+ (void) searchObjectsWithSchemaName:(NSString*)schemaName withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Deleting APObjects */

/**
 @see deleteObjectsWithIds:schemaName:successHandler:failureHandler:
 */
+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName failureHandler:(APFailureBlock)failureBlock;

/**
 Deletes multiple APObjects.
 
 @param objectIds The ids of the objects to delete.
 @param schemaName The schema that the objects belong to.
 @param successBlock Block invoked when the multi delete operation succeeds.
 @param failureBlock Block invoked when the multi delete operation fails.
 */
+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see deleteObjectWithSuccessHandler:failureHandler:
 */
- (void) deleteObject;

/**
 @see deleteObjectWithSuccessHandler:failureHandler:
 */
- (void) deleteObjectWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Deletes and APObject.
 
 This method will delete the object on the remote server. It will not nullify the current properties or attributes.
 
 @param successBlock Block invoked when delete operation is successful
 @param failureBlock Block invoked when delete operation fails.
 */
- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Fetch APObjects */

/**
 @see fetchObjectsWithObjectIds:schemaName:successHandler:failureHandler:
 */
+ (void) fetchObjectWithObjectId:(NSNumber*)objectId schemaName:(NSString*)schemaName successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Retrieves multiple APObjects of a particular schema.
 
 @param objectIds The ids of the objects.
 @param schemaName The schema name the objects belong to.
 @param successBlock Block invoked when the retrieve operation succeeds.
 @param failureBlock Block invoked when the failure operation succeeds.
 */
+ (void) fetchObjectsWithObjectIds:(NSArray*)objectIds schemaName:(NSString *)schemaName successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see fetchWithFailureHandler:
 */
- (void) fetch;

/**
 Method used to fetch an APObject.
 
 This method will use the schemaType and objectId properties to fetch the article. If the objectId and schemaType is not set, results are unexpected.
 
 @param failureBlock Block invoked when the fetch operation fails.
 
 */
- (void) fetchWithFailureHandler:(APFailureBlock)failureBlock;

/** @name Methods to store key-value pairs */

/**
 Method used to add a property to the APObject.

 @param keyName key of the data item to be stored.
 @param object Corresponding value to the key.
 */
- (void) addPropertyWithKey:(NSString*) keyName value:(id) object;

/**
 Method used to add an attibute to the APObject.
 Attributes are used to store extra information.
 
 @param keyName key of the data item to be stored.
 @param object Corresponding value to the key.
 */
- (void) addAttributeWithKey:(NSString*) keyName value:(id) object;

/** @name Save APObjects */

/**
 @see saveObjectWithSuccessHandler:failureHandler:
 */
- (void) saveObject;

/**
 @see saveObjectWithSuccessHandler:failureHandler:
 */
- (void) saveObjectWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Save the article on the remote server.
 
 This method will save an article in the background. If save is successful the properties will be updated and the successBlock will be invoked. If not the failure block is invoked.
 
 @param successBlock Block invoked when the save operation is successful
 @param failureBlock Block invoked when the save operation fails.
 
 */
- (void) saveObjectWithSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Apply graph queries */

/**
 @see applyFilterGraphQuery:successHandler:failureHandler:
 */
+ (void) applyFilterGraphQuery:(NSString*)query successHandler:(APResultSuccessBlock)successBlock;

/**
 Searches for APObjects that satisfy the filter graph query.
 
 A filter query is a kind that does not have a starting point in the graph. All the APObjects that satisfy the query will be returned. To know more visit http://wwww.appacitive.com
 
 @param query A string representing the filter graph query.
 @param successBlock Block invoked when query is successfully executed.
 @param failureBlock Block invoked when query execution fails.
 */
+ (void) applyFilterGraphQuery:(NSString*)query successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see applyProjectionGraphQuery:successHandler:failureHandler:
 */
+ (void) applyProjectionGraphQuery:(NSString*)query successHandler:(APResultSuccessBlock)successBlock;

/**
 Searches for APObjects that satisfy the projection graph query.
 
 A projection query will search for results from a starting node in the graph. To know more visit http://wwww.appacitive.com
 
 @param query A string representing the projection graph query.
 @param successBlock Block invoked when query is successfully executed.
 @param failureBlock Block invoked when query execution fails.
 */
+ (void) applyProjectionGraphQuery:(NSString *)query successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;
@end
