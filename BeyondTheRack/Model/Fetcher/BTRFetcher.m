//
//  BTRFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"

@implementation BTRFetcher



+ (NSURL *)URLForQuery:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@", query];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}


+ (NSArray *)appServerEntitiesAtURL:(NSURL *)url
{
    NSArray *entitiesPropertyList;
    NSData *appServerJSONData = [NSData dataWithContentsOfURL:url];  // will block if url is not local!
    if (appServerJSONData) {
        
        entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                               options:0
                                                                 error:NULL];
    }
    return  entitiesPropertyList;
}

+ (NSArray *)appServerEntitiesWithJSONResponse:(NSData *)appServerJSONData{
    
    NSArray *entitiesPropertyList;
    if (appServerJSONData) {
        
        entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                               options:0
                                                                 error:NULL];
    }
    return  entitiesPropertyList;
}




@end
