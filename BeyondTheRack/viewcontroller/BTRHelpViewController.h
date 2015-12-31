//
//  BTRHelpViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQ.h"

@interface BTRHelpViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *helpTable;

@property (strong , nonatomic) NSArray* faqArray;

@property NSString * getOriginalVCString;
@end
