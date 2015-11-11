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

@property (copy, nonatomic) void (^didTapRereserveItemButtonBlock)(UIView *sender);
@property (copy, nonatomic) void (^didTapRemoveItemButtonBlock)(UIView *sender);

@end

@implementation BTRBagTableViewCell

- (void)awakeFromNib {
    self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(10, 0, 120, self.stepperView.bounds.size.height)];
    [self.stepper setup];
    [self.stepperView addSubview:self.stepper];
    [self.rereserveItemButton addTarget:self action:@selector(didTapRereserveItemButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.removeButton addTarget:self action:@selector(didTapRemoveItemButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)didTapRereserveItemButton:(UIView *)sender {
    if (self.didTapRereserveItemButtonBlock)
        self.didTapRereserveItemButtonBlock(sender);
}

- (void)didTapRemoveItemButtonBlock:(UIView *)sender {
    if (self.didTapRemoveItemButtonBlock)
        self.didTapRemoveItemButtonBlock(sender);
}


@end






















