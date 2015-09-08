//
//  BTRSettingManager.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-08.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSettingManager.h"

#define SETTING @"setting"

@interface BTRSettingManager ()
@property (nonatomic,strong) NSMutableDictionary *currentSetting;
@end


@implementation BTRSettingManager

+ (id)defaultManager {
    static id sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSMutableDictionary *)currentSetting {
    NSUserDefaults *userDefault = [[NSUserDefaults alloc]init];
    NSMutableDictionary* currentSetting = [userDefault valueForKey:SETTING];
    if (!currentSetting)
        currentSetting = [[NSMutableDictionary alloc]init];
    return currentSetting;
}

- (void)setInSetting:(id)object forKey:(NSString *)key {
    [[self currentSetting] setObject:object forKey:key];
    [self saveSetting];
}

- (id)objectForKeyInSetting:(NSString *)key {
    return [self.currentSetting objectForKey:key];
}

- (void)saveSetting {
    NSUserDefaults *userDefault = [[NSUserDefaults alloc]init];
    [userDefault setObject:self.currentSetting forKey:SETTING];
    [userDefault synchronize];
}

@end
