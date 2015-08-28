//
//  BTRAttributeHandler.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-28.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAttributeHandler.h"

@implementation BTRAttributeHandler

+ (NSString *)attributeDictionaryToString:(NSDictionary *)dictionary {
    NSString* attributeListString = [[NSString alloc]init];
    for (NSString* key in dictionary) {
        attributeListString = [attributeListString stringByAppendingFormat:@"%@ : %@ \n",key,[dictionary valueForKey:key]];
    }
    return attributeListString;
}

@end
