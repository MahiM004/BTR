//
//  BTRRefreshManager.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-01-27.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRRefreshManager : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (BTRRefreshManager *)sharedInstance;

@property NSDate *backGroundTime;
@property UIViewController *topViewController;

- (void)start;
- (void)appDidEnterBackground;
- (void)appWillEnterForeground;



@end
