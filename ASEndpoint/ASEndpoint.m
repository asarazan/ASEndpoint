//
// Created by Aaron Sarazan on 3/14/14.
// Copyright (c) 2014 Manotaur Games. All rights reserved.
//

#import <ProtocolBuffers/AbstractMessage.h>
#import "ASEndpoint.h"
#import "AFHTTPRequestOperation.h"
#import "Descriptor.pb.h"

@implementation ASEndpoint

- (instancetype)initWithRequest:(id)request responseClass:(Class)responseClass;
{
    self = [super init];
    if (self) {
        _request = request;
        _responseClass = responseClass;
    }
    return self;
}

- (void)fetch:(void (^)(id response))callback;
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.path]];
    [request setHTTPBody:[_request data]];
    [request setValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:self.headers];
    [self onPrefetch:request];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        id response = [_responseClass parseFromData:data];
        [self onSuccess:response];
        callback(response);
        [self onPostfetch];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onFailure:error];
        [self onPostfetch];
    }];
    [op start];
}

- (NSString *)path; {
    [NSException raise:@"IllegalInheritance" format:@"Must override path"];
    return nil;
}

- (NSDictionary *)headers;
{
    return @{};
}

- (void)onPrefetch:(NSMutableURLRequest *)request;
{

}

- (void)onPostfetch;
{

}

- (void)onSuccess:(id)response;
{

}

- (void)onFailure:(NSError *)error;
{

}


@end