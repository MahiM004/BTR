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
@property (copy, nonatomic) void (^didTapSelectSizeButtonBlock)(id sender);


@end


@implementation BTRProductShowcaseCollectionCell


- (NSMutableArray *)sizesArray {
    
    if (!_sizesArray) _sizesArray = [[NSMutableArray alloc] init];
    return _sizesArray;
}


- (NSMutableArray *)sizeCodesArray {
    
    if (!_sizeCodesArray) _sizeCodesArray = [[NSMutableArray alloc] init];
    return _sizeCodesArray;
}


- (NSMutableArray *)sizeQuantityArray {
    
    if (!_sizeQuantityArray) _sizeQuantityArray = [[NSMutableArray alloc]  init];
    return _sizeQuantityArray;
}



- (void)awakeFromNib {
    
    self.sizeSelector = [[BTRSizeSelector alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.sizeSelector.valueChangedCallback = ^(BTRSizeSelector *sizeSelector, NSString *value) {
        sizeSelector.titleLabel.text = value;
    };
    
    [self.sizeSelector setBackgroundColor:[UIColor orangeColor]];
    
    [self.sizeSelector setup];
    //[self addSubview:self.sizeSelector];
    
    [self.addToBagButton addTarget:self action:@selector(didTapAddtoBagButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectSizeButton addTarget:self action:@selector(didTapSelectSizeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapAddtoBagButton:(id)sender {
    
    if (self.didTapAddtoBagButtonBlock) {
        self.didTapAddtoBagButtonBlock(sender);
    }
}


- (void)didTapSelectSizeButton:(id)sender {
    
    if (self.didTapSelectSizeButtonBlock) {
        self.didTapSelectSizeButtonBlock(sender);
    }
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
*/
/*
- (void)awakeFromNib {
    
    self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    
    [self.stepper setup];
    [self.stepperView addSubview:self.stepper];
    
}



*/


@end
























