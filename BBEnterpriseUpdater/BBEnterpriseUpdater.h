//
//  BBEnterpriseUpdater.h
//  BBEnterpriseUpdater
//
//  Created by Eli Perkins on 2/5/13.
//  Copyright (c) 2013 One Mighty Roar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBEnterpriseUpdater : NSObject

+ (void)checkVersionWithURL:(NSURL *)url success:(void (^)(BOOL requiresUpdate, NSString *versionString, NSURL *updateURL))success failure:(void (^)(NSError *error))failure;
+ (void)checkVersionWithURLRequest:(NSURLRequest *)urlRequest
                           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *responseObject))success
                           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
@end
