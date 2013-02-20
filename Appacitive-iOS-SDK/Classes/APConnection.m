//
//  APConnection.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 03/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd.. All rights reserved.
//

#import "APConnection.h"
#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APHelperMethods.h"
#import "NSString+APString.h"

@implementation APConnection

#define CONNECTION_PATH @"connection/"

#pragma mark initialization methods

+ (id) connectionWithRelationType:(NSString*)relationType {
    return [[APConnection alloc] initWithRelationType:relationType];
}

- (id) initWithRelationType:(NSString*)relationType {
    self = [super init];
    if(self) {
        self.relationType = relationType;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self) {
        [self setPropertyValuesFromDictionary:dictionary];
    }
    return self;
}

#pragma mark search methods

+ (void) searchForAllConnectionsWithRelationType:(NSString*)relationType successHandler:(APConnectionsSuccessBlock)successBlock {
    [APConnection searchForAllConnectionsWithRelationType:relationType successHandler:successBlock failureHandler:nil];
}

+ (void) searchForAllConnectionsWithRelationType:(NSString*)relationType successHandler:(APConnectionsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APConnection searchForConnectionsWithRelationType:relationType withQueryString:nil successHandler:successBlock failureHandler:failureBlock];
}

+ (void) searchForConnectionsWithRelationType:(NSString*)relationType withQueryString:(NSString*)queryString successHandler:(APConnectionsSuccessBlock)successBlock {
    [APConnection searchForConnectionsWithRelationType:relationType withQueryString:queryString successHandler:successBlock failureHandler:nil];
}

+ (void) searchForConnectionsWithRelationType:(NSString*)relationType withQueryString:(NSString*)queryString successHandler:(APConnectionsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/find/all", relationType];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        if (queryString) {
            path = [path stringByAppendingFormat:@"&%@",queryString];
        }
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock != nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(){
                        
                        NSArray *connections = [completedOperation.responseJSON objectForKey:@"connections"];
                        NSMutableArray *apConnections = [NSMutableArray arrayWithCapacity:connections.count];
                        
                        for (NSDictionary *connection in connections) {
                            APConnection *conn = [[APConnection alloc] initWithDictionary:connection];
                            [apConnections addObject:conn];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            successBlock(apConnections);
                        });
                    });
                }
            } else {
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }

        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

+ (void) searchAllConnectionsFromObjectId:(NSNumber *)objectId toObjectIds:(NSArray *)objectIds {
    [APConnection searchAllConnectionsFromObjectId:objectId toObjectIds:objectIds withSuccessHandler:nil failureHandler:nil];
}

+ (void) searchAllConnectionsFromObjectId:(NSNumber *)objectId toObjectIds:(NSArray *)objectIds withSuccessHandler:(APConnectionsSuccessBlock)successBlock {
    [APConnection searchAllConnectionsFromObjectId:objectId toObjectIds:objectIds withSuccessHandler:successBlock failureHandler:nil];
}


+ (void) searchAllConnectionsFromObjectId:(NSNumber *)objectId toObjectIds:(NSArray *)objectIds withSuccessHandler:(APConnectionsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        NSString *path = [CONNECTION_PATH stringByAppendingString:@"interconnects"];
        
        NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
        postParams[@"article1id"] = [NSString stringWithFormat:@"%lld",objectId.longLongValue];
        postParams[@"article2ids"] = objectIds;
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:postParams httpMethod:@"POST" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock != nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(){
                        
                        NSArray *connections = [completedOperation.responseJSON objectForKey:@"connections"];
                        NSMutableArray *apConnections = [NSMutableArray arrayWithCapacity:connections.count];
                        
                        for (NSDictionary *connection in connections) {
                            APConnection *conn = [[APConnection alloc] initWithDictionary:connection];
                            [apConnections addObject:conn];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            successBlock(apConnections);
                        });
                    });
                }
            } else {
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
            
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark create connection methods

- (void) create {
    [self createConnectionWithSuccessHandler:nil failureHandler:nil];
}

- (void) createConnectionWithFailureHandler:(APFailureBlock)failureBlock {
    [self createConnectionWithSuccessHandler:nil failureHandler:nil];
}

- (void) createConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        NSString *path = [CONNECTION_PATH stringByAppendingString:self.relationType];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:[self parameters] httpMethod:@"PUT" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                if (successBlock != nil) {
                    successBlock();
                }
            } else {
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB {
    [self createConnectionWithObjectA:objectA objectB:objectB successHandler:nil failureHandler:nil];
}

- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB failureHandler:(APFailureBlock)failureBlock {
    [self createConnectionWithObjectA:objectA objectB:objectB successHandler:nil failureHandler:failureBlock];
}

- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    self.articleAId = objectA.objectId;
    self.articleBId = objectB.objectId;
    self.labelA = objectA.schemaType;
    self.labelB = objectB.schemaType;
    [self createConnectionWithSuccessHandler:successBlock failureHandler:failureBlock];
}

- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB labelA:(NSString*)labelA labelB:(NSString*)labelB {
    [self createConnectionWithObjectA:objectA objectB:objectB labelA:labelA labelB:labelB successHandler:nil failureHandler:nil];
}

- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB labelA:(NSString*)labelA labelB:(NSString*)labelB failureHandler:(APFailureBlock)failureBlock {
    [self createConnectionWithObjectA:objectA objectB:objectB labelA:labelA labelB:labelB successHandler:nil failureHandler:failureBlock];
}

- (void) createConnectionWithObjectA:(APObject*)objectA objectB:(APObject*)objectB labelA:(NSString*)labelA labelB:(NSString*)labelB successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    self.articleAId = objectA.objectId;
    self.articleBId = objectB.objectId;
    self.labelA = labelA;
    self.labelB = labelB;
    [self createConnectionWithSuccessHandler:successBlock failureHandler:failureBlock];
}

- (void) createConnectionWithObjectAId:(NSNumber*)objectAId objectBId:(NSNumber*)objectBId labelA:(NSString*)labelA labelB:(NSString*)labelB {
    [self createConnectionWithObjectAId:objectAId objectBId:objectBId labelA:labelA labelB:labelB successHandler:nil failureHandler:nil];
}

- (void) createConnectionWithObjectAId:(NSNumber*)objectAId objectBId:(NSNumber*)objectBId labelA:(NSString*)labelA labelB:(NSString*)labelB failureHandler:(APFailureBlock)failureBlock {
    [self createConnectionWithObjectAId:objectAId objectBId:objectBId labelA:labelA labelB:labelB successHandler:nil failureHandler:failureBlock];
}

- (void) createConnectionWithObjectAId:(NSNumber*)objectAId objectBId:(NSNumber*)objectBId labelA:(NSString*)labelA labelB:(NSString*)labelB successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    self.articleAId = objectAId;
    self.articleBId = objectBId;
    self.labelA = labelA;
    self.labelB = labelB;
    [self createConnectionWithSuccessHandler:successBlock failureHandler:failureBlock];
}

#pragma mark update connection methods

- (void) updateConnection {
    [self updateConnectionWithSuccessHandler:nil failureHandler:nil];
}

