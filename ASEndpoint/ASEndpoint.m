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

#import <ProtocolBuffers/AbstractMessage.h>
#import "ASEndpoint.h"
#import "Descriptor.pb.h"
#import "CueSyncDictionary.h"
#import "ISPPinnedNSURLConnectionDelegate.h"
#import "ISPCertificatePinning.h"

@implementation ASEndpoint {
    NSMutableData *_data;
    CueSyncDictionary *_callbacks;
    ISPPinnedNSURLConnectionDelegate *_pinDelegate;
}

- (instancetype)initWithRequest:(id)request responseClass:(Class)responseClass;
{
    self = [super init];
    if (self) {
        _request = request;
        _responseClass = responseClass;
        _data = [NSMutableData data];
        _callbacks = [CueSyncDictionary dictionary];
        _pinDelegate = [[ISPPinnedNSURLConnectionDelegate alloc] init];
    }
    return self;
}

- (void)fetch:(ASEndpointCallback)callback;
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.path]];
    [request setHTTPBody:[_request data]];
    [request setValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:self.headers];
    [self onPrefetch:request];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    if (callback) {
        _callbacks[@(conn.hash)] = [callback copy];
    }
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    @try {
        id response = [_responseClass parseFromData:_data];
        [self onSuccess:response];
        ASEndpointCallback callback = _callbacks[@(connection.hash)];
        if (callback) {
            callback(response);
        }
    } @catch (NSException *e) {
        [self onFailure:nil];
    }
    [self onPostfetch];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    [self onFailure:error];
    [self onPostfetch];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    return [_pinDelegate connection:connection willSendRequestForAuthenticationChallenge:challenge];
}

- (NSString *)path; {
    [NSException raise:@"IllegalInheritance" format:@"Must override path"];
    return nil;
}

- (NSDictionary *)headers;
{
    return @{};
}

- (NSData *)pinnedCertificate;
{
    return nil;
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

+ (BOOL)setupSSLPinsUsingDictionnary:(NSDictionary*)domainsAndCertificates;
{
    return [ISPCertificatePinning setupSSLPinsUsingDictionnary:domainsAndCertificates];
}

@end