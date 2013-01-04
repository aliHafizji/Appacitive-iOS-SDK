#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"

SPEC_BEGIN(APObjectFixture)

describe(@"APObject", ^{
    
    beforeAll(^() {
        __block Appacitive *appacitive = [Appacitive appacitiveWithApiKey:API_KEY];
        [[Appacitive sharedObject] setEnableLiveEnvironment:YES];
        [[expectFutureValue(appacitive.session) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
    });
    
    afterAll(^(){
        [Appacitive setSharedObject:nil];
    });
    
#pragma mark SEARCH_TESTS
    
    it(@"should return non-nil for search API call with valid schema name", ^{
        __block BOOL isSearchSuccessful = NO;
        
        [APObject searchAllObjectsWithSchemaName:@"Comment"
                                     successHandler:^(NSDictionary *result){
                                         isSearchSuccessful = YES;
                                     }failureHandler:^(APError *error){
                                         isSearchSuccessful = NO;
                                     }];
        [[expectFutureValue(theValue(isSearchSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should return an error for search API call with invalid schema name", ^{
        
        __block BOOL isSearchUnsuccessful = NO;
        [APObject searchAllObjectsWithSchemaName:@"invalidSchemaName"
                                     successHandler:^(NSDictionary *result){
                                         isSearchUnsuccessful = NO;
                                     }failureHandler:^(APError *error){
                                         isSearchUnsuccessful = YES;
                                     }];
        [[expectFutureValue(theValue(isSearchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should return an error for search API call with nil schema name", ^{
        
        __block BOOL isSearchUnsuccessful = NO;
        [APObject searchAllObjectsWithSchemaName:nil
                                     successHandler:^(NSDictionary *result){
                                         isSearchUnsuccessful = NO;
                                     }failureHandler:^(APError *error){
                                         isSearchUnsuccessful = YES;
                                     }];
        [[expectFutureValue(theValue(isSearchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should not return an error for search API call with valid query string", ^(){
        __block BOOL isSearchSuccessful = NO;
        NSString *query = [APQuery queryStringForPageNumber:1];
        [APObject searchObjectsWithSchemaName:@"location"
                               withQueryString:query
                               successHandler:^(NSDictionary *result) {
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
                               successHandler:^(NSDictionary *result) {
                                   isSearchUnSuccessful = NO;
                               } failureHandler:^(APError *error) {
                                   isSearchUnSuccessful = YES;
                               }];
        [[expectFutureValue(theValue(isSearchUnSuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];

    });
    
#pragma mark FETCH_TESTS

    it(@"should return valid article for fetch API call with valid articleId and valid schema name", ^{
       __block BOOL isFetchSuccessful = NO;
        __block NSNumber *articleId;
        NSString *pnumString = [APQuery queryStringForPageNumber:1];
        NSString *psizeString = [APQuery queryStringForPageSize:1];
        
        NSString *query = [NSString stringWithFormat:@"%@&%@", pnumString, psizeString];
        
        [APObject searchObjectsWithSchemaName:@"Comment" withQueryString:query
                                  successHandler:^(NSDictionary *result){
                                      NSArray *articles = result[@"articles"];
                                      NSDictionary *dict = [articles lastObject];
                                      articleId = dict[@"__id"];
                                      [APObject fetchObjectWithObjectId:articleId schemaName:@"Comment"
                                                successHandler:^(NSDictionary *result){
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
                           successHandler:^(NSDictionary *result){
                               isFetchUnsuccessful = NO;
                           }failureHandler:^(APError *error){
                               isFetchUnsuccessful = YES;
                           }];
        [[expectFutureValue(theValue(isFetchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });

    it(@"should not return an error for muti fetch API call with valid object ids and valid schema name", ^(){
        __block BOOL isMultiFetchSuccessful = NO;
        
        NSString *query = [APQuery queryStringForPageSize:2];
        [APObject searchObjectsWithSchemaName:@"location"
                                  withQueryString:query
                                  successHandler:^(NSDictionary *result){
                                      NSArray *articles = result[@"articles"];
                                      NSMutableArray *objectIds = [NSMutableArray arrayWithCapacity:articles.count];
                                      for(NSDictionary *dict in articles) {
                                          [objectIds addObject:dict[@"__id"]];
                                      }
                                      
                                      [APObject fetchObjectsWithObjectIds:objectIds
                                                         schemaName:@"location"
                                                         successHandler:^(NSDictionary *result){
                                                             isMultiFetchSuccessful = YES;
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
                             successHandler:^(NSDictionary *result){
                                 isMultiFetchUnsuccessful = NO;
                             } failureHandler:^(APError *error){
                                 isMultiFetchUnsuccessful = YES;
                             }];
        [[expectFutureValue(theValue(isMultiFetchUnsuccessful)) shouldEventuallyBeforeTimingOutAfter(5.0)] equal:theValue(YES)];
    });
    
    it(@"should not return an error for fetch API call with valid object id", ^(){
        
        __block APObject *object;
        NSString *query = [APQuery queryStringForPageSize:1];
        
        [APObject searchObjectsWithSchemaName:@"location"
                            withQueryString:query
                            successHandler:^(NSDictionary *result) {
                                NSArray *articles = result[@"articles"];
                                NSDictionary *dict = articles[0];
                                
                                NSNumber *objectId = dict[@"__id"];
                                
                                object = [APObject objectWithSchemaName:@"location"];
                                object.objectId = objectId;
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
    
#pragma mark SAVE_TESTS
    
    it(@"should not return an error for save API call with valid schema name", ^{
        
        __block BOOL isSaveSuccessful = NO;
        APObject *object = [[APObject alloc] initWithSchemaName:@"location"];
        [object setCreatedBy:@"Sandeep Dhull"];
        [object addPropertyWithKey:@"Name" value:@"Tavisca"];
        [object addPropertyWithKey:@"Category" value:@"arts"];
        [object addPropertyWithKey:@"Description" value:@"Tavisca artists works here"];
        [object addPropertyWithKey:@"Address" value:@"Eon It Park Kharadi"];
        [object addPropertyWithKey:@"GeoCodes" value:@"18.551678,73.954275"];
        
        [object saveObjectWithSuccessHandler:^(NSDictionary *result){
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
        
        [object saveObjectWithSuccessHandler:^(NSDictionary *result){
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
    
#pragma mark GRAPH_QUERY_TESTS
    
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
    });
});
SPEC_END