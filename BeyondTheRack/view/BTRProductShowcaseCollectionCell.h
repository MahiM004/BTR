//
//  BTRProductShowcaseCollectionCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTRSizeSelector.h"
#import "BTRSizeHandler.h"


@interface BTRProductShowcaseCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *btrPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIImageView *allReservedImageView;
@property (weak, nonatomic) IBOutlet UILabel *productStatusMessageLabel;
@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *sizeCodesArray;
@property (strong, nonatomic) NSMutableArray *sizeQuantityArray;
@property (assign, nonatomic) BTRSizeMode sizeMode;
@property (nonatomic, strong) BTRSizeSelector *sizeSelector;
@property (assign, nonatomic) BOOL hasSelectedSize;
@property (weak, nonatomic) IBOutlet UIButton *addToBagButton;
@property (weak, nonatomic) IBOutlet BTRSizeSelector *selectSizeButton;

/**
 *
 *  Use the following setters to assign behaviour to each button (Add to Bag and Select Size) on each cell
 *
 */

- (void)setDidTapAddtoBagButtonBlock:(void (^)(id sender))didTapAddtoBagButtonBlock;
- (void)setDidTapSelectSizeButtonBlock:(void (^)(id sender))didTapSelectSizeButtonBlock;



@end
