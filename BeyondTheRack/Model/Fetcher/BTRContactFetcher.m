//
//  BTRContactFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRContactFetcher.h"
#import "BTRSettingManager.h"

@implementation BTRContactFetcher

+ (NSURL *)URLForContact {
    NSString* location = [[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERLOCATION];
    if ([location isEqualToString:@"US"])
        return [self URLForQuery:[NSString stringWithFormat:@"%@/content/contact?lang=en_US&render=text", BASEURL]];
    return [self URLForQuery:[NSString stringWithFormat:@"%@/content/contact?lang=en_CA&render=text", BASEURL]];
}

+ (NSURL *)URLForSendMessage {
  return [self URLForQuery:[NSString stringWithFormat:@"%@/contact", BASEURL]];
}

@end
