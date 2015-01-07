//
//  EventsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-22.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCell.h"

#import "TTSlidingPagesDataSource.h"
#import "TTSliddingPageDelegate.h"


@interface EventsViewController : UIViewController <TTSlidingPagesDataSource, TTSliddingPageDelegate>{
}

@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryHeaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastCategory;
@property (weak, nonatomic) IBOutlet UILabel *nextCategory;


@property (nonatomic) NSUInteger categoryCount;
@property (strong, nonatomic) NSMutableArray *categoryNames;

@end
