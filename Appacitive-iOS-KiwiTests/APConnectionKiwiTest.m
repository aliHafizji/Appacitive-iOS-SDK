/**
    
 Asynchronous test for APConnection.
 
 */


#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APConnection.h"

SPEC_BEGIN(APConnectionTests)

context(@"APConnectionKiwiTests", ^{
    
#pragma mark - Appacitive Session generation tests
    
    it(@"should verify that the session is not created for invalid API key and deploymentId", ^{
//        Bug ::: Issue Raised To Ali on GitHub  ::  Can be uncommented after issue resolution
//        [Appacitive appacitiveWithApiKey:@"+MmuqVgHVYH7Q" deploymentId:@"rest"];
        [[expectFutureValue([[Appacitive sharedObject] session]) shouldEventuallyBeforeTimingOutAfter(10.0)] beNil];
    });
    
    /**
     @purpose Test for valid API_KEY and DEPLOYMENT_ID
     @expected Session key object should not be nil
     */
    it(@"should verify that the session is created for valid API key and deploymentId", ^{
        
        [Appacitive appacitiveWithApiKey:@"+MmuqVgHVYH7Q+5imsGc4497fiuBAbBeCGYRkiQSCfY=" deploymentId:@"restaurantsearch"];
        [[expectFutureValue([[Appacitive sharedObject] session]) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    });
    
    
#pragma mark - APConnnection Creation Tests
    it(@"should verify that the APConnection is successfully created for valid ArticleId and CommentId", ^{
        __block BOOL isConnectionEstablished = NO;
        __block NSNumber *articleId1;
        __block NSNumber *articleId2;
        
        NSString *query = [NSString stringWithFormat:@"&pnum=1&psize=1"];
        
        APConnection *connection = [APConnection connectionWithRelationName:@"LocationComment"];
        [APObject searchForObjectsWithSchemaName:@"location" withQueryString:query
                                  successHandler:^(NSDictionary *result){
                                      NSArray *articles = result[@"Articles"];
                                      NSDictionary *dict = [articles lastObject];
                                      articleId1 = dict[@"__Id"];
                                      [APObject searchForObjectsWithSchemaName:@"comment" withQueryString:query
                                                                successHandler:^(NSDictionary *result){
                                                                    NSArray *articles = result[@"Articles"];
                                                                    NSDictionary *dict = [articles lastObject];
                                                                    articleId2 = dict[@"__Id"];
                                                                    
                                                                    [connection createConnectionWithObjectAId:articleId1 objectBId:articleId2 labelA:@"Location" labelB:@"Comment"
                                                                                               successHandler:^(void){
                                                                                                   isConnectionEstablished = YES;
                                                                                               }failureHandler:^(APError *error) {
                                                                                                   isConnectionEstablished = NO;
                                                                                               }];
                                                                } failureHandler:^(APError *error){
                                                                    isConnectionEstablished = NO;
                                                                }];
                                  } failureHandler:^(APError *error){
                                      isConnectionEstablished = NO;
                                  }];
        
        [[expectFutureValue(theValue(isConnectionEstablished)) shouldEventuallyBeforeTimingOutAfter(30.0)] equal:theValue(YES)];
    });
    
    
    it(@"should verify that the APConnection is not created for invalid Relation Name", ^{
        __block BOOL isConnectionEstablished = NO;
        APConnection *connection = [APConnection connectionWithRelationName:@"relationThatDoesNotExist"];
        [connection createConnectionWithObjectAId:[NSNumber numberWithLongLong:0] objectBId:[NSNumber numberWithLongLong:0] labelA:@"Location" labelB:@"Comment" successHandler:^(void){
            isConnectionEstablished = NO;
        }failureHandler:^(APError *error) {
            isConnectionEstablished = YES;
        }];
        
        [[expectFutureValue(theValue(isConnectionEstablished)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
    
    it(@"should verify that the APConnection is not created for invalid ArticleId and CommentId", ^{
        __block BOOL isConnectionEstablished = NO;
        APConnection *connection = [APConnection connectionWithRelationName:@"LocationComment"];
        [connection createConnectionWithObjectAId:[NSNumber numberWithLongLong:0] objectBId:[NSNumber numberWithLongLong:0] labelA:@"Location" labelB:@"Comment" successHandler:^(void){
            isConnectionEstablished = NO;
        }failureHandler:^(APError *error) {
            isConnectionEstablished = YES;
        }];
        [[expectFutureValue(theValue(isConnectionEstablished)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
    
#pragma mark - APConnection's Searching Tests
    
    it(@"should verify that the searching is successfully for valid relation name", ^{
        __block BOOL isSearchingSuccesfull = NO;
        [APConnection searchForAllConnectionsWithRelationName:@"LocationComment" successHandler:^(NSDictionary *result){
            isSearchingSuccesfull = YES;
        }failureHandler:^(APError *error){
            isSearchingSuccesfull = NO;
        }];
        [[expectFutureValue(theValue(isSearchingSuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
    it(@"should verify that the searching is unsuccessfully for invalid relation name", ^{
        __block BOOL isSearchingUnsuccesfull = NO;
        [APConnection searchForAllConnectionsWithRelationName:@"relationThatDoesNotExist" successHandler:^(NSDictionary *result){
            isSearchingUnsuccesfull = NO;
        }failureHandler:^(APError *error){
            isSearchingUnsuccesfull = YES;
        }];
        [[expectFutureValue(theValue(isSearchingUnsuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
#pragma mark - APConnection delete relation tests
    
    it(@"should verify that the APConnection objects is deleted successfully for valid relation name and ArticleID's", ^{
        __block BOOL isConnectionDeletionSuccessfull = NO;
        
        __block NSNumber *articleId1;
        __block NSNumber *articleId2;
        NSString *query = [NSString stringWithFormat:@"&pnum=1&psize=1"];
        
        [APObject searchForObjectsWithSchemaName:@"location" withQueryString:query
                                  successHandler:^(NSDictionary *result){
                                      NSArray *articles = result[@"Articles"];
                                      NSDictionary *dict = [articles lastObject];
                                      articleId1 = dict[@"__Id"];
                                      [APObject searchForObjectsWithSchemaName:@"comment" withQueryString:query
                                                                successHandler:^(NSDictionary *result){
                                                                    NSArray *articles = result[@"Articles"];
                                                                    NSDictionary *dict = [articles lastObject];
                                                                    articleId2 = dict[@"__Id"];
                                                                    
                                                                    [APConnection deleteConnectionsWithRelationName:@"LocationComment" objectIds:@[articleId1,articleId2] successHandler:^{
                                                                        isConnectionDeletionSuccessfull = YES;
                                                                    } failureHandler:^(APError *error){
                                                                        isConnectionDeletionSuccessfull = NO;
                                                                    }];
                                                                    
                                                                } failureHandler:^(APError *error){
                                                                    isConnectionDeletionSuccessfull = NO;
                                                                }];
                                  } failureHandler:^(APError *error){
                                      isConnectionDeletionSuccessfull = NO;
                                  }];
        [[expectFutureValue(theValue(isConnectionDeletionSuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
    
    it(@"should verify that the APConnection object is not deleted for invalid relation name and ArticleID's", ^{
        __block BOOL isConnectionDeletionUnsuccessfull = NO;
        [APConnection deleteConnectionsWithRelationName:@"relationThatDoesNotExist" objectIds:@[[NSNumber numberWithLongLong:5562780777316615],[NSNumber numberWithLongLong:5561664312312069]] successHandler:^{
            isConnectionDeletionUnsuccessfull = NO;
        } failureHandler:^(APError *error){
            isConnectionDeletionUnsuccessfull = YES;
        }];
        [[expectFutureValue(theValue(isConnectionDeletionUnsuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
    
    it(@"should verify that the APConnection object is deleted successfully for valid APConnection object", ^{
        __block BOOL isConnectionDeletedSuccessfully = NO;
        NSString *query = [NSString stringWithFormat:@"pnum=1&psize=1"];
        
        [APConnection searchForConnectionsWithRelationName:@"locationcomment" withQueryString:query
                                            successHandler:^(NSDictionary *result){
                                                NSArray *connections = result[@"Connections"];
                                                NSDictionary *dict = [connections lastObject];
                                                APConnection *connectionObject = [APConnection connectionWithRelationName:@"LocationComment"];
                                                connectionObject.objectId = dict[@"__Id"];
                                                [connectionObject deleteConnectionWithSuccessHandler:^{
                                                    isConnectionDeletedSuccessfully = YES;
                                                } failureHandler:^(APError *error){
                                                    isConnectionDeletedSuccessfully = NO;
                                                }];
                                            } failureHandler:^(APError *error){
                                                isConnectionDeletedSuccessfully = NO;
                                            }];
        
        [[expectFutureValue(theValue(isConnectionDeletedSuccessfully)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
#pragma mark - APConneciton fetch tests
    
    it(@"should verify that the APConnection is fetched successfully for valid APConnection objectId", ^{
        __block BOOL isFetchSuccesfull = NO;
        NSString *query = [NSString stringWithFormat:@"pnum=1&psize=1"];
        
        [APConnection searchForConnectionsWithRelationName:@"locationcomment" withQueryString:query
                                            successHandler:^(NSDictionary *result){
                                                NSArray *connections = result[@"Connections"];
                                                NSDictionary *dict = [connections lastObject];
                                                NSNumber *connectionId = dict[@"__Id"];
                                                [APConnection fetchConnectionWithRelationName:@"locationcomment" objectId:connectionId successHandler:^(NSDictionary *result){
                                                    isFetchSuccesfull = YES;
                                                } failureHandler:^(APError *error){
                                                    isFetchSuccesfull = NO;
                                                }];
                                            } failureHandler:^(APError *error){
                                                isFetchSuccesfull = NO;
                                            }];
        
        [[expectFutureValue(theValue(isFetchSuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
    it(@"should verify that the APConnection is not fetched for invalid APConnection objectId", ^{
        __block BOOL isFetchUnsuccesfull = NO; 
        
        [APConnection fetchConnectionWithRelationName:@"locationcomment" objectId:[NSNumber numberWithInt:2313] successHandler:^(NSDictionary *result){
            isFetchUnsuccesfull = NO;
        } failureHandler:^(APError *error){
            isFetchUnsuccesfull = YES;
        }];
        
        [[expectFutureValue(theValue(isFetchUnsuccesfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
    
});

SPEC_END