//
//  BTRProductDetailViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "Item+AppServer.h"
#import "BTRProductDetailEmbeddedTVC.h"

#define EVENT_SCENE @"EventScene"
#define SEARCH_SCENE @"SearchScene"

@interface BTRProductDetailViewController : UIViewController <BTRProductDetailEmbeddedTVC>

@property (strong, nonatomic) NSString *originVCString;
@property (strong, nonatomic) NSString *productSKUfromSearchResult;

@property (strong, nonatomic) Item *productItem;
@property (strong, nonatomic) NSDictionary *variantInventoryDictionary;
@property (strong, nonatomic) NSDictionary *attributesDictionary;


@property (strong, nonatomic) NSString *eventId;

@end
