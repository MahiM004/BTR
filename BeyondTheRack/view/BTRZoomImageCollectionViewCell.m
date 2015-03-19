//
//  BTRZoomImageCollectionViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-10.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRZoomImageCollectionViewCell.h"

@interface BTRZoomImageCollectionViewCell ()

@property (nonatomic) CGFloat lastScale;

@end


@implementation BTRZoomImageCollectionViewCell

- (void)awakeFromNib{
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 6;//;self.scrollView.min; //6.0;
    
    self.scrollView.delegate=self;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomImageView;
}


@end
