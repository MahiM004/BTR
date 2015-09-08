//
//  BTRCategoryViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUIScrollViewSlidingPages.h"

@interface BTRCategoryViewController : UIViewController<TTSlidingPagesDataSource, TTSliddingPageDelegate>

@property (strong, nonatomic) NSMutableArray *categoryNames;
@property (strong, nonatomic) NSMutableArray *urlCategoryNames;

@end
