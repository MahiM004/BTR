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
@property (nonatomic, strong) NSDate *dueDateTime;
@property (nonatomic, strong) PKYStepper *stepper;
@property (weak, nonatomic) IBOutlet UIButton *rereserveItemButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *goToPDPBtn;


/**
 *
 *  Use the following setter to assign behaviour to each button (Rereserve Item) on each cell
 *
 */

- (void)setDidTapRereserveItemButtonBlock:(void (^)(UIView *sender))didTapRereserveItemButtonBlock;
- (void)setDidTapRemoveItemButtonBlock:(void (^)(UIView *sender))didTapRemoveItemButtonBlock;
- (void)setDidTapGoToPDPButtonBlock:(void (^)(UIView *sender))didTapGoToPDPButtonBlock;

@end
