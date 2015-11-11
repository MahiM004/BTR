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

- (void)awakeFromNib {
    
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 6;
    self.scrollView.delegate=self;
    _tapGestureZoomImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapZoomAction:)];
    _tapGestureZoomImage.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:_tapGestureZoomImage];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.zoomImageView;
}
- (void)doubleTapZoomAction:(UIGestureRecognizer*)sender {
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    }
    
}
@end
