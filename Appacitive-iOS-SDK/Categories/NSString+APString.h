//
//  NSString+APString.h
//  Appacitive-iOS-SDK
//
//  Originally written by Blake Watters on 6/15/11
//  Refactored by Kauserali on 25/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

/**
 A library of helpful additions to the NSString class to simplify
 common tasks within Appacitive-iOS-SDK
 */
@interface NSString (APString)

/**
 Returns a resource path from a dictionary of query parameters URL encoded and appended
 This is a convenience method for constructing a new resource path that includes a query. For example,
 when given a resourcePath of /contacts and a dictionary of parameters containing foo=bar and color=red,
 will return /contacts?foo=bar&amp;color=red
 
 *NOTE *- Assumes that the resource path does not already contain any query parameters.
 @param queryParameters A dictionary of query parameters to be URL encoded and appended to the resource path
 @return A new resource path with the query parameters appended
 */
- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)queryParameters;
- (NSString *)appendQueryParams:(NSDictionary *)queryParams DEPRECATED_ATTRIBUTE;

/**
 Returns a dictionary of parameter keys and values using UTF-8 encoding given a URL-style query string
 on the receiving object. For example, when given the string /contacts?foo=bar&amp;color=red,
 this will return a dictionary of parameters containing foo=bar and color=red, excluding the path "/contacts?"
 
 @param receiver A string in the form of @"/object/?sortBy=name", or @"/object/?sortBy=name&amp;color=red"
 @return A new dictionary of query parameters, with keys like 'sortBy' and values like 'name'.
 */
- (NSDictionary *)queryParameters;

/**
 Returns a dictionary of parameter keys and values given a URL-style query string
 on the receiving object. For example, when given the string /contacts?foo=bar&amp;color=red,
 this will return a dictionary of parameters containing foo=bar and color=red, excludes the path "/contacts?"
 
 This method originally appeared as queryContentsUsingEncoding: in the Three20 project:
 https://github.com/facebook/three20/blob/master/src/Three20Core/Sources/NSStringAdditions.m
 
 @param receiver A string in the form of @"/object/?sortBy=name", or @"/object/?sortBy=name&amp;color=red"
 @param encoding The encoding for to use while parsing the query string.
 @return A new dictionary of query parameters, with keys like 'sortBy' and values like 'name'.
 */
- (NSDictionary *)queryParametersUsingEncoding:(NSStringEncoding)encoding;

/**
 Returns a dictionary of parameter keys and values arrays (if requested) given a URL-style query string
 on the receiving object. For example, when given the string /contacts?foo=bar&amp;color=red,
 this will return a dictionary of parameters containing foo=[bar] and color=[red], excludes the path "/contacts?"
 
 This method originally appeared as queryContentsUsingEncoding: in the Three20 project:
 https://github.com/facebook/three20/blob/master/src/Three20Core/Sources/NSStringAdditions.m
 
 @param receiver A string in the form of @"/object?sortBy=name", or @"/object?sortBy=name&amp;color=red"
 @param shouldUseArrays If NO, it yields the same results as queryParametersUsingEncoding:, otherwise it creates value arrays instead of value strings.
 @param encoding The encoding for to use while parsing the query string.
 @return A new dictionary of query parameters, with keys like 'sortBy' and value arrays (if requested) like ['name'].
 @see queryParametersUsingEncoding:
 */
- (NSDictionary *)queryParametersUsingArrays:(BOOL)shouldUseArrays encoding:(NSStringEncoding)encoding;

/**
 Returns a URL encoded representation of self.
 */
- (NSString *)stringByAddingURLEncoding;
@end
