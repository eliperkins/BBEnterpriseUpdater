//
//  BBEnterpriseUpdater.m
//  BBEnterpriseUpdater
//
//  Created by Eli Perkins on 2/5/13.
//  Copyright (c) 2013 One Mighty Roar. All rights reserved.
//

#import "BBEnterpriseUpdater.h"
#import <AFNetworking/AFPropertyListRequestOperation.h>

@interface BBEnterpriseUpdater ()
+ (NSOperationQueue *)gc_sharedPropertyListRequestOperationQueue;
@end

@implementation BBEnterpriseUpdater

+ (NSOperationQueue *)gc_sharedPropertyListRequestOperationQueue {
    static NSOperationQueue *_sharedPropertyListRequestOperationQueue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPropertyListRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_sharedPropertyListRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return _sharedPropertyListRequestOperationQueue;
}

+ (void)checkVersionWithURL:(NSURL *)url success:(void (^)(BOOL requiresUpdate, NSString *versionString, NSURL *updateURL))success failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setHTTPShouldUsePipelining:YES];
    [urlRequest addValue:@"application/x-plist" forHTTPHeaderField:@"Accept"];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];

    [self checkVersionWithURLRequest:urlRequest success:^(__unused NSURLRequest *request, __unused NSHTTPURLResponse *response, NSDictionary *responseObject) {
        if (success) {
            NSDictionary *plistDict = responseObject;
            NSDictionary *itemDict = [[plistDict objectForKey:@"items"] objectAtIndex:0];
            NSDictionary *metadata = [itemDict objectForKey:@"metadata"];
            NSString *versionString = [metadata objectForKey:@"bundle-version"];
            success([self requiresUpdateForRemoteVersion:versionString], versionString, [self updateURLForPlistURL:url]);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)checkVersionWithURLRequest:(NSURLRequest *)urlRequest
                           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *responseObject))success
                           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    AFPropertyListRequestOperation *requestOperation = [[AFPropertyListRequestOperation alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error);
        }
    }];
    
    [[self gc_sharedPropertyListRequestOperationQueue] addOperation:requestOperation];
}

     
+ (BOOL)requiresUpdateForRemoteVersion:(NSString *)remoteVersion {
    NSString* requiredVersion = remoteVersion;
    NSString* actualVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending) {
        // actualVersion is lower than the requiredVersion
        return YES;
    }
    return NO;
}

+ (NSURL *)updateURLForPlistURL:(NSURL *)url {
    NSString *updateString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", url.absoluteString];
    return [NSURL URLWithString:updateString];
}

@end
