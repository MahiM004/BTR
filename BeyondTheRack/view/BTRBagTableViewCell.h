//
//  BTRBagTableViewCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKYStepper.h"


@interface BTRBagTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIView *stepperView;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;

@property (nonatomic, strong) NSDate *dueDateTime;
@property (nonatomic, strong) PKYStepper *stepper;

@property (weak, nonatomic) IBOutlet UIButton *rereserveItemButton;

- (void)setDidTapRereserveItemButtonBlock:(void (^)(id sender))didTapRereserveItemButtonBlock;


@end
