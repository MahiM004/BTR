//
//  BTRItemShowcaseTableViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRItemShowcaseTableViewCell.h"

@implementation BTRItemShowcaseTableViewCell

@synthesize leftView;
@synthesize leftImageView;
@synthesize rightView;
@synthesize rightImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
