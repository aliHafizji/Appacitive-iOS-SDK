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

@implementation APConnection

#define CONNECTION_PATH @"v0.9/core/Connection.svc/"

#pragma mark initialization methods

+ (id) connectionWithRelationName:(NSString*)relationName {
    return [[APConnection alloc] initWithRelationName:relationName];
}

- (id) initWithRelationName:(NSString*)relationName {
    self = [super init];
    if(self) {
        self.relationName = relationName;
    }
    return self;
}

#pragma mark search methods

+ (void) searchForAllConnectionsWithRelationName:(NSString*)relationName successHandler:(APResultSuccessBlock)successHandler {
    [APConnection searchForAllConnectionsWithRelationName:relationName successHandler:successHandler failureHandler:nil];
}

+ (void) searchForAllConnectionsWithRelationName:(NSString*)relationName successHandler:(APResultSuccessBlock)successHandler failureHandler:(APFailureBlock)failureBlock {
    [APConnection searchForConnectionsWithRelationName:relationName withQueryString:nil successHandler:successHandler failureHandler:failureBlock];
}

+ (void) searchForConnectionsWithRelationName:(NSString*)relationName withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock {
    [APConnection searchForConnectionsWithRelationName:relationName withQueryString:queryString successHandler:successBlock failureHandler:nil];
}

