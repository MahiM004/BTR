//
//  BTRCategoryData.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRCategoryData : NSObject

+ (BTRCategoryData *)sharedCategoryData;

@property (strong, nonatomic) NSMutableArray *categoryNameArray;
@property (strong, nonatomic) NSMutableArray *categoryUrlArray;

- (void)clearCategoryData;

@end
