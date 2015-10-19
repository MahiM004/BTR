//
//  BTRProductDetailEmbededTVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-05.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+AppServer.h"
#import "BTRSelectSizeVC.h"
#import "BTRSizeHandler.h"

@protocol BTRProductDetailEmbeddedTVC;
@protocol BTRProductDetailEmbeddedTVC <NSObject>

@optional

- (void)variantCodeforAddtoBag:(NSString *)variant;
- (void)quantityForAddToBag:(NSString *)qty;

@end

@interface BTRProductDetailEmbeddedTVC : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, BTRSelectSizeVC>

@property (nonatomic, weak) id<BTRProductDetailEmbeddedTVC> delegate;
@property CGFloat rightMargin;

- (void)fillWithItem:(Item *)productItem;

@end





























