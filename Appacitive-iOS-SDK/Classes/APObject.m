//
//  APObject.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APObject.h"
#import "Appacitive.h"
#import "APError.h"
#import "APHelperMethods.h"
#import "NSString+APString.h"

@implementation APObject

NSString *const ARTICLE_PATH = @"article/";

#define SEARCH_PATH @"search/"

#pragma mark initialization methods

+ (id) objectWithSchemaName:(NSString*)schemaName {
    APObject *object = [[APObject alloc] initWithSchemaName:schemaName];
    return object;
}

- (id) initWithSchemaName:(NSString*)schemaName {
    self = [super init];
    if (self) {
        self.schemaType = schemaName;
    }
    return self;
}

#pragma mark search method

+ (void) searchAllObjectsWithSchemaName:(NSString*) schemaName successHandler:(APResultSuccessBlock)successBlock {
    [APObject searchAllObjectsWithSchemaName:schemaName successHandler:successBlock failureHandler:nil];
}

+ (void) searchAllObjectsWithSchemaName:(NSString*) schemaName successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APObject searchObjectsWithSchemaName:schemaName withQueryString:nil successHandler:successBlock failureHandler:failureBlock];
}

+ (void) searchObjectsWithSchemaName:(NSString*)schemaName withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock {
    [APObject searchObjectsWithSchemaName:schemaName withQueryString:queryString successHandler:successBlock failureHandler:nil];
}

+ (void) searchObjectsWithSchemaName:(NSString*)schemaName withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        
        NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"%@/find/all", schemaName];
        
        NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
        [queryParams setObject:NSStringFromBOOL(sharedObject.enableDebugForEachRequest) forKey:@"debug"];
        
        if (queryString) {
            NSDictionary *queryStringParams = [queryString queryParameters];
            [queryStringParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                [queryParams setObject:obj forKey:key];
            }];
        }
        
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation){
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlockCopy) {
                    successBlockCopy(completedOperation.responseJSON);
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }

        } onError:^(NSError *error){
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark delete methods

+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName failureHandler:(APFailureBlock)failureBlock {
    [APObject deleteObjectsWithIds:objectIds schemaName:schemaName successHandler:nil failureHandler:failureBlock];
}

+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APSuccessBlock successBlockCopy = [successBlock copy];
        
        NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"%@/bulkdelete", schemaName];
        
        NSDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)};
        path = [path stringByAppendingQueryParameters:queryParams];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:objectIds forKey:@"idlist"];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:params httpMethod:@"POST" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completionOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completionOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlockCopy) {
                    successBlockCopy();
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error) {
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

- (void) deleteObject {
    [self deleteObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) deleteObjectWithFailureHandler:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:successBlock failureHandler:failureBlock deleteConnectingConnections:NO];
}

- (void) deleteObjectWithConnectingConnections {
    [self deleteObjectWithSuccessHandler:nil failureHandler:nil deleteConnectingConnections:YES];
}

- (void) deleteObjectWithConnectingConnections:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:nil failureHandler:failureBlock deleteConnectingConnections:YES];
}

- (void) deleteObjectWithConnectingConnectionsSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:successBlock failureHandler:failureBlock deleteConnectingConnections:YES];
}

- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock deleteConnectingConnections:(BOOL)deleteConnections {
    
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APSuccessBlock successBlockCopy = [successBlock copy];
        
        NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"%@/%lld", self.schemaType, [self.objectId longLongValue]];
        
        NSDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest), @"deleteconnections":deleteConnections?@"true":@"false"};
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"DELETE" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlockCopy != nil) {
                    successBlockCopy();
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error) {
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark fetch methods

+ (void) fetchObjectWithObjectId:(NSNumber*)objectId schemaName:(NSString*)schemaName successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APObject fetchObjectsWithObjectIds:@[objectId] schemaName:schemaName successHandler:successBlock failureHandler:failureBlock];
}

