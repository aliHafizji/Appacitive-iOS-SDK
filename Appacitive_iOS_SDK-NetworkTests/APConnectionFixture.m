#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"
#import "APConnection.h"

SPEC_BEGIN(APConnectionTests)

describe(@"APConnectionTests", ^{

    beforeAll(^() {
        __block Appacitive *appacitive = [Appacitive appacitiveWithApiKey:API_KEY];
        [[Appacitive sharedObject] setEnableLiveEnvironment:YES];
        [[expectFutureValue(appacitive.session) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
    });
    
    afterAll(^(){
        [Appacitive setSharedObject:nil];
    });
    
#pragma mark CREATION_TESTS
    
    it(@"should not return an error while creating the connection with proper objectIds", ^{
        __block BOOL isConnectionCreated = NO;
        __block NSNumber *objectId1;
        __block NSNumber *objectId2;
        
        NSString *pnum = [APQuery queryStringForPageNumber:1];
        NSString *psize = [APQuery queryStringForPageSize:1];
        
        NSString *query = [NSString stringWithFormat:@"%@&%@", pnum, psize];

        APConnection *connection = [APConnection connectionWithRelationType:@"LocationComment"];
        [APObject searchObjectsWithSchemaName:@"location" withQueryString:query
                                  successHandler:^(NSDictionary *result){
                                      NSArray *articles = result[@"articles"];
                                      NSDictionary *dict = [articles lastObject];
                                      objectId1 = dict[@"__id"];
                                      [APObject searchObjectsWithSchemaName:@"comment" withQueryString:query
                                                    successHandler:^(NSDictionary *result){
                                                        NSArray *articles = result[@"articles"];
                                                        NSDictionary *dict = [articles lastObject];
                                                        objectId2 = dict[@"__id"];
                                                        
                                                        [connection createConnectionWithObjectAId:objectId1 objectBId:objectId2 labelA:@"Location" labelB:@"Comment"
                                                                                   successHandler:^(void){
                                                                                       isConnectionCreated = YES;
                                                                                   }failureHandler:^(APError *error) {
                                                                                       isConnectionCreated = NO;
                                                                                   }];
                                                    } failureHandler:^(APError *error){
                                                        isConnectionCreated = NO;
                                                    }];
                                  } failureHandler:^(APError *error){
                                      isConnectionCreated = NO;
                                  }];
        
        [[expectFutureValue(theValue(isConnectionCreated)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });

     
    it(@"should return an error for creating a connection with invalid relation type", ^{
        __block BOOL isConnectionCreatFailed = NO;
        
        APConnection *connection = [APConnection connectionWithRelationType:@"relationThatDoesNotExist"];
        [connection createConnectionWithObjectAId:@0
                        objectBId:@0
                        labelA:@"Location"
                        labelB:@"Comment"
                        successHandler:^(void){
                            isConnectionCreatFailed = NO;
                        } failureHandler:^(APError *error) {
                            isConnectionCreatFailed = YES;
                        }];
        
        [[expectFutureValue(theValue(isConnectionCreatFailed)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    
    it(@"should return an error while creating a connection with invalid object id and comment id", ^{
        __block BOOL isConnectionCreated = NO;
        APConnection *connection = [APConnection connectionWithRelationType:@"LocationComment"];
        [connection createConnectionWithObjectAId:@0
                    objectBId:@0
                    labelA:@"Location"
                    labelB:@"Comment"
                    successHandler:^(void){
                        isConnectionCreated = NO;
                    }failureHandler:^(APError *error) {
                        isConnectionCreated = YES;
                    }];
        [[expectFutureValue(theValue(isConnectionCreated)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    
#pragma mark SEARCH_TESTS
    
    it(@"should not return an error while search for valid relation types", ^{
        __block BOOL isSearchingSuccesful = NO;
        [APConnection
            searchForAllConnectionsWithRelationType:@"LocationComment"
            successHandler:^(NSDictionary *result){
                isSearchingSuccesful = YES;
            } failureHandler:^(APError *error){
                isSearchingSuccesful = NO;
            }];
        [[expectFutureValue(theValue(isSearchingSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    

    it(@"should return an error while search for invalid connections", ^{
        __block BOOL isSearchingUnsuccesful = NO;
        [APConnection
            searchForAllConnectionsWithRelationType:@"relationThatDoesNotExist"
            successHandler:^(NSDictionary *result){
                isSearchingUnsuccesful = NO;
            } failureHandler:^(APError *error){
                isSearchingUnsuccesful = YES;
            }];
        [[expectFutureValue(theValue(isSearchingUnsuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    pending_(@"should not return an error with search call along with valid query string", ^(){
    
    });
    
    pending_(@"should return an error with search call along with invalid query string", ^(){
        
    });
    
#pragma mark INTERCONNECTS_TESTS
//    Write test here
    it(@"should return not an error while search for valid objectIds", ^{
        __block BOOL isSearchingSuccesful = NO;
        NSArray * objectIds = [NSArray arrayWithObjects:@"12094464603586988",@"926377",@"926372",@"926364",nil];
        NSNumber * objectId = [NSNumber numberWithLongLong:926345];
        [APConnection searchAllConnectionsFromObjectId:objectId toObjectIds:objectIds withSuccessHandler:^(NSDictionary *results){
            NSLog(@"Success block %@" , [results description]);
            isSearchingSuccesful = YES;
        }failureHandler:^(APError *error) {
            NSLog(@"Failure block %@" , [error description]);
            isSearchingSuccesful = NO;
        }];
        [[expectFutureValue(theValue(isSearchingSuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should return an error while search for invalid objectIds", ^{
        __block BOOL isSearchingUnsuccesful = NO;
        NSArray * objectIds = [NSArray arrayWithObjects:@"15896369232480359",@"15896362656860262",@"15896351207458582",@"15896338793367317",nil];
        NSNumber * objectId = [NSNumber numberWithLongLong:-34432233];
        [APConnection searchAllConnectionsFromObjectId:objectId toObjectIds:objectIds withSuccessHandler:^(NSDictionary *results){
            NSLog(@"Success block %@" , [results description]);
            isSearchingUnsuccesful = NO;
        }failureHandler:^(APError *error) {
            NSLog(@"Failure block %@" , [error description]);
            isSearchingUnsuccesful = YES;
        }];
        [[expectFutureValue(theValue(isSearchingUnsuccesful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
#pragma mark DELETE_TESTS

    it(@"should not return an error for the delete call with valid relation name and valid objectid", ^{
        __block BOOL isConnectionDeletionSuccessful = NO;
        
        __block NSNumber *articleId1;
        __block NSNumber *articleId2;
        NSString *query = [NSString stringWithFormat:@"&pnum=1&psize=1"];
        
        [APObject searchObjectsWithSchemaName:@"location" withQueryString:query
                              successHandler:^(NSDictionary *result){
                                  NSArray *articles = result[@"articles"];
                                  NSDictionary *dict = [articles lastObject];
                                  articleId1 = dict[@"__id"];
                                  [APObject searchObjectsWithSchemaName:@"comment" withQueryString:query
                                                successHandler:^(NSDictionary *result){
                                                    NSArray *articles = result[@"articles"];
                                                    NSDictionary *dict = [articles lastObject];
                                                    articleId2 = dict[@"__id"];
                                                    
                                                    [APConnection
                                                     deleteConnectionsWithRelationType:@"LocationComment"
                                                     objectIds:@[articleId1,articleId2]
                                                     successHandler:^{
                                                         isConnectionDeletionSuccessful = YES;
                                                     } failureHandler:^(APError *error){
                                                         isConnectionDeletionSuccessful = NO;
                                                     }];
                                                    
                                                } failureHandler:^(APError *error){
                                                    isConnectionDeletionSuccessful = NO;
                                                }];
                              } failureHandler:^(APError *error){
                                  isConnectionDeletionSuccessful = NO;
                              }];
        [[expectFutureValue(theValue(isConnectionDeletionSuccessful)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });

    
    it(@"should return an error for delete call using invalid relation type and object id", ^{
        __block BOOL isConnectionDeletionUnsuccessful = NO;
        [APConnection
            deleteConnectionsWithRelationType:@"relationThatDoesNotExist"
            objectIds:@[@-12,@-21]
            successHandler:^{
                isConnectionDeletionUnsuccessful = NO;
            } failureHandler:^(APError *error){
                isConnectionDeletionUnsuccessful = YES;
            }];
        [[expectFutureValue(theValue(isConnectionDeletionUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    
    it(@"should not through an error while deleting a connection with valid objectid", ^{
        __block BOOL isConnectionDeleted = NO;
        
        NSString *pnum = [APQuery queryStringForPageNumber:1];
        NSString *psize = [APQuery queryStringForPageSize:1];
        NSString *query = [NSString stringWithFormat:@"%@&%@", pnum, psize];

        [APConnection
            searchForConnectionsWithRelationType:@"locationcomment"
            withQueryString:query
            successHandler:^(NSDictionary *result) {
                NSArray *connections = result[@"connections"];
                NSDictionary *dict = [connections lastObject];
                
                APConnection *connectionObject = [APConnection connectionWithRelationType:@"LocationComment"];
                connectionObject.objectId = dict[@"__id"];
                
                [connectionObject deleteConnectionWithSuccessHandler:^{
                    isConnectionDeleted = YES;
                } failureHandler:^(APError *error){
                    isConnectionDeleted = NO;
                }];
            } failureHandler:^(APError *error){
                isConnectionDeleted = NO;
            }];
        
        [[expectFutureValue(theValue(isConnectionDeleted)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });

#pragma mark FETCH_TESTS
    
    it(@"should not return an error for fetch call with valid object id", ^{
        
        __block BOOL isFetchSuccesful = NO;
        
        NSString *pnum = [APQuery queryStringForPageNumber:1];
        NSString *psize = [APQuery queryStringForPageSize:1];
        NSString *query = [NSString stringWithFormat:@"%@&%@", pnum, psize];
        
        [APConnection searchForConnectionsWithRelationType:@"locationcomment"
                        withQueryString:query
                        successHandler:^(NSDictionary *result){
                            NSArray *connections = result[@"connections"];
                            NSDictionary *dict = [connections lastObject];
                            NSNumber *connectionId = dict[@"__id"];
                            [APConnection
                                fetchConnectionWithRelationType:@"locationcomment"
                                objectId:connectionId
                                successHandler:^(NSDictionary *result){
                                    isFetchSuccesful = YES;
                                } failureHandler:^(APError *error){
                                    isFetchSuccesful = NO;
                                }];
                        } failureHandler:^(APError *error){
                            isFetchSuccesful = NO;
                        }];
        
        [[expectFutureValue(theValue(isFetchSuccesful)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });

    it(@"should return an error for fetch call with invalid object id", ^{
        __block BOOL isFetchUnsuccesful = NO; 
        
        [APConnection
            fetchConnectionWithRelationType:@"locationcomment"
            objectId:@-2313
            successHandler:^(NSDictionary *result){
                isFetchUnsuccesful = NO;
            } failureHandler:^(APError *error){
                isFetchUnsuccesful = YES;
            }];

        [[expectFutureValue(theValue(isFetchUnsuccesful)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
});
SPEC_END