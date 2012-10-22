#import "Appacitive.h"
#import "APObject.h"
#import "APError.h"
#import "APQuery.h"

SPEC_BEGIN(APObjectTests)

context(@"APObjectTests", ^{
    
//#pragma mark - search functionality tests
//
//    it(@"Test case for searching all APObject's with valid Schema Name Failed", ^{
//        
//        __block BOOL isSearchSuccessfull = NO;
//        
//        [APObject searchForAllObjectsWithSchemaName:@"Comment"
//                                     successHandler:^(NSDictionary *result){
//                                         isSearchSuccessfull = YES;
//                                     }failureHandler:^(APError *error){
//                                         isSearchSuccessfull = NO;
//                                     }];
//        [[expectFutureValue(theValue(isSearchSuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    it(@"Test case for searching all APObject's with invalid Schema Name Failed", ^{
//        
//        __block BOOL isSearchingUnsuccessfull = NO;
//        
//        [APObject searchForAllObjectsWithSchemaName:@"invalidSchemaName"
//                                     successHandler:^(NSDictionary *result){
//                                         isSearchingUnsuccessfull = NO;
//                                     }failureHandler:^(APError *error){
//                                         isSearchingUnsuccessfull = YES;
//                                     }];
//        [[expectFutureValue(theValue(isSearchingUnsuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    it(@"Test case for searching all APObject's with nil Schema Name Failed", ^{
//        
//        __block BOOL isSearchingUnsuccessfull = NO;
//        
//        [APObject searchForAllObjectsWithSchemaName:nil
//                                     successHandler:^(NSDictionary *result){
//                                         isSearchingUnsuccessfull = NO;
//                                     }failureHandler:^(APError *error){
//                                         isSearchingUnsuccessfull = YES;
//                                     }];
//        [[expectFutureValue(theValue(isSearchingUnsuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//    
//#pragma mark - Fetch articles tests
//    
//    it(@"Test case for fetching APObject with valid articleId and valid schema name Failed", ^{
//        
//       __block BOOL isFetchSuccessfull = NO;
//        
//        __block NSNumber *articleId;
//        NSString *query = [NSString stringWithFormat:@"&pnum=1&psize=1"];
//        
//        [APObject searchForObjectsWithSchemaName:@"Comment" withQueryString:query
//                                  successHandler:^(NSDictionary *result){
//                                      NSArray *articles = result[@"Articles"];
//                                      NSDictionary *dict = [articles lastObject];
//                                      articleId = dict[@"__Id"];
//                                      [APObject fetchObjectWithObjectId:articleId schemaName:@"Comment"
//                                                successHandler:^(NSDictionary *result){
//                                                    isFetchSuccessfull = YES;
//                                                }failureHandler:^(APError *error){
//                                                    isFetchSuccessfull = NO;
//                                        }];
//                                  }failureHandler:^(APError *error){
//                                      isFetchSuccessfull = NO;
//                                  }];
//        [[expectFutureValue(theValue(isFetchSuccessfull)) shouldEventuallyBeforeTimingOutAfter(20.0)] equal:theValue(YES)];
//    });
//    
//    it(@"Test case for fetching APObjects with invalid articleId and invalid schema name Failed", ^{
//        
//        __block BOOL isFetchUnsuccessfull = NO;
//        
//        [APObject fetchObjectWithObjectId:[NSNumber numberWithInt:0] schemaName:@"schemaThatDoesNotExist"
//                           successHandler:^(NSDictionary *result){
//                               isFetchUnsuccessfull = NO;
//                           }failureHandler:^(APError *error){
//                               isFetchUnsuccessfull = YES;
//                           }];
//        [[expectFutureValue(theValue(isFetchUnsuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
//    
//#pragma mark - Save Functionality tests
//    
//    it(@"Test case for saving an APObject for proper schema name Failed", ^{
//        
//        __block BOOL isSaveSuccessfull = NO;
//        
//        APObject *object = [[APObject alloc] initWithSchemaName:@"location"];
//        [object setCreatedBy:@"Sandeep Dhull"];
//
//        [object addPropertyWithKey:@"Name" value:@"Tavisca"];
//        [object addPropertyWithKey:@"Category" value:@"arts"];
//        [object addPropertyWithKey:@"Description" value:@"Tavisca artists works here"];
//        [object addPropertyWithKey:@"Address" value:@"Eon It Park Kharadi"];
//        [object addPropertyWithKey:@"GeoCodes" value:@"18.551678,73.954275"];
//        
//        [object saveObjectWithSuccessHandler:^(NSDictionary *result){
//            isSaveSuccessfull = YES;
//        }failureHandler:^(APError *error){
//            isSaveSuccessfull = NO;
//        }];
//        
//        [[expectFutureValue(theValue(isSaveSuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
    
//    it(@"Alis test", ^{
//        __block BOOL hasFailed = NO;
//        APObject *object = [[APObject alloc] initWithSchemaName:@"location"];
//        object.objectId = @1;
//        [object fetchWithFailureHandler:^(APError *error){
//            hasFailed = YES;
//        }];
//        [[expectFutureValue(theValue(hasFailed)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
    
//    it(@"Test case for saving an APObject with improper schema name Failed", ^{
//        __block BOOL isSaveUnsuccessfull = NO;
//        APObject *object = [[APObject alloc] initWithSchemaName:@"schemaThatDoesNotExist"];
//        
//        [object setCreatedBy:@"Sandeep Dhull"];
//        NSDictionary *property1 = @{@"Key":@"Name",@"Value":@"Tavisca"};
//        [object addProperty:property1];
//        
//        NSDictionary *property2 = @{@"Key":@"Category",@"Value":@"arts"};
//        [object addProperty:property2];
//        
//        NSDictionary *property3 = @{@"Key":@"Description",@"Value":@"Tavisca artists works here"};
//        [object addProperty:property3];
//        
//        NSDictionary *property4 = @{@"Key":@"Address",@"Value":@"Eon It Park Kharadi"};
//        [object addProperty:property4];
//        
//        NSDictionary *property5 = @{@"Key":@"GeoCodes",@"Value":@"18.551678,73.954275"};
//        [object addProperty:property5];
//        
//        [object saveObjectWithSuccessHandler:^(NSDictionary *result){
//            isSaveUnsuccessfull = NO;
//        }failureHandler:^(APError *error){
//            isSaveUnsuccessfull = YES;
//        }];
//        [[expectFutureValue(theValue(isSaveUnsuccessfull)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });
    
    
//#pragma mark - Delete articles object
//    
//    it(@"Test case for deleting an APObject with proper schema name Failed", ^{
//        __block BOOL isDeletedSuccessfully = NO;
//        
//        __block NSNumber *articleId;
//        NSString *query = [NSString stringWithFormat:@"&pnum=1&psize=1"];
//        
//        [APObject searchForObjectsWithSchemaName:@"location" withQueryString:query
//                                  successHandler:^(NSDictionary *result){
//                                      NSArray *articles = result[@"Articles"];
//                                      NSDictionary *dict = [articles lastObject];
//                                      articleId = dict[@"__Id"];
//                                      APObject *object = [[APObject alloc] initWithSchemaName:@"location"];
//                                      [object setObjectId:articleId];
//                                      [object deleteObjectWithSuccessHandler:^(void){
//                                          isDeletedSuccessfully = YES;
//                                      }failureHandler:^(APError *error){
//                                          isDeletedSuccessfully = NO;
//                                      }];
//                                  }failureHandler:^(APError *error){
//                                      isDeletedSuccessfully = NO;
//                                  }];
//        [[expectFutureValue(theValue(isDeletedSuccessfully)) shouldEventuallyBeforeTimingOutAfter(20.0)] equal:theValue(YES)];
//    });
//    
//    it(@"Test case for deleting an APObject with improper schema name Failed", ^{
//        __block BOOL isDeletionFailed = NO;
//        APObject *object = [[APObject alloc] initWithSchemaName:@"schemaThatDoesNotExist"];
//        [object setObjectId:[NSNumber numberWithLongLong:2319381902900]];
//        [object deleteObjectWithSuccessHandler:^(void){
//            isDeletionFailed = NO;
//        }failureHandler:^(APError *error){
//            isDeletionFailed = YES;
//        }];
//        [[expectFutureValue(theValue(isDeletionFailed)) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:theValue(YES)];
//    });    
//    
});

SPEC_END