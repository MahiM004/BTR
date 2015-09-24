//
//  PromoItem.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-23.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoItem : NSObject

@property (nonatomic, retain) NSString * eligibleCountry;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * promoItemID;
@property (nonatomic, retain) NSString * promoID;

@end
