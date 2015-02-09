//
//  BTRFilterByPriceTableViewCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRFilterSwitch.h"


@interface BTRFilterByPriceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet BTRFilterSwitch *priceSwitch;

@end
