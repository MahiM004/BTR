//
//  BTRBagTableViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRBagTableViewCell.h"
#import "PKYStepper.h"

@interface BTRBagTableViewCell ()

@property(nonatomic, strong) PKYStepper *stepper;


@end


@implementation BTRBagTableViewCell


- (void)awakeFromNib {
    // Initialization code
    
    //float width = 260.0f;
    //float x = ([UIScreen mainScreen].bounds.size.width - width) / 2.0;
    
    self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
  
    //self.stepper = [[PKYStepper alloc] initWithFrame:self.frame];

    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    [self.stepper setup];
    [self.stepperView addSubview:self.stepper];
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
