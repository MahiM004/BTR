//
//  BTREditShoppingBagVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTREditShoppingBagVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *bagCountString;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;
@property (strong, nonatomic) NSMutableArray *itemsArray;

@end
