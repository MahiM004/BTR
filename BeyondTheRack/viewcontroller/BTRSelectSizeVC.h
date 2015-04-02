//
//  BTRSelectSizeVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BTRSelectSizeVC;


@interface BTRSelectSizeVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<BTRSelectSizeVC> delegate;

@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *sizeQuantityArray;

@end





@protocol BTRSelectSizeVC <NSObject>

@optional


- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex;


@end
