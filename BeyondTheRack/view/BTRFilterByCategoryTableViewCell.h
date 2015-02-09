//
//  BTRFilterByCategoryTableViewCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BTRFilterSwitch.h"

@interface BTRFilterByCategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet BTRFilterSwitch *categorySwitch;

@end
