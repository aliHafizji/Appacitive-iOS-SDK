#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APConnection.h"

SPEC_BEGIN(APConnectionTests)

//context(@"APConnectionTests", ^{

#pragma mark - Appacitive Session generation tests
    
//    it(@"Test case for creating a session with invalid API key and deploymentId Failed", ^{
//        [Appacitive appacitiveWithApiKey:@"+MmuqVgHVYH7Q" deploymentId:@"rest"];
//        [[expectFutureValue([[Appacitive sharedObject] session]) shouldEventuallyBeforeTimingOutAfter(10.0)] beNil];
//    });
    
    /**
     @purpose Test for valid API_KEY and DEPLOYMENT_ID
     @expected Session key object should not be nil
     */
    it(@"Test case for creating a session with valid API key and deploymentId Failed", ^{
        
        [Appacitive appacitiveWithApiKey:@"+MmuqVgHVYH7Q+5imsGc4497fiuBAbBeCGYRkiQSCfY=" deploymentId:@"restaurantsearch"];
        [[expectFutureValue([[Appacitive sharedObject] session]) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    });

    it(@"ALIS TEST", ^(){
        __block BOOL hasFailed = NO;
        APConnection *connection = [[APConnection alloc] initWithRelationType:@"locationcomment"];
        connection.objectId = @5109813520498983;
        [connection deleteConnectionWithSuccessHandler:^(){} failureHandler:^(APError *error){}];
        [[expectFutureValue(theValue(hasFailed)) shouldEventuallyBeforeTimingOutAfter(30.0)] equal:theValue(YES)];
    });
//
//
//#pragma mark - APConnnection Creation Tests
//    it(@"Test case for creating a APConnection with valid ArticleId and CommentId Failed", ^{
//        __block BOOL isConnectionCreated = NO;
//        __block NSNumber *articleId1;
//        __block NSNumber *articleId2;
//        
//        NSString *query = [NSString stringWithFormat:@"&pnum=1&psize=1"];
//        
//        APConnection *connection = [APConnection connectionWithRelationName:@"LocationComment"];
//        [APObject searchForObjectsWithSchemaName:@"location" withQueryString:query
//                                  successHandler:^(NSDictionary *result){
//                                      NSArray *articles = result[@"Articles"];
//                                      NSDictionary *dict = [articles lastObject];
//                                      articleId1 = dict[@"__Id"];
//                                      [APObject searchForObjectsWithSchemaName:@"comment" withQueryString:query
//                                                                successHandler:^(NSDictionary *result){
//                                                                    NSArray *articles = result[@"Articles"];
//                                                                    NSDictionary *dict = [articles lastObject];
//                                                                    articleId2 = dict[@"__Id"];
//                                                                    
//                                                                    [connection createConnectionWithObjectAId:articleId1 objectBId:articleId2 labelA:@"Location" labelB:@"Comment"
//                                                                                               successHandler:^(void){
//                                                                                                   isConnectionCreated = YES;
//                                                                                               }failureHandler:^(APError *error) {
//                                                                                                   isConnectionCreated = NO;
//                                                                                               }];
//                                                                } failureHandler:^(APError *error){
//                                                                    isConnectionCreated = NO;
//                                                                }];
//                                  } failureHandler:^(APError *error){
//                                      isConnectionCreated = NO;
//                                  }];
//        
//        [[expectFutureValue(theValue(isConnectionCreated)) shouldEventuallyBeforeTimingOutAfter(30.0)] equal:theValue(YES)];
//    });
//    
//    
//    it(@"Test case for creating a APConnection with invalid Relation Name Failed", ^{
//        __block BOOL isConnectionCreated = NO;
//        APConnection *connection = [APConnection connectionWithRelationName:@"relationThatDoesNotExist"];
//        [connection createConnectionWithObjectAId:[NSNumber numberWithLongLong:0] objectBId:[NSNumber numberWithLongLong:0] labelA:@"Location" labelB:@"Comment" successHandler:^(void){
//            isConnectionCreated = NO;
//        }failureHandler:^(APError *error) {
//            isConnectionCreated = YES;
//        }];
//        
//        [[expectFutureValue(theValue(isConnectionCreated)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    
//    it(@"Test case for creating a APConnection with invalid ArticleId and CommentId Failed", ^{
//        __block BOOL isConnectionCreated = NO;
//        APConnection *connection = [APConnection connectionWithRelationName:@"LocationComment"];
//        [connection createConnectionWithObjectAId:[NSNumber numberWithLongLong:0] objectBId:[NSNumber numberWithLongLong:0] labelA:@"Location" labelB:@"Comment" successHandler:^(void){
//            isConnectionCreated = NO;
//        }failureHandler:^(APError *error) {
//            isConnectionCreated = YES;
//        }];
//        [[expectFutureValue(theValue(isConnectionCreated)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    
//#pragma mark - APConnection's Searching Tests
//    
//    it(@"Test case for searching all APConnection's objects with valid relation name Failed", ^{
//        __block BOOL isSearchingSuccesfull = NO;
//        [APConnection searchForAllConnectionsWithRelationName:@"LocationComment" successHandler:^(NSDictionary *result){
//            isSearchingSuccesfull = YES;
//        }failureHandler:^(APError *error){
//            isSearchingSuccesfull = NO;
//        }];
//        [[expectFutureValue(theValue(isSearchingSuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });

    
//
//    it(@"Test case for searching all APConnection's objects with invalid relation name Failed", ^{
//        __block BOOL isSearchingUnsuccesfull = NO;
//        [APConnection searchForAllConnectionsWithRelationName:@"relationThatDoesNotExist" successHandler:^(NSDictionary *result){
//            isSearchingUnsuccesfull = NO;
//        }failureHandler:^(APError *error){
//            isSearchingUnsuccesfull = YES;
//        }];
//        [[expectFutureValue(theValue(isSearchingUnsuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//#pragma mark - APConnection delete relation tests
//    
//    it(@"Test case for deleting an APConnection object with valid relation name and invalid ArticleID's Failed", ^{
//        __block BOOL isConnectionDeletionSuccessfull = NO;
//        
//        __block NSNumber *articleId1;
//        __block NSNumber *articleId2;
//        NSString *query = [NSString stringWithFormat:@"&pnum=1&psize=1"];
//        
//        [APObject searchForObjectsWithSchemaName:@"location" withQueryString:query
//                                  successHandler:^(NSDictionary *result){
//                                      NSArray *articles = result[@"Articles"];
//                                      NSDictionary *dict = [articles lastObject];
//                                      articleId1 = dict[@"__Id"];
//                                      [APObject searchForObjectsWithSchemaName:@"comment" withQueryString:query
//                                                                successHandler:^(NSDictionary *result){
//                                                                    NSArray *articles = result[@"Articles"];
//                                                                    NSDictionary *dict = [articles lastObject];
//                                                                    articleId2 = dict[@"__Id"];
//                                                                    
//                                                                    [APConnection deleteConnectionsWithRelationName:@"LocationComment" objectIds:@[articleId1,articleId2] successHandler:^{
//                                                                        isConnectionDeletionSuccessfull = NO;
//                                                                    } failureHandler:^(APError *error){
//                                                                        isConnectionDeletionSuccessfull = YES;
//                                                                    }];
//                                                                    
//                                                                } failureHandler:^(APError *error){
//                                                                    isConnectionDeletionSuccessfull = NO;
//                                                                }];
//                                  } failureHandler:^(APError *error){
//                                      isConnectionDeletionSuccessfull = NO;
//                                  }];
//        [[expectFutureValue(theValue(isConnectionDeletionSuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    
//    it(@"Test case for deleting an APConnection object with invalid relation name and ArticleID's Failed", ^{
//        __block BOOL isConnectionDeletionUnsuccessfull = NO;
//        [APConnection deleteConnectionsWithRelationName:@"relationThatDoesNotExist" objectIds:@[[NSNumber numberWithLongLong:5562780777316615],[NSNumber numberWithLongLong:5561664312312069]] successHandler:^{
//            isConnectionDeletionUnsuccessfull = NO;
//        } failureHandler:^(APError *error){
//            isConnectionDeletionUnsuccessfull = YES;
//        }];
//        [[expectFutureValue(theValue(isConnectionDeletionUnsuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    
//    it(@"Test case for deleting an APConnection object with valid APConnection objectId Failed", ^{
//        __block BOOL isConnectionDeletedSuccessfully = NO;
//        NSString *query = [NSString stringWithFormat:@"pnum=1&psize=1"];
//        
//        [APConnection searchForConnectionsWithRelationName:@"locationcomment" withQueryString:query
//                                            successHandler:^(NSDictionary *result){
//                                                NSArray *connections = result[@"Connections"];
//                                                NSDictionary *dict = [connections lastObject];
//                                                APConnection *connectionObject = [APConnection connectionWithRelationName:@"LocationComment"];
//                                                connectionObject.objectId = dict[@"__Id"];
//                                                [connectionObject deleteConnectionWithSuccessHandler:^{
//                                                    isConnectionDeletedSuccessfully = YES;
//                                                } failureHandler:^(APError *error){
//                                                    isConnectionDeletedSuccessfully = NO;
//                                                }];
//                                            } failureHandler:^(APError *error){
//                                                isConnectionDeletedSuccessfully = NO;
//                                            }];
//        
//        [[expectFutureValue(theValue(isConnectionDeletedSuccessfully)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//#pragma mark - APConneciton fetch tests
//    
//    it(@"Test case for fetching an APConnection object with valid APConnection objectId Failed", ^{
//        __block BOOL isFetchSuccesfull = NO;
//        NSString *query = [NSString stringWithFormat:@"pnum=1&psize=1"];
//        
//        [APConnection searchForConnectionsWithRelationName:@"locationcomment" withQueryString:query
//                                            successHandler:^(NSDictionary *result){
//                                                NSArray *connections = result[@"Connections"];
//                                                NSDictionary *dict = [connections lastObject];
//                                                NSNumber *connectionId = dict[@"__Id"];
//                                                [APConnection fetchConnectionWithRelationName:@"locationcomment" objectId:connectionId successHandler:^(NSDictionary *result){
//                                                    isFetchSuccesfull = YES;
//                                                } failureHandler:^(APError *error){
//                                                    isFetchSuccesfull = NO;
//                                                }];
//                                            } failureHandler:^(APError *error){
//                                                isFetchSuccesfull = NO;
//                                            }];
//        
//        [[expectFutureValue(theValue(isFetchSuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    it(@"Test case for fetching an APConnection object with invalid APConnection objectId", ^{
//        __block BOOL isFetchUnsuccesfull = NO; 
//        
//        [APConnection fetchConnectionWithRelationName:@"locationcomment" objectId:[NSNumber numberWithInt:2313] successHandler:^(NSDictionary *result){
//            isFetchUnsuccesfull = NO;
//        } failureHandler:^(APError *error){
//            isFetchUnsuccesfull = YES;
//        }];
//        
//        [[expectFutureValue(theValue(isFetchUnsuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//});

SPEC_END