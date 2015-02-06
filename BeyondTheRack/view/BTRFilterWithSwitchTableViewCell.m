//
//  BTRFilterWithSwitchTableViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFilterWithSwitchTableViewCell.h"

@implementation BTRFilterWithSwitchTableViewCell

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
        
        self.filterValueLabel.textColor = [UIColor whiteColor];
        
    } else {
        
        self.filterValueLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
