//
//  BTRRefineResultsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "UIImage+ImageEffects.h"



#import <UIKit/UIKit.h>

@interface BTRRefineResultsViewController : UIViewController

@property (strong, nonatomic) UIImage *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSDictionary *facetsDictionary;


@end