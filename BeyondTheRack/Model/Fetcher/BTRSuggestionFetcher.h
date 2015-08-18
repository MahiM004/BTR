//
//  BTRSuggestionFetcher.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRFetcher.h"

@interface BTRSuggestionFetcher : BTRFetcher
+ (NSURL *)URLforSugesstionWithQuery:(NSString *)query;
@end
