//
// Created by Aaron Sarazan on 3/14/14.
// Copyright (c) 2014 Manotaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBAbstractMessage;

@interface ASEndpoint : NSObject

@property (readonly) Class responseClass;
@property (readonly, strong) PBAbstractMessage *request;

- (void)fetch:(void (^)(id response))callback;

- (instancetype)initWithRequest:(PBAbstractMessage *)request responseClass:(Class)responseClass;

// Implement in subclass if needed
- (NSString *)path;
- (NSDictionary *)headers;
- (void)onPrefetch:(NSMutableURLRequest *)request;
- (void)onPostfetch;
- (void)onSuccess:(id)response;
- (void)onFailure:(NSError *)error;

@end