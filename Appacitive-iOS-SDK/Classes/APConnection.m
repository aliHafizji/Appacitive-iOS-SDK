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

#pragma mark search methods

+ (void) searchForAllConnectionsWithRelationType:(NSString*)relationType successHandler:(APResultSuccessBlock)successBlock {
    [APConnection searchForAllConnectionsWithRelationType:relationType successHandler:successBlock failureHandler:nil];
}

+ (void) searchForAllConnectionsWithRelationType:(NSString*)relationType successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APConnection searchForConnectionsWithRelationType:relationType withQueryString:nil successHandler:successBlock failureHandler:failureBlock];
}

+ (void) searchForConnectionsWithRelationType:(NSString*)relationType withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock {
    [APConnection searchForConnectionsWithRelationType:relationType withQueryString:queryString successHandler:successBlock failureHandler:nil];
}

+ (void) searchForConnectionsWithRelationType:(NSString*)relationType withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        APFailureBlock failureBlockCopy = [failureBlock copy];
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/find/all", relationType];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        if (queryString) {
            path = [path stringByAppendingFormat:@"&%@",queryString];
        }
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation){
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

        } onError:^(NSError *error) {
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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
        APSuccessBlock successBlockCopy = [successBlock copy];
        APFailureBlock failureBlockCopy = [failureBlock copy];
        
        NSString *path = [CONNECTION_PATH stringByAppendingString:self.relationType];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:[self parameters] httpMethod:@"PUT" ssl:YES];
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
        } onError:^(NSError *error) {
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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

#pragma mark fetch connection methods

+ (void) fetchConnectionWithRelationType:(NSString*)relationType objectId:(NSNumber*)objectId successHandler:(APResultSuccessBlock)successBlock {
    [APConnection fetchConnectionsWithRelationType:relationType objectIds:@[objectId] successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionWithRelationType:(NSString*)relationType objectId:(NSNumber*)objectId successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APConnection fetchConnectionsWithRelationType:relationType objectIds:@[objectId] successHandler:successBlock failureHandler:failureBlock];
}

+ (void) fetchConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock {
    [APConnection fetchConnectionsWithRelationType:relationType objectIds:objectIds successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionsWithRelationType:(NSString*)relationType objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        APFailureBlock failureBlockCopy = [failureBlock copy];
        
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
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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
        APSuccessBlock successBlockCopy = [successBlock copy];
        APFailureBlock failureBlockCopy = [failureBlock copy];
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/bulkdelete", relationType];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
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
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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
        APSuccessBlock successBlockCopy = [successBlock copy];
        APFailureBlock failureBlockCopy = [failureBlock copy];
        
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%lld", self.relationType, self.objectId.longLongValue];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest)}.mutableCopy;
        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:path params:nil httpMethod:@"DELETE" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:op];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation){
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlockCopy != nil) {
                    successBlockCopy();
                }
            } else {
                if (failureBlockCopy!= nil) {
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
        DLog(@"Initialize the Appacitive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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
        _attributes = [NSMutableArray array];
    }
    [_attributes addObject:@{keyName: object}];
}

#pragma mark private methods

- (void) setNewPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    NSDictionary *connection = dictionary[@"connection"];
    _articleAId = (NSNumber*) connection[@"__endpointa"][@"articleid"];
    _articleBId = (NSNumber*) connection[@"__endpointb"][@"articleid"];
    _attributes = connection[@"__attributes"];
    _createdBy = (NSString*) connection[@"__createdby"];
    _objectId = (NSNumber*) connection[@"__id"];
    _labelA = (NSString*) connection[@"__endpointa"][@"label"];
    _labelB = (NSString*) connection[@"__endpointb"][@"label"];
    _lastModifiedBy = (NSString*) connection[@"__lastmodifiedby"];
    _relationId = (NSNumber*) connection[@"__relationid"];
    _relationType = (NSString*) connection[@"__relationtype"];
    _revision = (NSNumber*) connection[@"__revision"];
    _tags = connection[@"__tags"];
    _utcDateCreated = [self deserializeJsonDateString:connection[@"__createdate"]];
    _utcLastModifiedDate = [self deserializeJsonDateString:connection[@"__lastmodified"]];
    
    _properties = [APHelperMethods arrayOfPropertiesFromJSONResponse:dictionary].mutableCopy;
}

- (NSDate *) deserializeJsonDateString: (NSString *)jsonDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    return [dateFormatter dateFromString:jsonDateString];
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

- (NSString*) description {
    return [NSString stringWithFormat:@"ArticleAId:%lld, ArticleBId:%lld, Attributes:%@, CreatedBy:%@, Connection Id:%lld, LabelA:%@, LabelB:%@, LastUpdatedBy:%@, Properties:%@, RelationId:%d, Relation Type:%@, Revision:%d, Tags:%@, UtcDateCreated:%@, UtcLastUpdatedDate:%@", [self.articleAId longLongValue], [self.articleBId longLongValue], self.attributes, self.createdBy, [self.objectId longLongValue], self.labelA, self.labelB, self.lastModifiedBy, self.properties, [self.relationId intValue], self.relationType, [self.revision intValue], self.tags ,self.utcDateCreated, self.utcLastModifiedDate];
}
@end
