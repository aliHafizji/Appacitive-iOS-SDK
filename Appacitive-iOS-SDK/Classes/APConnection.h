//
//  APConnection.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd.. All rights reserved.
//

#import "APResponseBlocks.h"

@class APObject;

/**
 A Connection is represents an edge in a graph and is used to connect two APObjects.
 A Connection itself can store data in its properties and attributes fields.
 */
@interface APConnection : NSObject

@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSNumber *articleAId;
@property (nonatomic, strong) NSNumber *articleBId;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSString *labelA;
@property (nonatomic, strong) NSString *labelB;
@property (nonatomic, strong) NSNumber *relationId;
@property (nonatomic, strong) NSString *relationType;
@property (nonatomic, strong, readonly) NSString *lastModifiedBy;
@property (nonatomic, strong, readonly) NSDate *utcDateCreated;
@property (nonatomic, strong, readonly) NSDate *utcLastModifiedDate;
@property (nonatomic, strong, readonly) NSNumber *revision;
@property (nonatomic, strong, readonly) NSMutableArray *properties;
@property (nonatomic, strong, readonly) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSArray *tags;

/** @name Getting the APConnection */

/**
 Initialize and return an APConnection for the provided relation type.
 
 @param relationType The name of the relation. This is specified while creating the schema.
 */
+ (id) connectionWithRelationType:(NSString*)relationType;

/**
 Initialize and return an APConnection for the provided relation type.
 
 @param relationType The name of the relation. This is specified while creating the schema.
 */
- (id) initWithRelationType:(NSString*)relationType;

/** @name Searching for APConnections */

/**
 @see searchForAllConnectionsWithRelationType:successHandler:failureHandler:
 */
+ (void) searchForAllConnectionsWithRelationType:(NSString*)relationType successHandler:(APResultSuccessBlock)successBlock;

/**
 Search for all APConnections of a particular relation type.
 
 @param relationType The relation type that the connections should belong to.
 @param successBlock Block invoked when the search call is successful.
 @param failureBlock Block invoked when the search call fails.
 */
+ (void) searchForAllConnectionsWithRelationType:(NSString*)relationType successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see searchForConnectionsWithRelationType:withQueryString:successHandler:failureHandler:
 */
+ (void) searchForConnectionsWithRelationType:(NSString*)relationType withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock;

/**
 Searches for APConnections and filters the result according to the query provided.
 
 @param relationType The relation type that the connections should belong to.
 @param queryString SQL kind of query to search for specific objects. For more info http://appacitive.com
 @param successBlock Block invoked when the search call is successful.
 @param failureBlock Block invoked when the search call fails.
 */
+ (void) searchForConnectionsWithRelationType:(NSString*)relationType withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
  @see searchAllConnectionsFromObjectId:toObjectIds:withSuccessHandler:failureHandler:
 */
+ (void) searchAllConnectionsFromObjectId:(NSNumber *)objectId toObjectIds:(NSArray *)objectIds;

/**
 @see searchAllConnectionsFromObjectId:toObjectIds:withSuccessHandler:failureHandler:
 */
+ (void) searchAllConnectionsFromObjectId:(NSNumber *)objectId toObjectIds:(NSArray *)objectIds withSuccessHandler:(APResultSuccessBlock)successBlock;

/**
 Searches for APConnections between the single article and any of the articles in the list and returns the paginated list of all connections .
 
 @param objectId  The id of the APObject for which the connections are to be retrieved.
 @param objectsId An array of objectIds.
 @param successBlock Block invoked when the search call is successful.
 @param failureBlock Block invoked when the search call fails.
 */
+ (void) searchAllConnectionsFromObjectId:(NSNumber *)objectId toObjectIds:(NSArray *)objectIds withSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Create APConnections */

/**
 @see createConnectionWithSuccessHandler:failureHandler:
 */
- (void) create;

/**
 @see createConnectionWithSuccessHandler:failureHandler:
 */
