//
//  BTRProductDetailNameCell.m
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 04/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailNameCell.h"

@implementation BTRProductDetailNameCell

- (void)awakeFromNib {
    // Initialization code
    _dropdownLabelIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    _dropdownLabelIcon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-caret-down"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
