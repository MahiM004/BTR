//
//  MainViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-15.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property(strong,nonatomic) NSMutableArray *categoryNames;


@end

