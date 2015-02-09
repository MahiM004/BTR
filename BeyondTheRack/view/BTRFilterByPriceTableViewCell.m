//
//  BTRFilterByPriceTableViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFilterByPriceTableViewCell.h"

@implementation BTRFilterByPriceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(BTRFilterSwitch *)sender {
    
    if (sender.on) {
        
        self.priceLabel.textColor = [UIColor whiteColor];
        
    } else {
        
        self.priceLabel.textColor = [UIColor lightGrayColor];
    }
}



@end
