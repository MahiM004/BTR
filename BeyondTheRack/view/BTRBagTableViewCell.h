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

@property(nonatomic, strong) PKYStepper *stepper;


@end
