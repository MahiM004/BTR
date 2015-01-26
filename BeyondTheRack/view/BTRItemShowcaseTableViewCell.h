//
//  BTRItemShowcaseTableViewCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRItemShowcaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightBrand;
@property (weak, nonatomic) IBOutlet UILabel *rightDescription;
@property (weak, nonatomic) IBOutlet UILabel *rightPrice;
@property (weak, nonatomic) IBOutlet UILabel *rightCrossedOffPrice;


@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftBrand;
@property (weak, nonatomic) IBOutlet UILabel *leftDescription;
@property (weak, nonatomic) IBOutlet UILabel *leftPrice;
@property (weak, nonatomic) IBOutlet UILabel *leftCrossedOffPrice;




@end
