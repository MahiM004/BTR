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


@interface BTRProductDetailEmbeddedTVC : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, BTRSelectSizeVC>

@property (strong, nonatomic) Item *productItem;
@property (strong, nonatomic) NSMutableArray *imageArray;

@end
