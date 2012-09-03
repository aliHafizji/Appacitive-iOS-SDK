//
//  AYObject.m
//  AYoda-iOS example
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "AYObject.h"
#import "AppYoda.h"
#import "AYError.h"
#import "AYHelperMethods.h"

@implementation AYObject
@synthesize createdBy = _createdBy;
@synthesize objectId = _objectId;
@synthesize lastUpdatedBy = _lastUpdatedBy;
@synthesize utcDateCreated = _utcDateCreated;
@synthesize utcLastUpdatedDate = _utcLastUpdatedDate;
@synthesize revision = _revision;
@synthesize properties = _properties;
@synthesize attributes = _attributes;
@synthesize schemaId = _schemaId;
@synthesize schemaType = _schemaType;
@synthesize tags = _tags;

#pragma mark initialization methods

+ (id) objectWithSchemaName:(NSString*)schemaName {
    AYObject *object = [[AYObject alloc] initWithSchemaName:schemaName];
    return object;
}

- (id) initWithSchemaName:(NSString*)schemaName {
    self = [super init];
    if (self) {
        self.schemaType = schemaName;
    }
    return self;
}

#pragma mark delete methods

+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName failureHandler:(AYFailureBlock)failureBlock {
    [AYObject deleteObjectsWithIds:objectIds schemaName:schemaName successHandler:nil failureHandler:failureBlock];
}

