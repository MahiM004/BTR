//
//  BTRMenuTableViewCell.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-10-23.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMenuCellReuseIdentifier @"Cell"

@interface BTRMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
