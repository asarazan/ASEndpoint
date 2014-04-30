//
//  ISPPinnedNSURLSessionDelegate.m
//  SSLCertificatePinning
//
//  Created by Alban Diquet on 1/14/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//
#import <Foundation/NSURLSession.h>

#import "ISPPinnedNSURLSessionDelegate.h"
#import "ISPCertificatePinning.h"


@implementation ISPPinnedNSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
        NSString *domain = [[challenge protectionSpace] host];

        // (asarazan) changed this to work with self-generated cert
        // Look for a pinned certificate in the server's certificate chain
        if ([ISPCertificatePinning verifyPinnedCertificateForTrust:serverTrust andDomain:domain]) {

            // Found the certificate; continue connecting
            completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
        }
        else {
            // The certificate wasn't found in the certificate chain; cancel the connection
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
        }
    }
}

@end
