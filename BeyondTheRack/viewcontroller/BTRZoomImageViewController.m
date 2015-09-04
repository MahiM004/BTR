//
//  BTRZoomImageViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-10.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRZoomImageViewController.h"
#import "BTRZoomImageCollectionViewCell.h"
#import "BTRItemFetcher.h"



@implementation BTRZoomImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self zoomImageCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTRZoomImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ZoomImageCollectionCellIdentifier" forIndexPath:indexPath];
    
    [cell.zoomImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[self productSkuString]
                                                                       withCount:1+indexPath.row
                                                                         andSize:@"large"]
                          placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    return cell;
}

@end
















