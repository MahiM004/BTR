//
//  BTRSuggestionFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSuggestionFetcher.h"

@implementation BTRSuggestionFetcher
+ (NSURL *)URLforSugesstionWithQuery:(NSString *)query {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/suggest?s=%@", WEBBASEURL, query]];
};
@end
