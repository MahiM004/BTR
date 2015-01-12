//
//  BTRFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRFetcher : NSObject

+ (NSURL *)URLForQuery:(NSString *)query;
+ (NSArray *)appServerEntitiesAtURL:(NSURL *)url;
+ (NSArray *)appServerEntitiesWithJSONResponse:(NSData *)appServerJSONData;

@end




/*
 http://172.30.101.26/apisite/events
 http://172.30.101.26/apisite/events/all
 http://172.30.101.26/apisite/event/25904
 http://172.30.101.26/apisite/eventsku/25904
 http://172.30.101.26/apisite/eventsku/25904/BUC17459BK
 
 */
