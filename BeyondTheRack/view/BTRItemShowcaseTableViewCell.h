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
@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@end
