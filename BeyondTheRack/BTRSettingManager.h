//
//  BTRSettingManager.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-08.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsKeys.h"

@interface BTRSettingManager : NSObject

+ (id)defaultManager;

- (void)setInSetting:(id)object forKey:(NSString *)key;
- (id)objectForKeyInSetting:(NSString *)key;

@end
