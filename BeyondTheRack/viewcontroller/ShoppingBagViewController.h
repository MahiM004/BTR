//
//  ShoppingBagViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-24.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingBagViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
