//
//  BTRProductDetailNameCell.h
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 04/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRProductDetailNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *crossedOffPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectSizeButton;
@property (weak, nonatomic) IBOutlet UILabel *dropdownLabelIcon;
@property (weak, nonatomic) IBOutlet UILabel *selectSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyNum;
@property (weak, nonatomic) IBOutlet UIView *stepperView;
@property (weak, nonatomic) IBOutlet UIButton *selectChart;
@property (weak, nonatomic) IBOutlet UIView *sizeChartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeChartHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectSizeViewHeight;
@property (weak, nonatomic) IBOutlet UIView *selectSizeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectSizeViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeChartTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flatShippingHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flatShippingTopMargin;
@property (weak, nonatomic) IBOutlet UIButton *flatShippingBtn;

@end
