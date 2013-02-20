#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"
#import "APConnection.h"

SPEC_BEGIN(APConnectionTests)

describe(@"APConnectionTests", ^{

    beforeAll(^() {
        __block Appacitive *appacitive = [Appacitive appacitiveWithApiKey:API_KEY];
        [[expectFutureValue(appacitive.session) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
    });
    
    afterAll(^(){
        [Appacitive setSharedObject:nil];
    });

#pragma mark TESTING_RETRIEVE_PROPERTY
    
    it(@"should not return a nil value for retrieving a valid property", ^{
        APConnection *connection = [APConnection connectionWithRelationType:@"Test"];
        [connection addPropertyWithKey:@"Test" value:@"Testing"];
        
        id property = [connection getPropertyWithKey:@"Test"];
        [property shouldNotBeNil];
    });
    
#pragma mark TESTING_FETCH_REQUEST
    
    it(@"should not return an error for fetching a connection with a valid object and relationtype", ^{
        __block BOOL isFetchSuccessful = NO;
        
        [APConnection searchForAllConnectionsWithRelationType:@"list_items"
                      successHandler:^(NSArray *connections) {
                          
                          APConnection *conn = [APConnection connectionWithRelationType:@"list_items"];
                          conn.objectId = ((APConnection*)connections[0]).objectId;
                          [conn fetchConnectionWithSuccessHandler:^(){
                              isFetchSuccessful = YES;
                          } failureHandler:^(APError *error) {
                              isFetchSuccessful = NO;
                          }];
                          
                      } failureHandler:^(APError *error) {
                          isFetchSuccessful = NO;
                      }];
        [[expectFutureValue(theValue(isFetchSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    

#pragma mark UPDATE_PROPERTY_TEST
    
    it(@"should not return an error for updating an property of a connection", ^{
        __block BOOL isUpdateSuccessful = NO;
        
        [APConnection searchForAllConnectionsWithRelationType:@"list_items"
                                               successHandler:^(NSArray *connections) {
                                                   
                                                       __block APConnection *conn = [APConnection connectionWithRelationType:@"list_items"];
                                                       conn.objectId = ((APConnection*)connections[0]).objectId;
                                                       [conn fetchConnectionWithSuccessHandler:^(){
                                                           [conn updatePropertyWithKey:@"test" value:@"test2"];
                                                           [conn updateConnectionWithSuccessHandler:^() {
                                                               isUpdateSuccessful = YES;
                                                           } failureHandler:^(APError *error) {
                                                               isUpdateSuccessful = NO;
                                                           }];
                                                       } failureHandler:^(APError *error) {
                                                           isUpdateSuccessful = NO;
                                                       }];
                                                   
                                               } failureHandler:^(APError *error) {
                                                   isUpdateSuccessful = NO;
                                               }];
        
        [[expectFutureValue(theValue(isUpdateSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

/*
#pragma mark UPDATE_ATTRIBUTE_TEST
    
    it(@"should not return an error for updating an attribute of a connection", ^{
        __block BOOL isUpdateSuccessful = NO;
        
        __block APConnection *connection = [APConnection connectionWithRelationType:@"deals"];
        connection.objectId = [NSNumber numberWithLongLong:15896978683725594];
        [connection fetchConnectionWithSuccessHandler:^(){
            [connection updateAttributeWithKey:@"test" value:@"value2"];
            [connection updateConnectionWithSuccessHandler:^() {
                isUpdateSuccessful = YES;
            } failureHandler:nil];
        } failureHandler:nil];
        
        [[expectFutureValue(theValue(isUpdateSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
#pragma mark DELETE_ATTRIBUTE_TEST
    
    it(@"should not return an error for deleting an attribute of a connection", ^{
        __block BOOL isDeleteSuccessful = NO;
        
        __block APConnection *connection = [APConnection connectionWithRelationType:@"deals"];
        connection.objectId = [NSNumber numberWithLongLong:15896978683725594];
        [connection fetchConnectionWithSuccessHandler:^(){
            [connection removeAttributeWithKey:@"test"];
            [connection updateConnectionWithSuccessHandler:^() {
                isDeleteSuccessful = YES;
            } failureHandler:nil];
        } failureHandler:nil];
        
        [[expectFutureValue(theValue(isDeleteSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
*/
#pragma mark CREATION_TESTS
    
    it(@"should not return an error while creating the connection with proper objectIds", ^{
        __block BOOL isConnectionCreated = NO;
        
        __block APObject *listItem = [APObject objectWithSchemaName:@"todolists"];
        [listItem addPropertyWithKey:@"list_name" value:@"Test_Case"];
        
        [listItem saveObjectWithSuccessHandler:^() {
            
                        __block APObject *task = [APObject objectWithSchemaName:@"tasks"];
                        [task addPropertyWithKey:@"text" value:@"Test_Case"];
                        [task saveObjectWithSuccessHandler:^() {
                            
                            APConnection *connection = [APConnection connectionWithRelationType:@"list_items"];
                            [connection createConnectionWithObjectAId:listItem.objectId
                                        objectBId:task.objectId
                                        labelA:@"todolists"
                                        labelB:@"tasks"
                                        successHandler:^(){
                                            isConnectionCreated = YES;
                                        } failureHandler:^(APError *error) {
                                            isConnectionCreated = NO;
                                        }];
                        } failureHandler:^(APError *error) {
                            isConnectionCreated = NO;
                        }];
                    } failureHandler:^(APError *error) {
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
            searchForAllConnectionsWithRelationType:@"list_items"
            successHandler:^(NSArray *connections){
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
            successHandler:^(NSArray *connections){
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
    /*
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
        
        [APObject searchObjectsWithSchemaName:@"list_items" withQueryString:query
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

    */
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
            searchForConnectionsWithRelationType:@"list_items"
            withQueryString:query
            successHandler:^(NSArray *connections) {
                
                APConnection *connectionObject = [APConnection connectionWithRelationType:@"list_items"];
                connectionObject.objectId = ((APConnection*)connections[0]).objectId;;
                
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
        
        [APConnection searchForConnectionsWithRelationType:@"list_items"
                        withQueryString:query
                        successHandler:^(NSArray *connections){
                           
                            [APConnection
                                fetchConnectionWithRelationType:@"list_items"
                                objectId:((APConnection*)connections[0]).objectId
                                successHandler:^(APConnection *connection){
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
            fetchConnectionWithRelationType:@"list_item"
            objectId:@-2313
            successHandler:^(APConnection *connection){
                isFetchUnsuccesful = NO;
            } failureHandler:^(APError *error){
                isFetchUnsuccesful = YES;
            }];

        [[expectFutureValue(theValue(isFetchUnsuccesful)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
    });
});
SPEC_END