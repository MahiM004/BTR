//
//  BTRModalFilterSelectionVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BTRModalFilterSelectionDelegate;


@interface BTRModalFilterSelectionVC : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) id<BTRModalFilterSelectionDelegate> modalDelegate;


@property (strong, nonatomic) NSString *headerTitle;
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *selectedItemsArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end



@protocol BTRModalFilterSelectionDelegate <NSObject>

@optional

- (void)modalFilterSelectionVCDidEnd:(NSMutableArray *)selectedItemsArray  withTitle:(NSString *)titleString;
//- (void)modalFilterSelectionVCWillBeDismissed:(BTRModalFilterSelectionVC *)modalVC;


@end