- (void) createConnectionWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Create an APConnection between two APObjects on the remote server.
 
 This method requires the articleAId, articleBId, labelA and labelB properties to be set.
 
 @param successBlock Block invoked when the create operation is successful.
 @param failureBlock Block invoked when the create operation fails.
 */
- (void) createConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see createConnectionWithObjectA:objectB:successHandler:failureHandler:
 */
- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB;

/**
 @see createConnectionWithObjectA:objectB:successHandler:failureHandler:
 */
- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB failureHandler:(APFailureBlock)failureBlock;

/**
 Creates an APConnection between two APObjects.
 
 This method will set labelA and labelB as the schemaName of objectA and objectB.
 
 @param objectA The article to create a connection from.
 @param objectB The article to create a connection to.
 @param successBlock Block invoked when the create operation is successful.
 @param failureBlock Block invoked when the create operation fails.
 */
- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see createConnectionWithObjectA:objectB:labelA:labelB:successHandler:failureHandler:
 */
- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB labelA:(NSString*)labelA labelB:(NSString*)labelB;

/**
  @see createConnectionWithObjectA:objectB:labelA:labelB:successHandler:failureHandler:
 */
- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB labelA:(NSString*)labelA labelB:(NSString*)labelB failureHandler:(APFailureBlock)failureBlock;

/**
 Creates an APConnection between two APObjects. The labels on either side of the connection are specified as parameters.
 
 @param objectA The article to create a connection from.
 @param objectB The article to create a connection to.
 @param labelA The label at the starting vertex of the connection.
 @param lablelB The label at the end vertex of the connection.
 @param successBlock Block invoked when the create operation is successful.
 @param failureBlock Block invoked when the create operation fails.
 */
- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB labelA:(NSString*)labelA labelB:(NSString*)labelB successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see createConnectionWithObjectAId:objectBId:labelA:labelB:successHandler:failureHandler:
 */
- (void) createConnectionWithObjectAId:(NSNumber*)objectAId objectBId:(NSNumber*)objectBId labelA:(NSString*)labelA labelB:(NSString*)labelB;

/**
 @see createConnectionWithObjectAId:objectBId:labelA:labelB:successHandler:failureHandler: 
 */
- (void) createConnectionWithObjectAId:(NSNumber*)objectAId objectBId:(NSNumber*)objectBId labelA:(NSString*)labelA labelB:(NSString*)labelB failureHandler:(APFailureBlock)failureBlock;

/**
 Creates an APConnection between two APObjects.
 
 @param objectAId The id of the APObject to create a connection from.
 @param objectBId The id of the APObject to create a connection to.
 @param labelA The label at the starting vertex of the connection.
 @param labelB The label at the end vertex of the connection.
 @param successHandler Block invoked when the create operation is successful.
 @param failureHandler Block invoked when the create operation fails.
 */
- (void) createConnectionWithObjectAId:(NSNumber*)objectAId objectBId:(NSNumber*)objectBId labelA:(NSString*)labelA labelB:(NSString*)labelB successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Update APConnections */

/**
 @see updateConnectionWithSuccessHandler:failureHandler:
 */
- (void) updateConnection;

/**
 @see updateConnectionWithSuccessHandler:failureHandler:
 */
- (void) updateConnectionWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Method used to update an APConnection.
 
 @param successBlock Block invoked when the update operation is successful.
 @param failureBlock Block invoked when the update operation fails.
 */
- (void) updateConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Fetch APConnections */

/**
 @see fetchConnectionWithRelationType:objectId:successHandler:failureHandler:
 */
+ (void) fetchConnectionWithRelationType:(NSString*)relationType objectId:(NSNumber*)objectId successHandler:(APResultSuccessBlock)successBlock;

/**
 Fetch an APConnection of a particular relation type.
 
 @param relationType The name of the relation. A connection of this relation name is retrieved.
 @param objectId The id of the connection to retrieve.
 @param successBlock Block invoked when the fetch call is successful. The block returns the results in the form of a JSON.
 @param failureBlock Block invoked when the fetch call operation fails.
 */
