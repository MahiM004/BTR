//
//  BTRModalFilterSelectionVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRModalFilterSelectionVC : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *selectedItemsArray;


@end
