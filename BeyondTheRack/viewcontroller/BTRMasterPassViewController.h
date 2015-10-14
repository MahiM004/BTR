//
//  BTRMasterPassViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterPassInfo.h"
#import "MPManager.h"


@protocol MasterPassInfoDelegate <NSObject>
- (void)masterPassInfoDidReceived:(NSDictionary *)info;
@end


@interface BTRMasterPassViewController : UIViewController <MPManagerDelegate>

@property (nonatomic, retain) MasterPassInfo* info;
@property (nonatomic, retain) NSDictionary *processInfo;
@property (nonatomic, retain) id <MasterPassInfoDelegate> delegate;

@end
