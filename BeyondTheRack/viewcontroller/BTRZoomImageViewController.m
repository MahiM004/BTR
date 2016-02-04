//
//  BTRZoomImageViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-10.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRZoomImageViewController.h"
#import "BTRZoomImageCollectionViewCell.h"
#import "UIImageView+AFNetworkingFadeIn.h"
#import "BTRItemFetcher.h"



@implementation BTRZoomImageViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.02 animations:^{
        [self.collectionView performBatchUpdates:nil completion:nil];
    }];
    [self.collectionView scrollToItemAtIndexPath:_selectedIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self zoomImageCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTRZoomImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ZoomImageCollectionCellIdentifier" forIndexPath:indexPath];
    
    [cell.zoomImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSkuWithDomain:_productImageDomain withSku:[self productSkuString] withCount:1+indexPath.row andSize:@"large"] placeholderImage:[UIImage imageNamed:@"placeHolderImage"] fadeInWithDuration:0.5];
    
//    [cell.zoomImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[self productSkuString]
//                                                                       withCount:1+indexPath.row
//                                                                         andSize:@"large"]
//                          placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
     return cell;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([BTRViewUtility isIPAD]) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            return CGSizeMake(screenBounds.size.width - 10,screenBounds.size.height - 120);
        } else
            return CGSizeMake(screenBounds.size.width - 10, screenBounds.size.height - 120);
    } else
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height-20);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView performBatchUpdates:nil completion:nil];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.collectionView.collectionViewLayout invalidateLayout];
}
@end
















