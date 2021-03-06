//
//  BTRFAQFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFAQFetcher.h"
#import "BTRSettingManager.h"

@implementation BTRFAQFetcher

+ (NSURL *)URLforFAQ {
    NSString* location = [[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERLOCATION];
    if ([location isEqualToString:@"US"])
        return [self URLForQuery:[NSString stringWithFormat:@"%@/content/faq?lang=en_US&render=text", BASEURL]];
    return [self URLForQuery:[NSString stringWithFormat:@"%@/content/faq?lang=en_CA&render=text", BASEURL]];
}

@end
