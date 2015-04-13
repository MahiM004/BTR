//
//  BTRBagTableViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRBagTableViewCell.h"

@interface BTRBagTableViewCell ()


@end


@implementation BTRBagTableViewCell


- (void)awakeFromNib {

    self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    
    [self.stepper setup];
    [self.stepperView addSubview:self.stepper];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}






@end
