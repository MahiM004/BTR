//
//  BTRProductShowcaseCollectionCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductShowcaseCollectionCell.h"

@interface BTRProductShowcaseCollectionCell()

@property (copy, nonatomic) void (^didTapAddtoBagButtonBlock)(id sender);


@end


@implementation BTRProductShowcaseCollectionCell


- (void)awakeFromNib {
    
    self.sizeSelector = [[BTRSizeSelector alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.sizeSelector.valueChangedCallback = ^(BTRSizeSelector *sizeSelector, NSString *value) {
        sizeSelector.countLabel.text = value;
    };
    
    [self.sizeSelector setBackgroundColor:[UIColor orangeColor]];
    
    [self.sizeSelector setup];
    //[self addSubview:self.sizeSelector];
    
    [self.addToBagButton addTarget:self action:@selector(didTapAddtoBagButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapAddtoBagButton:(id)sender {
    
    if (self.didTapAddtoBagButtonBlock) {
        self.didTapAddtoBagButtonBlock(sender);
    }
}


/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}*/



@end
