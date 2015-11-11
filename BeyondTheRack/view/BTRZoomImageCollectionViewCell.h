//
//  BTRZoomImageCollectionViewCell.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-10.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTRZoomImageCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *zoomImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureZoomImage;
@end
