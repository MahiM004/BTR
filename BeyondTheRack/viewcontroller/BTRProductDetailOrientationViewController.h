//
//  BTRProductDetailOrientationViewController.h
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 12/10/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+AppServer.h"
#import "BTRProductDetailEmbeddedTVC.h"
@protocol  BTRProductDetailOrientationViewController;

@interface BTRProductDetailOrientationViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,BTRProductDetailEmbeddedTVC>

@property (nonatomic , weak) id<BTRProductDetailOrientationViewController>delegate;
@property (strong, nonatomic) NSString *originVCString;
@property (strong, nonatomic) Item *productItem;
@property (strong, nonatomic) NSDictionary *variantInventoryDictionary;
@property (strong, nonatomic) NSDictionary *attributesDictionary;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property CGFloat rightMargin;
@property BOOL isLoadedBefore;

@end

@protocol BTRProductDetailOrientationViewController <NSObject>

@optional

- (void)variantCodeforAddtoBag:(NSString *)variant;
- (void)quantityForAddToBag:(NSString *)qty;

@end