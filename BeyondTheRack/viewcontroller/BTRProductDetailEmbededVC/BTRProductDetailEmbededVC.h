//
//  BTRProductDetailEmbededVC.h
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 04/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+AppServer.h"
#import "Item.h"
#import "BTRSelectSizeVC.h"
@interface BTRProductDetailEmbededVC : UIViewController<BTRSelectSizeVC>

#define EVENT_SCENE @"EventScene"
#define SEARCH_SCENE @"SearchScene"
#define BAG_SCENE @"BagScene"

@property NSString *getOriginalVCString;
@property Item * getItem;
@property NSString * getEventID;
@property BOOL disableAddToCart;

@end
