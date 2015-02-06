//
//  BTRFilterWithSwitchTableViewCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BTRFilterSwitch.h"

@interface BTRFilterWithSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *filterValueLabel;
@property (weak, nonatomic) IBOutlet BTRFilterSwitch *filterSwitch;

@end