+ (void) fetchObjectsWithObjectIds:(NSArray*)objectIds schemaName:(NSString *)schemaName successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        
        __block NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"%@/multiget/", schemaName];
        
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
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlockCopy) {
                    successBlockCopy(completedOperation.responseJSON);
                }
            } else {
                if (failureBlockCopy) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error) {
            if (failureBlockCopy) {
                failureBlockCopy((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

- (void) fetch {
    [self fetchWithFailureHandler:nil];
}

- (void) fetchWithFailureHandler:(APFailureBlock)failureBlock {
    [self fetchWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) fetchWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"%@/%lld", self.schemaType, [self.objectId longLongValue]];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                if (successBlock != nil) {
                    successBlock();
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error) {
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark save methods

- (void) saveObject {
    [self saveObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) saveObjectWithFailureHandler:(APFailureBlock)failureBlock {
    [self saveObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) saveObjectWithSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        
        NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"%@", self.schemaType];
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
                
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:[self postParamerters] httpMethod:@"PUT" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                
                if (successBlockCopy != nil) {
                    successBlockCopy(completedOperation.responseJSON);
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error){
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark update methods

- (void) updateObject {
    [self updateObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) updateObjectWithFailureHandler:(APFailureBlock)failureBlock {
    [self updateObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) updateObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APSuccessBlock successBlockCopy = [successBlock copy];
        
        NSString *path = [ARTICLE_PATH stringByAppendingFormat:@"%@/%@", self.schemaType, self.objectId.description];
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:[self postParamertersUpdate] httpMethod:@"POST" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                
                if (successBlockCopy != nil) {
                    successBlockCopy();
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error){
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark graph query method

+ (void) applyFilterGraphQuery:(NSString*)query successHandler:(APResultSuccessBlock)successBlock {
    [APObject applyFilterGraphQuery:query successHandler:successBlock failureHandler:nil];
}

+ (void) applyFilterGraphQuery:(NSString*)query successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        
        NSString *path = [SEARCH_PATH stringByAppendingString:@"filter"];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        NSError *error;
        NSMutableDictionary *postParams = [NSJSONSerialization JSONObjectWithData:[query dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            DLog(@"Error creating JSON, please check the syntax of the graph query");
            return;
        }
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:postParams httpMethod:@"POST" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlockCopy != nil) {
                    successBlockCopy(completedOperation.responseJSON);
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error){
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

+ (void) applyProjectionGraphQuery:(NSString*)query successHandler:(APResultSuccessBlock)successBlock {
    [APObject applyProjectionGraphQuery:query successHandler:successBlock failureHandler:nil];
}

+ (void) applyProjectionGraphQuery:(NSString *)query successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        
        NSString *path = [SEARCH_PATH stringByAppendingString:@"project"];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        NSError *error;
        NSMutableDictionary *postParams = [NSJSONSerialization JSONObjectWithData:[query dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            DLog(@"Error created JSON, please check the syntax of the graph query");
            return;
        }
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:postParams httpMethod:@"POST" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlockCopy != nil) {
                    successBlockCopy(completedOperation.responseJSON);
                }
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
        } onError:^(NSError *error){
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
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

- (NSDictionary*) getPropertyWithKey:(NSString*) keyName {
    __block NSDictionary *property;
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = (NSMutableDictionary *)obj;
        if ([[dict objectForKey:keyName] isEqualToString:keyName]) {
            property = [dict objectForKey:keyName];
            *stop = YES;
        }
    }];
    return property;
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

- (NSString*) description {
    return [NSString stringWithFormat:@"Object Id:%lld, Created by:%@, Last modified by:%@, UTC date created:%@, UTC date updated:%@, Revision:%d, Properties:%@, Attributes:%@, SchemaId:%d, SchemaType:%@, Tag:%@", [self.objectId longLongValue], self.createdBy, self.lastModifiedBy, self.utcDateCreated, self.utcLastUpdatedDate, [self.revision intValue], self.properties, self.attributes, [self.schemaId intValue], self.schemaType, self.tags];
}

#pragma mark private methods

- (void) setNewPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    NSDictionary *article = dictionary[@"article"];
    _createdBy = (NSString*) article[@"__createdby"];
    _objectId = (NSNumber*) article[@"__id"];
    _lastModifiedBy = (NSString*) article[@"__lastmodifiedby"];
    _revision = (NSNumber*) article[@"__revision"];
    _schemaId = (NSNumber*) article[@"__schemaid"];
    _utcDateCreated = [APHelperMethods deserializeJsonDateString:article[@"__utcdatecreated"]];
    _utcLastUpdatedDate = [APHelperMethods deserializeJsonDateString:article[@"__utclastupdateddate"]];
    _attributes = [article[@"__attributes"] mutableCopy];
    _tags = article[@"__tags"];
    _schemaType = article[@"__schematype"];
    
    _properties = [APHelperMethods arrayOfPropertiesFromJSONResponse:article].mutableCopy;
}

- (NSMutableDictionary*) postParamerters {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    
    if (self.objectId)
        postParams[@"__id"] = self.objectId.description;
    
    if (self.attributes)
        postParams[@"__attributes"] = self.attributes;
    
    if (self.createdBy)
        postParams[@"__createdby"] = self.createdBy;
    
    if (self.revision)
        postParams[@"__revision"] = self.revision;

    for(NSDictionary *prop in self.properties) {
        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [postParams setObject:obj forKey:key];
            *stop = YES;
        }];
    }
    
    if (self.schemaType)
        postParams[@"__schematype"] = self.schemaType;

    if (self.tags)
        postParams[@"__tags"] = self.tags;
    return postParams;
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
@end