+ (void) fetchConnectionWithRelationType:(NSString*)relationType objectId:(NSNumber*)objectId successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see fetchConnectionsWithRelationType:objectId:successHandler:failureHandler:
 */
+ (void) fetchConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock;

/**
 Fetches multiple APConnections from the remote server.
 
 @param relationType The name of the relation. Connections of this relation are retrieved.
 @param objectIds An array of objectIds. Connections with these object ids are fetched.
 @param successBlock Block invoked when the fetch call is successful. The block returns the results in the form of a JSON.
 @param failureBlock Block invoked when the fetch call operation fails.
 */
+ (void) fetchConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see fetchConnectionWithSuccessHandler:failureHandler:
 */
- (void) fetchConnection;

/**
 @see fetchConnectionWithSuccessHandler:failureHandler:
 */
- (void) fetchConnectionWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Fetch a connection. This method will use the objectId property to fetch the connecition.
 
 @param successBlock Block invoked when the connection is fetched
 @param failureBlock Block invoked when the fetch call fails
 */
- (void) fetchConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Delete APConnections */

/**
 @see deleteConnectionsWithRelationType:objectIds:successHandler:failureHandler:
 */
+ (void) deleteConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds;

/**
 @see deleteConnectionsWithRelationType:objectIds:successHandler:failureHandler:
 */
+ (void) deleteConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds failureHandler:(APFailureBlock)failureBlock;

/**
 Deletes multiple APConnections.
 
 @param relationType The name of the relation. Connections of this relation name will be deleted.
 @param objectIds An array of objectIds. APConnections having these object ids will be deleted.
 @param successBlock Block invoked when the delete call is successful.
 @param failureBlock Block invoked when the delete call fails.
 */
+ (void) deleteConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see deleteConnectionWithSuccessHandler:failureHandler:
 */
- (void) deleteConnection;

/**
  @see deleteConnectionWithSuccessHandler:failureHandler:
 */
- (void) deleteConnectionWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Deletes an APConnection.
 
 This method requires the relationType and objectId to be set.
 
 @param successBlock Block invoked when delete is successful.
 @param failureBlock Block invoked when delete fails.
 */
- (void) deleteConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Methods to store key-value pairs */

/**
 Method used to add a property to the APObject.
 
 @param keyName key of the data item to be stored.
 @param object Corresponding value to the key.
 */
- (void) addPropertyWithKey:(NSString*) keyName value:(id) object;

/**
 Method used to update an existing property.
 Call update after this method call to persist the update.
 
 @param keyName key of the data item to be updated.
 @param object Corresponding value to the key.
 */
- (void) updatePropertyWithKey:(NSString*) keyName value:(id) object;

/**
 Method used to delete a property.
 Call update after this method call to persist the change.
 
 @param keyName key of the data item to be removed.
 */
- (void) removePropertyWithKey:(NSString*) keyName;

/**
 Method used to retrieve a property using its key.
 
 @param keyName key of the date item to be removed.
 */
- (NSDictionary*) getPropertyWithKey:(NSString*) keyName;

/**
 Method used to add an attibute to the APObject. Attributes are used to store extra information.
 
 @param keyName key of the data item to be stored.
 @param object Corresponding value to the key.
 */
- (void) addAttributeWithKey:(NSString*) keyName value:(id) object;

/**
 Method used to update an attribute.
 Call update after this method call to persist the change
 
 @param keyName key of the attribute to be updated.
 @param object Corresponding value to the key.
 */
- (void) updateAttributeWithKey:(NSString*) keyName value:(id) object;

/**
 Method used to remove an attribute.
 Call update after this method call to persist the change
 
 @param keyName key of the attribute to be removed.
 */
- (void) removeAttributeWithKey:(NSString*) keyName;
@end
