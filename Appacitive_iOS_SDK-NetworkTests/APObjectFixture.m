#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"

SPEC_BEGIN(APObjectFixture)

describe(@"APObject", ^{
    
    beforeAll(^() {
        __block Appacitive *appacitive = [Appacitive appacitiveWithApiKey:API_KEY];
        [[expectFutureValue(appacitive.session) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
    });
    
    afterAll(^(){
        [Appacitive setSharedObject:nil];
    });
    
#pragma mark SEARCH_TESTS
    
    it(@"should return non-nil for search API call with valid schema name", ^{
        __block BOOL isSearchSuccessful = NO;
        
        [APObject searchAllObjectsWithSchemaName:@"todolists"
                                     successHandler:^(NSArray *objects){
                                         isSearchSuccessful = YES;
                                     }failureHandler:^(APError *error){
                                         isSearchSuccessful = NO;
                                     }];
        [[expectFutureValue(theValue(isSearchSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should return an error for search API call with invalid schema name", ^{
        
        __block BOOL isSearchUnsuccessful = NO;
        [APObject searchAllObjectsWithSchemaName:@"invalidSchemaName"
                                     successHandler:^(NSArray *objects){
                                         isSearchUnsuccessful = NO;
                                     }failureHandler:^(APError *error){
                                         isSearchUnsuccessful = YES;
                                     }];
        [[expectFutureValue(theValue(isSearchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should return an error for search API call with nil schema name", ^{
        
        __block BOOL isSearchUnsuccessful = NO;
        [APObject searchAllObjectsWithSchemaName:nil
                                     successHandler:^(NSArray *objects){
                                         isSearchUnsuccessful = NO;
                                     }failureHandler:^(APError *error){
                                         isSearchUnsuccessful = YES;
                                     }];
        [[expectFutureValue(theValue(isSearchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should not return an error for search API call with valid query string", ^(){
        __block BOOL isSearchSuccessful = NO;
        NSString *query = [APQuery queryStringForPageNumber:1];
        [APObject searchObjectsWithSchemaName:@"todolists"
                               withQueryString:query
                               successHandler:^(NSArray *objects) {
                                   isSearchSuccessful = YES;
                               } failureHandler:^(APError *error) {
                                   isSearchSuccessful = NO;
                               }];
        [[expectFutureValue(theValue(isSearchSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should return an error for search API call with invalid query string", ^(){
        __block BOOL isSearchUnSuccessful = NO;
        [APObject searchObjectsWithSchemaName:@"location"
                              withQueryString:@"abc=++1"
                               successHandler:^(NSArray *objects) {
                                   isSearchUnSuccessful = NO;
                               } failureHandler:^(APError *error) {
                                   isSearchUnSuccessful = YES;
                               }];
        [[expectFutureValue(theValue(isSearchUnSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];

    });
    
#pragma mark FETCH_TESTS

    it(@"should return valid article for fetch API call with valid articleId and valid schema name", ^{
       __block BOOL isFetchSuccessful = NO;
        
        NSString *pnumString = [APQuery queryStringForPageNumber:1];
        NSString *psizeString = [APQuery queryStringForPageSize:1];
        
        NSString *query = [NSString stringWithFormat:@"%@&%@", pnumString, psizeString];
        
        [APObject searchObjectsWithSchemaName:@"todolists" withQueryString:query
                                  successHandler:^(NSArray *objects){
                                      
                                      APObject *object = objects[0];
                                      [APObject fetchObjectWithObjectId:object.objectId schemaName:@"todolists"
                                                successHandler:^(NSArray *objects){
                                                    isFetchSuccessful = YES;
                                                }failureHandler:^(APError *error){
                                                    isFetchSuccessful = NO;
                                        }];
                                  }failureHandler:^(APError *error){
                                      isFetchSuccessful = NO;
                                  }];
        [[expectFutureValue(theValue(isFetchSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should return an error for fetch API call with invalid articleId and invalid schema name", ^{
        
        __block BOOL isFetchUnsuccessful = NO;
        
        [APObject fetchObjectWithObjectId:[NSNumber numberWithInt:0] schemaName:@"schemaThatDoesNotExist"
                           successHandler:^(NSArray *objects){
                               isFetchUnsuccessful = NO;
                           }failureHandler:^(APError *error){
                               isFetchUnsuccessful = YES;
                           }];
        [[expectFutureValue(theValue(isFetchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should not return an error for muti fetch API call with valid object ids and valid schema name", ^(){
        __block BOOL isMultiFetchSuccessful = NO;
        
        NSString *query = [APQuery queryStringForPageSize:2];
        [APObject searchObjectsWithSchemaName:@"todolists"
                                  withQueryString:query
                                  successHandler:^(NSArray *objects){
                                      
                                      NSMutableArray *objectIds = [NSMutableArray arrayWithCapacity:objects.count];
                                      for(APObject *object in objects) {
                                          [objectIds addObject:object.objectId];
                                      }
                                      
                                      [APObject fetchObjectsWithObjectIds:objectIds
                                                         schemaName:@"todolists"
                                                         successHandler:^(NSArray *objects){
                                                             isMultiFetchSuccessful = YES;
                                                             NSLog(@"%@", objects.description);
                                                         } failureHandler:^(APError *error) {
                                                             isMultiFetchSuccessful = NO;
                                                         }];
                                  } failureHandler:^(APError *error) {
                                      isMultiFetchSuccessful = NO;
                                  }];
        [[expectFutureValue(theValue(isMultiFetchSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should return an error for multi fetch for invalid object ids and invalid schema name", ^(){
        __block BOOL isMultiFetchUnsuccessful = NO;
        [APObject fetchObjectsWithObjectIds:@[@-123, @-1]
                             schemaName:@"location"
                             successHandler:^(NSArray *objects){
                                 isMultiFetchUnsuccessful = NO;
                             } failureHandler:^(APError *error){
                                 isMultiFetchUnsuccessful = YES;
                             }];
        [[expectFutureValue(theValue(isMultiFetchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should not return an error for fetch API call with valid object id", ^(){
        
        __block APObject *object;
        NSString *query = [APQuery queryStringForPageSize:1];
        
        [APObject searchObjectsWithSchemaName:@"todolists"
                            withQueryString:query
                            successHandler:^(NSArray *objects) {
                                
                                object = [APObject objectWithSchemaName:@"todolists"];
                                object.objectId = ((APObject*)objects[0]).objectId;
                                [object fetch];
                            } failureHandler:^(APError *error){
                                object = nil;
                            }];
        [[expectFutureValue(object.properties) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        
    });
    
    it(@"should return an error for fetch API call with invalid object id", ^(){
        __block BOOL isFetchUnsuccessful = NO;
        
        APObject *object = [APObject objectWithSchemaName:@"location"];
        object.objectId = @-200;
        [object fetchWithFailureHandler:^(APError *error) {
            isFetchUnsuccessful = YES;
        }];
        [[expectFutureValue(theValue(isFetchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
#pragma mark TESTING_GET_PROPERTIES_METHOD
    
    it(@"should not return an error for retrieving a valid property with key", ^{
        
        APObject *object = [APObject objectWithSchemaName:@"Test"];
        [object addPropertyWithKey:@"test" value:@"Another test"];
        
        id property = [object getPropertyWithKey:@"test"];
        [property shouldNotBeNil];
    });
    
#pragma mark TESTING_UPDATE_PROPERTIES_METHOD
    
    it(@"should not return an error for updating a property of an APObject", ^{
        
        __block BOOL isUpdateSuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"todolists"];
        [object addPropertyWithKey:@"list_name" value:@"Test_Case"];
        
        [object saveObjectWithSuccessHandler:^(){
            [object updatePropertyWithKey:@"list_name" value:@"Test"];
            [object updateObjectWithSuccessHandler:^() {
                isUpdateSuccessful = YES;
            } failureHandler:^(APError *error) {
                isUpdateSuccessful = NO;
            }];
        }failureHandler:^(APError *error){
            isUpdateSuccessful = NO;
        }];
        
        [[expectFutureValue(theValue(isUpdateSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

#pragma mark TESTING_DELETE_PROPERTIES_METHOD
    
    it(@"should not return an error for deleting a property of an APObject", ^{
        
        __block BOOL isDeleteSuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"todolists"];
        [object addPropertyWithKey:@"list_name" value:@"Test_Case"];
        
        [object saveObjectWithSuccessHandler:^(){
            [object removePropertyWithKey:@"list_name"];
            
            [object updateObjectWithSuccessHandler:^(){
                isDeleteSuccessful = YES;
            } failureHandler:^(APError *error) {
                isDeleteSuccessful = NO;
            }];
        }failureHandler:^(APError *error){
            isDeleteSuccessful = NO;
        }];
        
        [[expectFutureValue(theValue(isDeleteSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
/*
#pragma mark TESTING_UPDATE_ATTRIBUTES_METHOD
    
    it(@"should not return an error for updating an attribute of an APObject", ^{
        
        __block BOOL isUpdateSuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"location"];
        [object setCreatedBy:@"Sandeep Dhull"];
        [object addPropertyWithKey:@"Name" value:@"Tavisca"];
        [object addPropertyWithKey:@"Category" value:@"arts"];
        [object addPropertyWithKey:@"Description" value:@"Tavisca artists works here"];
        [object addPropertyWithKey:@"Address" value:@"Eon It Park Kharadi"];
        [object addPropertyWithKey:@"GeoCodes" value:@"18.551678,73.954275"];
        
        [object addAttributeWithKey:@"Test" value:@"value"];
        [object addAttributeWithKey:@"Test2" value:@"value"];
        
        [object saveObjectWithSuccessHandler:^(NSDictionary *result){
            [object updateAttributeWithKey:@"test" value:@"value3"];
            [object updateObjectWithSuccessHandler:^(NSDictionary *result){
                isUpdateSuccessful = YES;
            } failureHandler:^(APError *error) {
                isUpdateSuccessful = NO;
            }];
        }failureHandler:^(APError *error){
            isUpdateSuccessful = NO;
        }];
        
        [[expectFutureValue(theValue(isUpdateSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
#pragma mark TESTING_DELETE_ATTRIBUTES_METHOD
    
    it(@"should not return an error for updating an attribute of an APObject", ^{
        
        __block BOOL isDeleteSuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"location"];
        [object setCreatedBy:@"Sandeep Dhull"];
        [object addPropertyWithKey:@"Name" value:@"Tavisca"];
        [object addPropertyWithKey:@"Category" value:@"arts"];
        [object addPropertyWithKey:@"Description" value:@"Tavisca artists works here"];
        [object addPropertyWithKey:@"Address" value:@"Eon It Park Kharadi"];
        [object addPropertyWithKey:@"GeoCodes" value:@"18.551678,73.954275"];
        
        [object addAttributeWithKey:@"Test" value:@"value"];
        [object addAttributeWithKey:@"Test2" value:@"value"];
        
        [object saveObjectWithSuccessHandler:^(NSDictionary *result){
            [object removeAttributeWithKey:@"test"];
            [object updateObjectWithSuccessHandler:^(NSDictionary *result){
                isDeleteSuccessful = YES;
            } failureHandler:^(APError *error) {
                isDeleteSuccessful = NO;
            }];
        }failureHandler:^(APError *error){
            isDeleteSuccessful = NO;
        }];
        
        [[expectFutureValue(theValue(isDeleteSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
*/
#pragma mark SAVE_TESTS
    
    it(@"should not return an error for save API call with valid schema name", ^{
        
        __block BOOL isSaveSuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"todolists"];
        [object addPropertyWithKey:@"list_name" value:@"Test_Case"];
        
        [object saveObjectWithSuccessHandler:^(){
            isSaveSuccessful = YES;
        }failureHandler:^(APError *error){
            isSaveSuccessful = NO;
        }];
        
        [[expectFutureValue(theValue(isSaveSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"Test case for saving an APObject with improper schema name Failed", ^{
        __block BOOL isSaveUnsuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"schemaThatDoesNotExist"];
        
        [object setCreatedBy:@"Sandeep Dhull"];
        [object setCreatedBy:@"Sandeep Dhull"];
        [object addPropertyWithKey:@"Name" value:@"Tavisca"];
        [object addPropertyWithKey:@"Category" value:@"arts"];
        [object addPropertyWithKey:@"Description" value:@"Tavisca artists works here"];
        [object addPropertyWithKey:@"Address" value:@"Eon It Park Kharadi"];
        [object addPropertyWithKey:@"GeoCodes" value:@"18.551678,73.954275"];
        
        [object saveObjectWithSuccessHandler:^(){
            isSaveUnsuccessful = NO;
        }failureHandler:^(APError *error){
            isSaveUnsuccessful = YES;
        }];
        [[expectFutureValue(theValue(isSaveUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    
#pragma mark DELETE_TESTS

    it(@"should return an error for delete API call with improper schema name", ^{
        __block BOOL isDeleteUnsuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"schemaThatDoesNotExist"];
        [object setObjectId:[NSNumber numberWithLongLong:2319381902900]];
        [object deleteObjectWithSuccessHandler:^(void){
            isDeleteUnsuccessful = NO;
        }failureHandler:^(APError *error){
            isDeleteUnsuccessful = YES;
        }];
        [[expectFutureValue(theValue(isDeleteUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    /*
    it(@"should not return an error for delete call for a proper article id", ^{
        __block BOOL isDeleteSuccessful = NO;
        
        APObject *object = [[APObject alloc] initWithSchemaName:@"location"];
        [object setObjectId:[NSNumber numberWithLongLong:15334317711557540]];
        
        [object deleteObjectWithConnectingConnectionsSuccessHandler:^(){
            isDeleteSuccessful = YES;
        } failureHandler:^(APError *error) {
            isDeleteSuccessful = NO;
        }];
        [[expectFutureValue(theValue(isDeleteSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });*/
    
#pragma mark GRAPH_QUERY_TESTS
    /*
    it(@"should not return an error for a valid filter graph query", ^{
        __block BOOL isFilterQuerySuccessful = NO;
        
        [APObject applyFilterGraphQuery:@"{\"Children\": [{\"Edge\": \"LocationAlbum\",\"Name\": \"Images\"}, {\"Edge\": \"LocationComment\",\"Name\": \"Comments\"}],\"Input\": [926256],\"Name\": \"Location\",\"Type\": \"Location\"}"
         
                         successHandler:^(NSDictionary* result) {
                             isFilterQuerySuccessful = YES;
                         } failureHandler:^(APError *error) {
                             isFilterQuerySuccessful = NO;
                         }];
        
        [[expectFutureValue(theValue(isFilterQuerySuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should not return an error for a valid projection graph query", ^{
        __block BOOL isFilterQuerySuccessful = NO;
        
        [APObject applyProjectionGraphQuery:@"{\"Children\": [{\"Edge\": \"LocationAlbum\",\"Name\": \"Images\"}, {\"Edge\": \"LocationComment\",\"Name\": \"Comments\"}],\"Input\": [926256],\"Name\": \"Location\",\"Type\": \"Location\"}"
         
                         successHandler:^(NSDictionary* result) {
                             isFilterQuerySuccessful = YES;
                         } failureHandler:^(APError *error) {
                             isFilterQuerySuccessful = NO;
                         }];
        
        [[expectFutureValue(theValue(isFilterQuerySuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });*/
});
SPEC_END