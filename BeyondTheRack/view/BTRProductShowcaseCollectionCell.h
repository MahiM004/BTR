//
//  BTRProductShowcaseCollectionCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTRSizeSelector.h"


@interface BTRProductShowcaseCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *btrPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *sizeCodesArray;
@property (strong, nonatomic) NSMutableArray *sizeQuantityArray;



@property (nonatomic, strong) BTRSizeSelector *sizeSelector;




@property (weak, nonatomic) IBOutlet UIButton *addToBagButton;


- (void)setDidTapAddtoBagButtonBlock:(void (^)(id sender))didTapAddtoButtonBlock;



@end
