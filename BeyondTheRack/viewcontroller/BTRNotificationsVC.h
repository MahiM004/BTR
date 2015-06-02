//
//  BTRNotificationsVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNRadioButtonGroup.h"

@interface BTRNotificationsVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *radioView;
@property (nonatomic, strong) TNRadioButtonGroup *emailNotificationGroup;

@end