- (void) updateConnectionWithFailureHandler:(APFailureBlock)failureBlock {
    [self updateConnectionWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) updateConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%@", self.relationType, self.objectId.description];
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:[self postParamertersUpdate] httpMethod:@"POST" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                
                if (successBlock != nil) {
                    successBlock();
                }
            } else {
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark fetch connection methods

+ (void) fetchConnectionWithRelationType:(NSString*)relationType objectId:(NSNumber*)objectId successHandler:(APConnectionSuccessBlock)successBlock {
    [APConnection fetchConnectionWithRelationType:relationType objectId:objectId successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionWithRelationType:(NSString*)relationType objectId:(NSNumber*)objectId successHandler:(APConnectionSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        __block NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/multiget/%lld", relationType, objectId.longLongValue];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(){
                        
                        NSArray *connections = [completedOperation.responseJSON objectForKey:@"connections"];
                        NSDictionary *connection = connections[0];
                        APConnection *conn = [[APConnection alloc] initWithDictionary:connection];
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            successBlock(conn);
                        });
                    });
                }
            } else {
                if (failureBlock) {
                    failureBlock(error);
                }
            }
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (failureBlock) {
                failureBlock((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

+ (void) fetchConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APConnectionsSuccessBlock)successBlock {
    [APConnection fetchConnectionsWithRelationType:relationType objectIds:objectIds successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APConnectionsSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        __block NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/multiget/", relationType];
        
        [objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *number = (NSNumber*) obj;
            path = [path stringByAppendingFormat:@"%lld", number.longLongValue];
            if (idx != objectIds.count - 1) {
                path = [path stringByAppendingString:@","];
            }
        }];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];

        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(){
                        
                        NSArray *connections = [completedOperation.responseJSON objectForKey:@"connections"];
                        NSMutableArray *apConnections = [NSMutableArray arrayWithCapacity:connections.count];
                        
                        for (NSDictionary *connection in connections) {
                            APConnection *conn = [[APConnection alloc] initWithDictionary:connection];
                            [apConnections addObject:conn];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            successBlock(apConnections);
                        });
                    });
                }
            } else {
                if (failureBlock) {
                    failureBlock(error);
                }
            }
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (failureBlock) {
                failureBlock((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

- (void) fetchConnection {
    [self fetchConnectionWithSuccessHandler:nil failureHandler:nil];
}

- (void) fetchConnectionWithFailureHandler:(APFailureBlock)failureBlock {
    [self fetchConnectionWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) fetchConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%@", self.relationType, self.objectId.description];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failureBlock) {
                    failureBlock(error);
                }
            }
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
            if (failureBlock) {
                failureBlock((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark delete methods

+ (void) deleteConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds {
    [APConnection deleteConnectionsWithRelationType:relationType objectIds:objectIds successHandler:nil failureHandler:nil];
}

+ (void) deleteConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds failureHandler:(APFailureBlock)failureBlock {
    [APConnection deleteConnectionsWithRelationType:relationType objectIds:objectIds successHandler:nil failureHandler:nil];
}

+ (void) deleteConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/bulkdelete", relationType];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:objectIds forKey:@"idlist"];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:params httpMethod:@"POST" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op addCompletionHandler:^(MKNetworkOperation *completionOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completionOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (failureBlock != nil) {
                failureBlock((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }

}

- (void) deleteConnection {
    [self deleteConnectionWithSuccessHandler:nil failureHandler:nil];
}

- (void) deleteConnectionWithFailureHandler:(APFailureBlock)failureBlock {
    [self deleteConnectionWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) deleteConnectionWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    
    if (sharedObject.session) {
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%lld", self.relationType, self.objectId.longLongValue];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"DELETE" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock != nil) {
                    successBlock();
                }
            } else {
                if (failureBlock!= nil) {
                    failureBlock(error);
                }
            }

        }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlock != nil) {
            failureBlock([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark add properties method

- (void) addPropertyWithKey:(NSString*) keyName value:(id) object {
    if (!self.properties) {
        _properties = [NSMutableArray array];
    }
    [_properties addObject:@{keyName: object}];
}

#pragma mark add attributes method

- (void) addAttributeWithKey:(NSString*) keyName value:(id) object {
    if (!self.attributes) {
        _attributes = [NSMutableDictionary dictionary];
    }
    [_attributes setObject:object forKey:keyName];
}

- (void) updateAttributeWithKey:(NSString*) keyName value:(id) object {
    [_attributes setObject:object forKey:keyName];
}

- (void) removeAttributeWithKey:(NSString*) keyName {
    [_attributes setObject:[NSNull null] forKey:keyName];
}

#pragma mark update properties method

- (void) updatePropertyWithKey:(NSString*) keyName value:(id) object {
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = (NSMutableDictionary *)obj;
        if ([dict objectForKey:keyName] != nil) {
            [dict setObject:object forKey:keyName];
            *stop = YES;
        }
    }];
}

#pragma mark delete property

- (void) removePropertyWithKey:(NSString*) keyName {
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = (NSMutableDictionary *)obj;
        if ([dict objectForKey:keyName] != nil) {
            [dict setObject:[NSNull null] forKey:keyName];
            *stop = YES;
        }
    }];
}

#pragma mark retrieve property

- (id) getPropertyWithKey:(NSString*) keyName {
    __block id property;
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = (NSMutableDictionary *)obj;
        if ([dict objectForKey:keyName] != nil) {
            property = [dict objectForKey:keyName];
            *stop = YES;
        }
    }];
    return property;
}

