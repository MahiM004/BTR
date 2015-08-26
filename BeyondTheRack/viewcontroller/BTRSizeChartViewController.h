//
//  BTRSizeChartViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-25.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRSizeChartCategoryCollectionViewCell.h"

typedef enum {
    apparel,
}sizechartCategory;


@interface BTRSizeChartViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate >

@property sizechartCategory category;

@end
