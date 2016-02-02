//
//  BTRConnectionHelper.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-31.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRConnectionHelper.h"
#import "BTRSettingManager.h"

@implementation BTRConnectionHelper

+ (void)postDataToURL:(NSString *)url withParameters:(NSDictionary *)param setSessionInHeader:(BOOL)needSession contentType:(ContentType)contentType success:(void (^) (NSDictionary *response))success faild:(void (^) (NSError *error))faild {
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.validatesDomainName = NO;
    [manager setSecurityPolicy:securityPolicy];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:contentType];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (needSession)
        [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager.requestSerializer setValue:[[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERAGENT] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager POST:url
       parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
           if (success)
               success(entitiesPropertyList);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (faild)
               faild(error);
       }];
    
}

+ (void)getDataFromURL:(NSString *)url withParameters:(NSDictionary *)param setSessionInHeader:(BOOL)needSession contentType:(ContentType)contentType success:(void (^) (NSDictionary *response,NSString *jSonString))success faild:(void (^) (NSError *error))faild {
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.validatesDomainName = NO;
    [manager setSecurityPolicy:securityPolicy];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:contentType];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (needSession)
        [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager.requestSerializer setValue:[[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERAGENT] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSString *jSonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            success(entitiesPropertyList,jSonString);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (faild)
            faild(error);
    }];
}

+ (void)putDataFromURL:(NSString *)url withParameters:(NSDictionary *)param setSessionInHeader:(BOOL)needSession contentType:(ContentType)contentType success:(void (^) (NSDictionary *response))success faild:(void (^) (NSError *error))faild {
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.validatesDomainName = NO;
    [manager setSecurityPolicy:securityPolicy];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:contentType];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (needSession)
        [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager.requestSerializer setValue:[[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERAGENT] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            success(entitiesPropertyList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (faild)
            faild(error);
    }];
}

@end
