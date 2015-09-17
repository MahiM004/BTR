//
//  BTREventsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-22.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRAccountEmbeddedTVC.h"

@interface BTRMainViewController : UIViewController <BTRAccountDelegate>
@property (nonatomic, strong) User *user;
@end
