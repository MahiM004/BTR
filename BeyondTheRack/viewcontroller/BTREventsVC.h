//
//  BTREventsVC.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTREventsVC : UICollectionViewController <UICollectionViewDataSource>
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *urlCategoryName;
@end
