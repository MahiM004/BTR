//
//  BTREventsCDTVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"


@interface BTREventsCDTVC : CoreDataTableViewController{
    UIImageView *imageView;
}

@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *urlCategoryName;


@end
