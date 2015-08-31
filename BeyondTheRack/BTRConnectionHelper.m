//
//  BTRConnectionHelper.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-31.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRConnectionHelper.h"

@implementation BTRConnectionHelper

+ (void)postDataToURL:(NSString *)url withParameters:(NSDictionary *)param setSessionInHeader:(BOOL)needSession success:(void (^) (NSDictionary *response))success faild:(void (^) (NSError *error))faild {
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (needSession)
        [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
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

+ (void)getDataFromURL:(NSString *)url withParameters:(NSDictionary *)param setSessionInHeader:(BOOL)needSession success:(void (^) (NSDictionary *response))success faild:(void (^) (NSError *error))faild {
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (needSession)
        [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            success(entitiesPropertyList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (faild)
            faild(error);
    }];
}

+ (void)putDataFromURL:(NSString *)url withParameters:(NSDictionary *)param setSessionInHeader:(BOOL)needSession success:(void (^) (NSDictionary *response))success faild:(void (^) (NSError *error))faild {
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (needSession)
        [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
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
