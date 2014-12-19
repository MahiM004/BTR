//
//  EventsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSString *catText;
@property (nonatomic) NSUInteger categoryCount;
@property (nonatomic) NSUInteger selectedCategoryIndex;

@end
