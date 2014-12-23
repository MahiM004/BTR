//
//  EventsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-22.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCell.h"
#import "DetailViewController.h"

@interface EventsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryHeaderLabel;

@property (strong, nonatomic) NSString *catText;
@property (nonatomic) NSUInteger categoryCount;
@property (nonatomic) NSUInteger selectedCategoryIndex;

@end
