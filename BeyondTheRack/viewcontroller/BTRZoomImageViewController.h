//
//  BTRZoomImageViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-10.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRZoomImageViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *productSkuString;
@property NSIndexPath* selectedIndex;
@property (nonatomic) NSInteger zoomImageCount;
@property (strong, nonatomic) NSString *productImageDomain;
@end
