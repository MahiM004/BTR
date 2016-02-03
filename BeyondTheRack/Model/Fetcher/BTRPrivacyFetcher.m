//
//  BTRPrivacyFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-03.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRPrivacyFetcher.h"
#import "BTRSettingManager.h"

@implementation BTRPrivacyFetcher

+ (NSURL *)URLforPrivacy {
    NSString* location = [[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERLOCATION];
    if ([location isEqualToString:@"US"])
        return [self URLForQuery:[NSString stringWithFormat:@"%@/content/privacy?lang=en_US&render=html", BASEURL]];
    return [self URLForQuery:[NSString stringWithFormat:@"%@/content/privacy?lang=en_CA&render=html", BASEURL]];
}

@end
