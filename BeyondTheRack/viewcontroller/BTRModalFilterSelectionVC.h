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
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *selectedOptionsArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSDictionary *facetsDictionary;
@property (strong, nonatomic) NSMutableArray *itemsArray;





@end



@protocol BTRModalFilterSelectionDelegate <NSObject>

@optional

- (void)modalFilterSelectionVCDidEnd:(NSMutableArray *)selectedOptionsArray  withTitle:(NSString *)titleString;


@end