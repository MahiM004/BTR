//
//  CollectionCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-22.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//


#import <UIKit/UIKit.h>
@class CollectionCell;
@protocol ColectionCellDelegate
-(void)tableCellDidSelect:(UITableViewCell *)cell;
@end

@interface CollectionCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *cellData;
@end
