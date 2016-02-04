//
//  BTRTermsFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-04.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRTermsFetcher.h"
#import "BTRSettingManager.h"

@implementation BTRTermsFetcher

+ (NSURL *)URLforTerms {
    NSString* location = [[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERLOCATION];
    if ([location isEqualToString:@"US"])
        return [self URLForQuery:[NSString stringWithFormat:@"%@/content/terms?lang=en_US&render=html", BASEURL]];
    return [self URLForQuery:[NSString stringWithFormat:@"%@/content/terms?lang=en_CA&render=html", BASEURL]];
}

@end