+ (void) deleteObjectsWithIds:(NSArray*)objectIds schemaName:(NSString*)schemaName successHandler:(AYSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock {
    AppYoda *sharedYoda = [AppYoda sharedYoda];
    if (sharedYoda) {
        NSString *path = [@"v0.9/core/Article.svc/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@/_bulk", sharedYoda.deploymentId, schemaName]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@", sharedYoda.session]];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:objectIds forKey:@"Id"];
        
        MKNetworkOperation *op = [sharedYoda operationWithPath:urlEncodedPath params:params httpMethod:@"POST"];
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completionOperation) {
            DLog(@"%@", completionOperation.description);
            AYError *error = [AYHelperMethods checkForErrorStatus:completionOperation.responseJSON];
            
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
                failureBlock((AYError*) error);
            }
        }];
        [sharedYoda enqueueOperation:op];
    } else {
        DLog(@"Initialize the AppYoda object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

- (void) deleteObject {
    [self deleteObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) deleteObjectWithFailureHandler:(AYFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) deleteObjectWithSuccessHandler:(AYSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock {
    AppYoda *sharedYoda = [AppYoda sharedYoda];
    if (sharedYoda) {
        NSString *path = [@"v0.9/core/Article.svc/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%lld", sharedYoda.deploymentId, self.schemaType, [self.objectId longLongValue]]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@", sharedYoda.session]];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedYoda operationWithPath:urlEncodedPath params:nil httpMethod:@"DELETE"];
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            DLog("%@", completedOperation.description);
            AYError *error = [AYHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
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
        } onError:^(NSError *error) {
            DLog(@"%@", error.description)
            if (failureBlock != nil) {
                failureBlock((AYError*)error);
            }
        }];
        [sharedYoda enqueueOperation:op];
    } else {
        DLog(@"Initialize the AppYoda object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

#pragma mark fetch methods

+ (void) fetchObjectWithObjectId:(NSNumber*)objectId schemaName:(NSString*)schemaName successHandler:(AYResultSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock {
    [AYObject fetchObjectsWithObjectIds:[NSArray arrayWithObject:objectId] schemaName:schemaName successHandler:successBlock failureHandler:failureBlock];
}

+ (void) fetchObjectsWithObjectIds:(NSArray*)objectIds schemaName:(NSString *)schemaName successHandler:(AYResultSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock {
    AppYoda *sharedYoda = [AppYoda sharedYoda];
    if (sharedYoda) {
        __block NSString *path = [@"v0.9/core/Article.svc/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@/find/byidlist", sharedYoda.deploymentId, schemaName]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@&idlist=", sharedYoda.session]];
        
        [objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *number = (NSNumber*) obj;
            path = [path stringByAppendingString:[NSString stringWithFormat:@"%lld", number.longLongValue]];
            if (idx != objectIds.count - 1) {
                path = [path stringByAppendingString:@","];
            }
        }];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedYoda operationWithPath:urlEncodedPath];
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            DLog(@"%@", completedOperation.description);
            AYError *error = [AYHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
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
                failureBlock((AYError*) error);
            }
        }];
        [sharedYoda enqueueOperation:op];
    } else {
        DLog(@"Initialize the AppYoda object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

- (void) fetch {
    [self fetchWithFailureHandler:nil];
}

- (void) fetchWithFailureHandler:(AYFailureBlock)failureBlock {
    AppYoda *sharedYoda = [AppYoda sharedYoda];
    if (sharedYoda) {
        NSString *path = [@"v0.9/core/Article.svc/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%lld", sharedYoda.deploymentId, self.schemaType, [self.objectId longLongValue]]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@&idlist=", sharedYoda.session]];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedYoda operationWithPath:urlEncodedPath];
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            DLog(@"%@", completedOperation.description);
            AYError *error = [AYHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
            } else {
                DLog(@"%@", error.description);
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
        } onError:^(NSError *error) {
            DLog(@"%@", error.description);
            if (failureBlock != nil) {
                failureBlock((AYError*)error);
            }
        }];
        [sharedYoda enqueueOperation:op];
    } else {
        DLog(@"Initialize the AppYoda object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

#pragma mark save methods

- (void) saveObject {
    [self saveObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) saveObjectWithFailureHandler:(AYFailureBlock)failureBlock {
    [self saveObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) saveObjectWithSuccessHandler:(AYResultSuccessBlock)successBlock failureHandler:(AYFailureBlock)failureBlock {
    AppYoda *sharedYoda = [AppYoda sharedYoda];
    if (sharedYoda) {
        NSString *path = [@"v0.9/core/Article.svc/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@", sharedYoda.deploymentId, self.schemaType]];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?session=%@", sharedYoda.session]];
        NSString *urlEncodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        MKNetworkOperation *op = [sharedYoda operationWithPath:urlEncodedPath params:[self postParamerters] httpMethod:@"PUT"];
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            DLog(@"%@", completedOperation.description);
            AYError *error = [AYHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                [self setNewPropertyValuesFromDictionary:completedOperation.responseJSON];
                
                if (successBlock != nil) {
                    successBlock(completedOperation.responseJSON);
                }
            } else {
                DLog(@"%@", error.description);
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }
        } onError:^(NSError *error){
            DLog(@"%@", error.description);
            if (failureBlock != nil) {
                failureBlock((AYError*)error);
            }
        }];
        [sharedYoda enqueueOperation:op];
    } else {
        DLog(@"Initialize the AppYoda object with your API_KEY and DEPLOYMENT_ID in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
    }
}

#pragma mark add properties method

- (void) addPropertyWithKey:(NSString*) keyName value:(id) object {
    if (!self.properties) {
        _properties = [NSMutableArray array];
    }
    [_properties addObject:[NSDictionary dictionaryWithObject:object forKey:keyName]];
}

#pragma mark add attributes method

- (void) addAttributeWithKey:(NSString*) keyName value:(id) object {
    if (!self.attributes) {
        _attributes = [NSMutableArray array];
    }
    [_attributes addObject:[NSDictionary dictionaryWithObject:object forKey:keyName]];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Object Id:%lld, Created by:%@, Last updated by:%@, UTC date created:%@, UTC date updated:%@, Revision:%d, Properties:%@, Attributes:%@, SchemaId:%d, SchemaType:%@, Tag:%@", [self.objectId longLongValue], self.createdBy, self.lastUpdatedBy, self.utcDateCreated, self.utcLastUpdatedDate, self.revision, self.properties, self.attributes, self.schemaId, self.schemaType, self.tags];
}

#pragma mark private methods

- (void) setNewPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    NSDictionary *article = [dictionary objectForKey:@"Article"];
    _createdBy = (NSString*) [article objectForKey:@"__CreatedBy"];
    _objectId = (NSNumber*) [article objectForKey:@"__Id"];
    _lastUpdatedBy = (NSString*) [article objectForKey:@"__LastUpdatedBy"];
    _revision = (NSNumber*) [article objectForKey:@"__Revision"];
    _schemaId = (NSNumber*) [article objectForKey:@"__SchemaId"];
    _utcDateCreated = [self deserializeJsonDateString:[article objectForKey:@"__UtcDateCreated"]];
    _utcLastUpdatedDate = [self deserializeJsonDateString:[article objectForKey:@"__UtcLastUpdatedDate"]];
    _properties = [article objectForKey:@"__Properties"];
    _attributes = [article objectForKey:@"__Attributes"];
    _tags = [article objectForKey:@"__Tags"];
    _schemaType = [article objectForKey:@"__SchemaType"];
}

- (NSDate *) deserializeJsonDateString: (NSString *)jsonDateString {
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1;
    NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; 
    return [[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
}

- (NSMutableDictionary*) postParamerters {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    if (self.attributes)
        [postParams setObject:self.attributes forKey:@"__Attributes"];
    
    if (self.createdBy)
        [postParams setObject:self.createdBy forKey:@"__CreatedBy"];
    
    if (self.revision)
        [postParams setObject:self.revision forKey:@"__Revision"];

    if (self.properties)
        [postParams setObject:self.properties forKey:@"__Properties"];

    if (self.schemaType)
        [postParams setObject:self.schemaType forKey:@"__SchemaType"];

    if (self.tags)
        [postParams setObject:self.tags forKey:@"__Tags"];
    return postParams;
}
@end
