/*
 * Copyright 2014 Aaron Sarazan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

@class PBAbstractMessage;

typedef void (^ASEndpointCallback)(id response);

@interface ASEndpoint : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (readonly) Class responseClass;
@property (readonly, strong) PBAbstractMessage *request;

- (void)fetch:(ASEndpointCallback)callback;

- (instancetype)initWithRequest:(PBAbstractMessage *)request responseClass:(Class)responseClass;

// Implement in subclass if needed
- (NSString *)path;
- (NSDictionary *)headers;
- (void)onPrefetch:(NSMutableURLRequest *)request;
- (void)onPostfetch;
- (void)onSuccess:(id)response;
- (void)onFailure:(NSError *)error;

+ (BOOL)setupSSLPinsUsingDictionnary:(NSDictionary*)domainsAndCertificates;

@end