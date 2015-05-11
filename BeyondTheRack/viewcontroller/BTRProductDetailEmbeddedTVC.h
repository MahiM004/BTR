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

enum btrSizeMode
{
    btrSizeModeSoldOut, // == 0 (by default)
    btrSizeModeSingleSizeShow, // == 1 (incremented by 1 from previous)
    btrSizeModeSingleSizeNoShow, // == 2
    btrSizeModeNoInfo,
    btrSizeModeMultipleSizes
};


@protocol BTRProductDetailEmbeddedTVC;


@interface BTRProductDetailEmbeddedTVC : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, BTRSelectSizeVC>


@property (nonatomic, weak) id<BTRProductDetailEmbeddedTVC> delegate;


@property (strong, nonatomic) Item *productItem;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSMutableArray *imageArray;


@end



@protocol BTRProductDetailEmbeddedTVC <NSObject>

@optional


- (void)variantCodeforAddtoBag:(NSString *)variant;


@end




























