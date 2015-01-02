//
//  EventsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-22.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCell.h"

@interface EventsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>



@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryHeaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastCategory;
@property (weak, nonatomic) IBOutlet UILabel *nextCategory;


@property (strong, nonatomic) NSString *catText;
@property (nonatomic) NSUInteger categoryCount;
@property (nonatomic) NSUInteger selectedCategoryIndex;

@property (strong, nonatomic) NSMutableArray *categoryNames;

@end
