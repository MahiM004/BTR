//
//  BTRNotificationsVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNRadioButtonGroup.h"
#import "User+AppServer.h"


enum btrEmailNotificationFrequency
{
    btrAllEmails, // == 0 (by default)
    btrDailyEmails, // == 1 (incremented by 1 from previous)
    btrThreeTimesAWeekEmails, // == 2
    btrWeeklyEmails,
    btrNoEmails
};



@interface BTRNotificationsVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *radioView;
@property (nonatomic, strong) TNRadioButtonGroup *emailNotificationGroup;

@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *menSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *childrenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *homeSwitch;

@property (nonatomic, strong) User *user;

@end
