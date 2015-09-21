//
//  BTREventCell.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTREventCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end
