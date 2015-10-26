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
#import "BTRConnectionHelper.h"
#import "BTRSizeChartViewController.h"
#import "NSString+HeightCalc.h"
#import <Social/Social.h>
#import "PDKClient.h"
#import "PKYStepper.h"
#import "BTRloader.h"
#import "UIImageView+AFNetworking.h"

@interface BTRProductDetailOrientationViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *productSku;
@property (nonatomic) NSInteger productImageCount;
@property (strong, nonatomic) NSMutableArray *attributeKeys;
@property (strong, nonatomic) NSMutableArray *attributeValues;
@property BTRProductDetailEmbeddedTVC *embededVC;
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
    if (productItem)
        [self setProductSku:[productItem sku]];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self fetchItemforProductSku:[[self productItem] sku]
                         success:^(Item *responseObject) {
                             if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
                                 [self.embededVC setRightMargin:250];
                             else
                                 [self.embededVC setRightMargin:0];
                             [self updateViewWithDeatiledItem:[self productItem]];
                             [self.embededVC fillWithItem:responseObject];
                             [self extractAttributesFromAttributesDictionary:[self.productItem attributeDictionary]];
                             [self setVariantInventoryDictionary:[self.productItem variantInventory]];
                             [BTRLoader hideLoaderFromView:self.view];
                         }
                         failure:^(NSError *error) {
    }];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.productImageCount == 0)
        return 1;
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
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)fetchItemforProductSku:(NSString *)productSku
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        Item *productItem = [Item itemWithAppServerInfo:response withEventId:[self eventId]];
        success(productItem);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ProductDetailiPadEmbeddedSegueIdentifier"]) {
        BTRProductDetailEmbeddedTVC *embeddedVC = [segue destinationViewController];
        self.embededVC = embeddedVC;
        embeddedVC.delegate = self;
        embeddedVC.rightMargin = _rightMargin;
    } else if ([[segue identifier] isEqualToString:@"ZoomOnProductImageiPadSegueIdentifier"]) {
        BTRZoomImageViewController *zoomVC = [segue destinationViewController];
        zoomVC.productSkuString = [self productSku];
        zoomVC.zoomImageCount = [self productImageCount];
    }
}
@end
