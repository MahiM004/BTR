//
//  BTREventsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-22.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTSlidingPagesDataSource.h"
#import "TTSliddingPageDelegate.h"


@interface BTRMainViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *categoryNames;
@property (strong, nonatomic) NSMutableArray *urlCategoryNames;

@end
