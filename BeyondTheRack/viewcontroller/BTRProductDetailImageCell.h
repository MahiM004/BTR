//
//  BTRProductDetailImageCell.h
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 04/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRProductDetailImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pgParentHeight;
@property (weak, nonatomic) IBOutlet UIView *pgParentView;

@end
