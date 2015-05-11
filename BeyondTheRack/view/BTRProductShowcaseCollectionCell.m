//
//  BTRProductShowcaseCollectionCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductShowcaseCollectionCell.h"

@implementation BTRProductShowcaseCollectionCell


- (void)awakeFromNib {
    
    self.sizeSelector = [[BTRSizeSelector alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.sizeSelector.valueChangedCallback = ^(BTRSizeSelector *sizeSelector, NSString *value) {
        sizeSelector.countLabel.text = value;
    };
    
    [self.sizeSelector setup];
    [self.sizeSelectorView addSubview:self.sizeSelector];
    
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}*/



@end
