//
//  BTRFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *
 *  Fetcher classes are used to manage all the URLs.
 *  The BASE_URL is stored in BeyondTheRack-Prefix.pch
 *
 */

@interface BTRFetcher : NSObject

+ (NSURL *)URLForQuery:(NSString *)query;
+ (NSArray *)appServerEntitiesAtURL:(NSURL *)url;
+ (NSArray *)appServerEntitiesWithJSONResponse:(NSData *)appServerJSONData;

@end

