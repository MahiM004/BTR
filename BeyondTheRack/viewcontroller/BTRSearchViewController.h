//
//  BTRSearchViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>


@property (strong,nonatomic) NSMutableArray *filteredItemArray;
@property (strong, nonatomic) NSMutableArray *itemArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
