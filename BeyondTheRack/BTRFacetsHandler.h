//
//  BTRFacetsHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRFacetsHandler : NSObject


+ (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary;
+ (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary;
+ (NSMutableArray *)extractFilterFacetsForDisplayFromResponse:(NSDictionary *)facetsDictionary;



@end
