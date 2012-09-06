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
@synthesize createdBy = _createdBy;
@synthesize articleAId = _articleAId;
@synthesize articleBId = _articleBId;
@synthesize objectId = _objectId;
@synthesize labelA = _labelA;
@synthesize labelB = _labelB;
@synthesize relationId = _relationId;
@synthesize relationName = _relationName;
@synthesize lastUpdatedBy = _lastUpdatedBy;
@synthesize utcDateCreated = _utcDateCreated;
@synthesize utcLastUpdatedDate = _utcLastUpdatedDate;
@synthesize revision = _revision;
@synthesize properties = _properties;
@synthesize attributes = _attributes;
@synthesize tags = _tags;

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
        NSString *path = [CONNECTION_PATH stringByAppendingString:[NSString stringWithFormat:@"%@/%@", sharedObject.deploymentId, self.relationName]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@", sharedObject.session]];
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
    [APConnection fetchConnectionsWithRelationName:relationName objectIds:[NSArray arrayWithObject:objectId] successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionWithRelationName:(NSString*)relationName objectId:(NSNumber*)objectId successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [APConnection fetchConnectionsWithRelationName:relationName objectIds:[NSArray arrayWithObject:objectId] successHandler:successBlock failureHandler:failureBlock];
}

+ (void) fetchConnectionsWithRelationName:(NSString*)relationName objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock {
    [APConnection fetchConnectionsWithRelationName:relationName objectIds:objectIds successHandler:successBlock failureHandler:nil];
}

+ (void) fetchConnectionsWithRelationName:(NSString*)relationName objectIds:(NSArray*)objectIds successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    Appacitive *sharedObject = [Appacitive sharedObject];
    if (sharedObject) {
        __block NSString *path = [CONNECTION_PATH stringByAppendingString:[NSString stringWithFormat:@"%@/%@/find/byidlist", sharedObject.deploymentId, relationName]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@&idlist=", sharedObject.session]];
        
        [objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *number = (NSNumber*) obj;
            path = [path stringByAppendingString:[NSString stringWithFormat:@"%lld", number.longLongValue]];
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
        NSString *path = [CONNECTION_PATH stringByAppendingString:[NSString stringWithFormat:@"%@/%@/_bulk", sharedObject.deploymentId, relationName]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@", sharedObject.session]];
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
        NSString *path = [CONNECTION_PATH stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%lld", sharedObject.deploymentId, self.relationName, self.objectId.longLongValue]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@", sharedObject.session]];
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
    NSDictionary *connection = [dictionary objectForKey:@"Connection"];
    _articleAId = (NSNumber*) [connection objectForKey:@"__ArticleAId"];
    _articleBId = (NSNumber*) [connection objectForKey:@"__ArticleBId"];
    _attributes = [connection objectForKey:@"__Attributes"];
    _createdBy = (NSString*) [connection objectForKey:@"__CreatedBy"];
    _objectId = (NSNumber*) [connection objectForKey:@"__Id"];
    _labelA = (NSString*) [connection objectForKey:@"__LabelA"];
    _labelB = (NSString*) [connection objectForKey:@"__LabelB"];
    _lastUpdatedBy = (NSString*) [connection objectForKey:@"__LastUpdatedBy"];
    _properties = [connection objectForKey:@"__Properties"];
    _relationId = (NSNumber*) [connection objectForKey:@"__RelationId"];
    _relationName = (NSString*) [connection objectForKey:@"__RelationName"];
    _revision = (NSNumber*) [connection objectForKey:@"__Revision"];
    _tags = [connection objectForKey:@"__Tags"];
    _utcDateCreated = [self deserializeJsonDateString:[connection objectForKey:@"__UtcDateCreated"]];
    _utcLastUpdatedDate = [self deserializeJsonDateString:[connection objectForKey:@"__UtcLastUpdatedDate"]];
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
        [parameters setObject:self.articleAId forKey:@"__ArticleAId"];
    
    if (self.articleBId)
        [parameters setObject:self.articleBId forKey:@"__ArticleBId"];
    
    if (self.attributes)
        [parameters setObject:self.attributes forKey:@"__Attributes"];
    
    if (self.createdBy)
        [parameters setObject:self.createdBy forKey:@"__CreatedBy"];
    
    if (self.properties)
        [parameters setObject:self.properties forKey:@"__Properties"];
    
    if (self.labelA)
        [parameters setObject:self.labelA forKey:@"__LabelA"];
    
    if (self.labelB)
        [parameters setObject:self.labelB forKey:@"__LabelB"];
    
    if (self.relationName)
        [parameters setObject:self.relationName forKey:@"__RelationName"];
    
    if (self.revision)
        [parameters setObject:self.revision forKey:@"__Revision"];
    
    if (self.tags)
        [parameters setObject:self.tags forKey:@"__Tags"];
    return parameters;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"ArticleAId:%lld, ArticleBId:%lld, Attributes:%@, CreatedBy:%@, Connection Id:%lld, LabelA:%@, LabelB:%@, LastUpdatedBy:%@, Properties:%@, RelationId:%d, RelationName:%@, Revision:%d, Tags:%@, UtcDateCreated:%@, UtcLastUpdatedDate:%@", self.articleAId, self.articleBId, self.attributes, self.createdBy, self.objectId, self.labelA, self.labelB, self.lastUpdatedBy, self.properties, self.relationId, self.relationName, self.revision, self.tags ,self.utcDateCreated, self.utcLastUpdatedDate];
}
@end
