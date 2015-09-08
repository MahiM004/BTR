//
//  BTRConnectionHelper.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-31.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *const contentType;
static contentType kContentTypeJSON = @"application/json", kContentTypeHTMLOrText = @"text/html";

@interface BTRConnectionHelper : NSObject

+ (void)postDataToURL:(NSString *)url
       withParameters:(NSDictionary *)param
   setSessionInHeader:(BOOL)needSession
          contentType:(contentType)contentType
              success:(void (^) (NSDictionary *response))success
                faild:(void (^) (NSError *error))faild;

+ (void)getDataFromURL:(NSString *)url
        withParameters:(NSDictionary *)param
    setSessionInHeader:(BOOL)needSession
           contentType:(contentType)contentType
               success:(void (^) (NSDictionary *response))success
                 faild:(void (^) (NSError *error))faild;

+ (void)putDataFromURL:(NSString *)url
        withParameters:(NSDictionary *)param
    setSessionInHeader:(BOOL)needSession
           contentType:(contentType)contentType
               success:(void (^) (NSDictionary *response))success
                 faild:(void (^) (NSError *error))faild;
@end
