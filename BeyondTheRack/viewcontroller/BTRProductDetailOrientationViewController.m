//
//  BTRProductDetailOrientationViewController.m
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 12/10/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailOrientationViewController.h"
#import "BTRProductDetailViewController.h"
#import "BTRProductImageCollectionCell.h"
#import "BTRZoomImageViewController.h"
#import "BTRItemFetcher.h"
#import "BTRSizeChartViewController.h"
#import "NSString+HeightCalc.h"
#import <Social/Social.h>
#import <Pinterest/Pinterest.h>
#import "PKYStepper.h"
#import "UIImageView+AFNetworking.h"

@interface BTRProductDetailOrientationViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *productSku;
@property (nonatomic) NSInteger productImageCount;
@property (strong, nonatomic) NSMutableArray *attributeKeys;
@property (strong, nonatomic) NSMutableArray *attributeValues;
@end

@implementation BTRProductDetailOrientationViewController

- (NSMutableArray *)attributeKeys {
    if (!_attributeKeys) _attributeKeys = [[NSMutableArray alloc] init];
    return _attributeKeys;
}


- (NSMutableArray *)attributeValues {
    if (!_attributeValues) _attributeValues = [[NSMutableArray alloc] init];
    return  _attributeValues;
}
- (void)setProductImageCount:(NSInteger)productImageCount {
    _productImageCount = productImageCount;
}
- (void)updateViewWithDeatiledItem:(Item *)productItem {
    self.productImageCount = [[productItem imageCount] integerValue];
    if (productItem) {
        [self setProductSku:[productItem sku]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self extractAttributesFromAttributesDictionary:[self attributesDictionary]];
    [self updateViewWithDeatiledItem:[self productItem]];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self productImageCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTRProductImageCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductImageCollectionCellIdentifier" forIndexPath:indexPath];
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]
                                                                       withCount:1+indexPath.row
                                                                         andSize:@"large"]
                          placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height-10);
    } else
    return CGSizeMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2-10);
}

#pragma mark -  Handle JSON with Arbitrary Keys (attributes)

- (void) extractAttributesFromAttributesDictionary:(NSDictionary *)attributeDictionary {
    [attributeDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyString = key;
        NSString *objString = obj;
        if (![keyString isEqualToString:@""]) {
            [[self attributeKeys] addObject:keyString];
            [[self attributeValues] addObject:objString];
        }
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ProductDetailiPadEmbeddedSegueIdentifier"]) {
        BTRProductDetailEmbeddedTVC *embeddedVC = [segue destinationViewController];
        embeddedVC.delegate = self;
        embeddedVC.rightMargin = _rightMargin;
    } else if ([[segue identifier] isEqualToString:@"ZoomOnProductImageiPadSegueIdentifier"]) {
        BTRZoomImageViewController *zoomVC = [segue destinationViewController];
        zoomVC.productSkuString = [self productSku];
        zoomVC.zoomImageCount = [self productImageCount];
    }
}
@end
