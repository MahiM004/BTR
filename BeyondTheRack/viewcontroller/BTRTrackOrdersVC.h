//
//  BTRTrackOrdersVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-26.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRTrackOrdersVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