#pragma mark private methods

- (void) setNewPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    NSDictionary *connection = dictionary[@"connection"];
    [self setPropertyValuesFromDictionary:connection];
}

- (void) setPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    _articleBId = (NSNumber*) dictionary[@"__endpointb"][@"articleid"];
    _createdBy = (NSString*) dictionary[@"__createdby"];
    _objectId = (NSNumber*) dictionary[@"__id"];
    _labelA = (NSString*) dictionary[@"__endpointa"][@"label"];
    _labelB = (NSString*) dictionary[@"__endpointb"][@"label"];
    _lastModifiedBy = (NSString*) dictionary[@"__lastmodifiedby"];
    _relationId = (NSNumber*) dictionary[@"__relationid"];
    _relationType = (NSString*) dictionary[@"__relationtype"];
    _revision = (NSNumber*) dictionary[@"__revision"];
    _tags = dictionary[@"__tags"];
    _utcDateCreated = [APHelperMethods deserializeJsonDateString:dictionary[@"__utcdatecreated"]];
    _utcLastModifiedDate = [APHelperMethods deserializeJsonDateString:dictionary[@"__utclastupdateddate"]];
    
    _attributes = [dictionary[@"__attributes"] mutableCopy];
    _properties = [APHelperMethods arrayOfPropertiesFromJSONResponse:dictionary].mutableCopy;
}

- (NSMutableDictionary*) parameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.articleAId) {
        if (!parameters[@"__endpointa"]) {
            parameters[@"__endpointa"] = [NSMutableDictionary dictionary];
        }
        parameters[@"__endpointa"][@"articleid"] = [NSString stringWithFormat:@"%lld", self.articleAId.longLongValue];
    }

    if (self.articleBId) {
        if (!parameters[@"__endpointb"]) {
            parameters[@"__endpointb"] = [NSMutableDictionary dictionary];
        }
        parameters[@"__endpointb"][@"articleid"] = [NSString stringWithFormat:@"%lld", self.articleBId.longLongValue];
    }
    
    if (self.attributes)
        parameters[@"__attributes"] = self.attributes;
    
    if (self.createdBy)
        parameters[@"__createdby"] = self.createdBy;
    
    for(NSDictionary *prop in self.properties) {
        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [parameters setObject:obj forKey:key];
            *stop = YES;
        }];
    }
    
    if (self.labelA) {
        if (!parameters[@"__endpointa"]) {
            parameters[@"__endpointa"] = [NSMutableDictionary dictionary];
        }
        parameters[@"__endpointa"][@"label"] = self.labelA;
    }
    
    if (self.labelB) {
        if (!parameters[@"__endpointb"]) {
            parameters[@"__endpointb"] = [NSMutableDictionary dictionary];
        }
        parameters[@"__endpointb"][@"label"] = self.labelB;
    }
    
    if (self.relationType)
        parameters[@"__relationtype"] = self.relationType;
    
    if (self.revision)
        parameters[@"__revision"] = self.revision;
    
    if (self.tags)
        parameters[@"__tags"] = self.tags;
    return parameters;
}

- (NSMutableDictionary*) postParamertersUpdate {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    
    if (self.attributes && [self.attributes count] > 0)
        postParams[@"__attributes"] = self.attributes;
    
    for(NSDictionary *prop in self.properties) {
        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [postParams setObject:obj forKey:key];
            *stop = YES;
        }];
    }
    return postParams;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"ArticleAId:%lld, ArticleBId:%lld, Attributes:%@, CreatedBy:%@, Connection Id:%lld, LabelA:%@, LabelB:%@, LastUpdatedBy:%@, Properties:%@, RelationId:%d, Relation Type:%@, Revision:%d, Tags:%@, UtcDateCreated:%@, UtcLastUpdatedDate:%@", [self.articleAId longLongValue], [self.articleBId longLongValue], self.attributes, self.createdBy, [self.objectId longLongValue], self.labelA, self.labelB, self.lastModifiedBy, self.properties, [self.relationId intValue], self.relationType, [self.revision intValue], self.tags ,self.utcDateCreated, self.utcLastModifiedDate];
}
@end
