//
//  CategoryTableTableViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUITableViewZoomController.h"


@interface EventsTableTableViewController : TTUITableViewZoomController

@property (strong, nonatomic) NSMutableArray *eventsArray;

@end
