//
//  AYResponseBlocks.h
//  AYoda-iOS example
//
//  Created by Kauserali Hafizji on 29/08/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

@class AYError;

typedef void (^AYSuccessBlock)();

typedef void (^AYResultSuccessBlock)(NSDictionary *result);

typedef void (^AYFullResponseSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON);

typedef void (^AYFailureBlock)(AYError *error);

typedef void (^AYFullResponseFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);