//
//  BTRBagTableViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRBagTableViewCell.h"

@interface BTRBagTableViewCell ()

@property (copy, nonatomic) void (^didTapRemoveItemButtonBlock)(id sender);
@property (copy, nonatomic) void (^didTapRereserveItemButtonBlock)(id sender);


@end


@implementation BTRBagTableViewCell


- (void)awakeFromNib {

    self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    
    [self.stepper setup];
    [self.stepperView addSubview:self.stepper];
    
    [self.removeItemButton addTarget:self action:@selector(didTapRemoveItemButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rereserveItemButton addTarget:self action:@selector(didTapRereserveItemButton:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)didTapRemoveItemButton:(id)sender {
    
    if (self.didTapRemoveItemButtonBlock) {
        self.didTapRemoveItemButtonBlock(sender);
    }
}


- (void)didTapRereserveItemButton:(id)sender {
    
    if (self.didTapRereserveItemButtonBlock) {
        self.didTapRereserveItemButtonBlock(sender);
    }
}




@end
