//
//  BTRSearchViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRSelectSizeVC.h"

@interface BTRSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BTRSelectSizeVC>

@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *suggestionTableView;
@property (weak, nonatomic) IBOutlet UIImageView *filterIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@end