+ (void) searchForConnectionsWithRelationName:(NSString*)relationName withQueryString:(NSString*)queryString successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject) {
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%@/find/all", sharedObject.deploymentId, relationName];
        if (queryString) {
            path = [path stringByAppendingFormat:@"?%@&session=%@",queryString, sharedObject.session];
        } else {
            path = [path stringByAppendingFormat:@"?session=%@", sharedObject.session];
        }
        
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        MKNetworkOperation *op = [sharedObject operationWithPath:urlEncodedPath];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation){
            DLog(@"%@", completedOperation.description);
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock != nil) {
                    successBlock(completedOperation.responseJSON);
                }
            } else {
                DLog(@"%@", error.description)
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }

        } onError:^(NSError *error) {
            DLog(@"%@", error.description);
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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
    if (sharedObject) {
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%@", sharedObject.deploymentId, self.relationName];
        path = [path stringByAppendingFormat:@"?session=%@", sharedObject.session];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:urlEncodedPath params:[self parameters] httpMethod:@"PUT"];
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            DLog(@"%@", completedOperation.description);
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                if (successBlock != nil) {
                    successBlock();
                }
            } else {
                DLog(@"%@", error.description)
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
        } onError:^(NSError *error) {
            DLog(@"%@", error.description);
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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

+ (void) fetchConnectionWithRelationName:(NSString*)relationName objectId:(NSNumber*)objectId successHandler:(APResultSuccessBlock)successBlock {
    [APConnection fetchConnectionsWithRelationName:relationName objectIds:@[objectId] successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionWithRelationName:(NSString*)relationName objectId:(NSNumber*)objectId successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APConnection fetchConnectionsWithRelationName:relationName objectIds:@[objectId] successHandler:successBlock failureHandler:failureBlock];
}

+ (void) fetchConnectionsWithRelationName:(NSString*)relationName objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock {
    [APConnection fetchConnectionsWithRelationName:relationName objectIds:objectIds successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionsWithRelationName:(NSString*)relationName objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject) {
        __block NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%@/find/byidlist", sharedObject.deploymentId, relationName];
        path = [path stringByAppendingFormat:@"?session=%@&idlist=", sharedObject.session];
        
        [objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *number = (NSNumber*) obj;
            path = [path stringByAppendingFormat:@"%lld", number.longLongValue];
            if (idx != objectIds.count - 1) {
                path = [path stringByAppendingString:@","];
            }
        }];

        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:urlEncodedPath];
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            DLog(@"%@", completedOperation.description);
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock) {
                    successBlock(completedOperation.responseJSON);
                }
            } else {
                DLog(@"%@", error.description);
                if (failureBlock) {
                    failureBlock(error);
                }
            }
        } onError:^(NSError *error) {
            DLog(@"%@", error.description);
            if (failureBlock) {
                failureBlock((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

#pragma mark delete methods

+ (void) deleteConnectionsWithRelationName:(NSString*)relationName objectIds:(NSArray*)objectIds {
    [APConnection deleteConnectionsWithRelationName:relationName objectIds:objectIds successHandler:nil failureHandler:nil];
}

+ (void) deleteConnectionsWithRelationName:(NSString*)relationName objectIds:(NSArray*)objectIds failureHandler:(APFailureBlock)failureBlock {
    [APConnection deleteConnectionsWithRelationName:relationName objectIds:objectIds successHandler:nil failureHandler:nil];
}

+ (void) deleteConnectionsWithRelationName:(NSString*)relationName objectIds:(NSArray*)objectIds successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject) {
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%@/_bulk", sharedObject.deploymentId, relationName];
        path = [path stringByAppendingFormat:@"?session=%@", sharedObject.session];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:objectIds forKey:@"Id"];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:urlEncodedPath params:params httpMethod:@"POST"];
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completionOperation) {
            DLog(@"%@", completionOperation.description);
            APError *error = [APHelperMethods checkForErrorStatus:completionOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                DLog(@"%@", error.description);
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
        } onError:^(NSError *error) {
            DLog(@"%@", error.description);
            if (failureBlock != nil) {
                failureBlock((APError*) error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
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
    if (sharedObject) {
        NSString *path = [CONNECTION_PATH stringByAppendingFormat:@"%@/%@/%lld", sharedObject.deploymentId, self.relationName, self.objectId.longLongValue];
        path = [path stringByAppendingFormat:@"?session=%@", sharedObject.session];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedObject operationWithPath:urlEncodedPath params:nil httpMethod:@"DELETE"];
        [op onCompletion:^(MKNetworkOperation *completedOperation){
            DLog("%@", completedOperation.description);
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                if (successBlock != nil) {
                    successBlock();
                }
            } else {
                DLog(@"%@", error.description);
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }

        } onError:^(NSError *error){
            DLog(@"%@", error.description)
            if (failureBlock != nil) {
                failureBlock((APError*)error);
            }
        }];
        [sharedObject enqueueOperation:op];
    } else {
        DLog(@"Initialize the Appacitive object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

#pragma mark private methods

- (void) setNewPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    NSDictionary *connection = dictionary[@"Connection"];
    _articleAId = (NSNumber*) connection[@"__ArticleAId"];
    _articleBId = (NSNumber*) connection[@"__ArticleBId"];
    _attributes = connection[@"__Attributes"];
    _createdBy = (NSString*) connection[@"__CreatedBy"];
    _objectId = (NSNumber*) connection[@"__Id"];
    _labelA = (NSString*) connection[@"__LabelA"];
    _labelB = (NSString*) connection[@"__LabelB"];
    _lastUpdatedBy = (NSString*) connection[@"__LastUpdatedBy"];
    _properties = connection[@"__Properties"];
    _relationId = (NSNumber*) connection[@"__RelationId"];
    _relationName = (NSString*) connection[@"__RelationName"];
    _revision = (NSNumber*) connection[@"__Revision"];
    _tags = connection[@"__Tags"];
    _utcDateCreated = [self deserializeJsonDateString:connection[@"__UtcDateCreated"]];
    _utcLastUpdatedDate = [self deserializeJsonDateString:connection[@"__UtcLastUpdatedDate"]];
}

- (NSDate *) deserializeJsonDateString: (NSString *)jsonDateString {
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1;
    NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; 
    return [[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
}

- (NSMutableDictionary*) parameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.articleAId)
        parameters[@"__ArticleAId"] = self.articleAId;
    
    if (self.articleBId)
        parameters[@"__ArticleBId"] = self.articleBId;
    
    if (self.attributes)
        parameters[@"__Attributes"] = self.attributes;
    
    if (self.createdBy)
        parameters[@"__CreatedBy"] = self.createdBy;
    
    if (self.properties)
        parameters[@"__Properties"] = self.properties;
    
    if (self.labelA)
        parameters[@"__LabelA"] = self.labelA;
    
    if (self.labelB)
        parameters[@"__LabelB"] = self.labelB;
    
    if (self.relationName)
        parameters[@"__RelationName"] = self.relationName;
    
    if (self.revision)
        parameters[@"__Revision"] = self.revision;
    
    if (self.tags)
        parameters[@"__Tags"] = self.tags;
    return parameters;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"ArticleAId:%lld, ArticleBId:%lld, Attributes:%@, CreatedBy:%@, Connection Id:%lld, LabelA:%@, LabelB:%@, LastUpdatedBy:%@, Properties:%@, RelationId:%d, RelationName:%@, Revision:%d, Tags:%@, UtcDateCreated:%@, UtcLastUpdatedDate:%@", [self.articleAId longLongValue], [self.articleBId longLongValue], self.attributes, self.createdBy, [self.objectId longLongValue], self.labelA, self.labelB, self.lastUpdatedBy, self.properties, [self.relationId intValue], self.relationName, [self.revision intValue], self.tags ,self.utcDateCreated, self.utcLastUpdatedDate];
}
@end
