//
//  Item+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Item+AppServer.h"

@implementation Item (AppServer)

+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary
                    withEventId:(NSString *)eventId {
    Item *item = [[Item alloc] init];
    item.eventId = eventId;
    item = [self extractItemfromJsonDictionary:itemDictionary forItem:item];
    return item;
}


+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary {
    Item *item = [[Item alloc] init];
    item = [self extractItemfromJsonDictionary:itemDictionary forItem:item];
    return item;
}

+ (NSMutableArray *)loadItemsfromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                    withEventId:(NSString *)eventId
                                 forItemsArray:(NSMutableArray *)itemsArray {
    for (NSDictionary *item in items) {
        NSObject *someObject = [self itemWithAppServerInfo:item withEventId:eventId];
        if (someObject)
            [itemsArray addObject:someObject];
    }
    return itemsArray;
}

+ (NSMutableArray *)loadItemsfromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                  forItemsArray:(NSMutableArray *)itemsArray {
    for (NSDictionary *item in items) {
        NSObject *someObject = [self itemWithAppServerInfo:item];
        if (someObject)
            [itemsArray addObject:someObject];
    }
    return itemsArray;
}

+ (Item *)extractItemfromJsonDictionary:(NSDictionary *)itemDictionary forItem:(Item *)item {
    NSNumberFormatter *nformatter = [[NSNumberFormatter alloc] init];
    nformatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    if ([itemDictionary valueForKeyPath:@"allReserved"] && [itemDictionary valueForKeyPath:@"allReserved"] != [NSNull null])
        item.allReserved = [itemDictionary valueForKey:@"allReserved"];
    
    if ([itemDictionary valueForKeyPath:@"attributes"] && [itemDictionary valueForKeyPath:@"attributes"] != [NSNull null])
        item.attributeDictionary = [itemDictionary valueForKey:@"attributes"];
    
    if ([itemDictionary valueForKeyPath:@"short_desc"] && [itemDictionary valueForKeyPath:@"short_desc"] != [NSNull null])
        item.shortItemDescription = [itemDictionary valueForKey:@"short_desc"];
    
    if ([itemDictionary valueForKeyPath:@"short_description"] && [itemDictionary valueForKeyPath:@"short_description"] != [NSNull null])
        item.shortItemDescription = [itemDictionary valueForKey:@"short_description"];
    
    if ([itemDictionary valueForKeyPath:@"long_desc"] && [itemDictionary valueForKeyPath:@"long_desc"] != [NSNull null])
        item.longItemDescription = [itemDictionary valueForKey:@"long_desc"];
    
    if ([itemDictionary valueForKeyPath:@"sku"] && [itemDictionary valueForKeyPath:@"sku"] != [NSNull null])
        item.sku = [itemDictionary valueForKey:@"sku"];
    
    if ([itemDictionary valueForKeyPath:@"brand"] && [itemDictionary valueForKeyPath:@"brand"] != [NSNull null])
        item.brand = [itemDictionary valueForKey:@"brand"];
    
    if ([itemDictionary valueForKeyPath:@"categories"] && [itemDictionary valueForKeyPath:@"categories"] != [NSNull null])
        item.categoryList = [itemDictionary valueForKey:@"categories"];
    
    if ([itemDictionary valueForKeyPath:@"special_notes"] && [itemDictionary valueForKeyPath:@"special_notes"] != [NSNull null])
        item.specialNote = [itemDictionary valueForKey:@"special_notes"];
    
    if ([itemDictionary valueForKeyPath:@"general_notes"] && [itemDictionary valueForKeyPath:@"general_notes"] != [NSNull null])
        item.generalNote = [itemDictionary valueForKey:@"general_notes"];
    
    if ([itemDictionary valueForKeyPath:@"image_count"] && [itemDictionary valueForKeyPath:@"image_count"] != [NSNull null])
        item.imageCount = [itemDictionary valueForKey:@"image_count"];
 
    if ([itemDictionary valueForKeyPath:@"retail_price"] && [itemDictionary valueForKeyPath:@"retail_price"] != [NSNull null])
        item.retailPrice = [itemDictionary valueForKey:@"retail_price"];
    
    if ([itemDictionary valueForKeyPath:@"regular_price"] && [itemDictionary valueForKeyPath:@"regular_price"] != [NSNull null])
        item.salePrice = [itemDictionary valueForKey:@"regular_price"];
    
    if ([itemDictionary valueForKeyPath:@"regular_price"] && [itemDictionary valueForKeyPath:@"regular_price"] != [NSNull null])
        item.salePrice = [itemDictionary valueForKey:@"regular_price"];
    
    if ([itemDictionary valueForKeyPath:@"ship_time"] && [itemDictionary valueForKeyPath:@"ship_time"] != [NSNull null])
        item.shipTime = [itemDictionary valueForKey:@"ship_time"];
    
    if ([itemDictionary valueForKeyPath:@"employee_price"] && [itemDictionary valueForKeyPath:@"employee_price"] != [NSNull null])
        item.employeePrice = [itemDictionary valueForKey:@"employee_price"];
    
    /* handling employee pricing at the JSON reading level */
    
    if (![[item employeePrice] isEqualToNumber:[NSNumber numberWithFloat:0]])
        item.salePrice = [item employeePrice];
    
    if ([itemDictionary valueForKeyPath:@"weight"] && [itemDictionary valueForKeyPath:@"weight"] != [NSNull null])
        item.productWeight = [itemDictionary valueForKey:@"weight"];

    if ([itemDictionary valueForKeyPath:@"length"] && [itemDictionary valueForKeyPath:@"length"] != [NSNull null])
        item.productLength = [itemDictionary valueForKey:@"length"];

    if ([itemDictionary valueForKeyPath:@"width"] && [itemDictionary valueForKeyPath:@"width"] != [NSNull null])
        item.productWidth = [itemDictionary valueForKey:@"width"];

    if ([itemDictionary valueForKeyPath:@"height"] && [itemDictionary valueForKeyPath:@"height"] != [NSNull null])
        item.productHeight = [itemDictionary valueForKey:@"height"];

    if ([itemDictionary valueForKeyPath:@"is_fragile"] && [itemDictionary valueForKeyPath:@"is_fragile"] != [NSNull null])
        item.isFragile = [itemDictionary valueForKey:@"is_fragile"];
    
    if ([itemDictionary valueForKeyPath:@"is_flat_rate"] && [itemDictionary valueForKeyPath:@"is_flat_rate"] != [NSNull null])
        item.isFlatRate = [itemDictionary valueForKey:@"is_flat_rate"];

    if ([itemDictionary valueForKeyPath:@"restricted_shipping"] && [itemDictionary valueForKeyPath:@"restricted_shipping"] != [NSNull null])
        item.restrictedShipping = [itemDictionary valueForKey:@"restricted_shipping"];
    
    if ([itemDictionary valueForKeyPath:@"variant_inventory"] && [itemDictionary valueForKeyPath:@"variant_inventory"] != [NSNull null])
        item.variantInventory = [itemDictionary valueForKey:@"variant_inventory"];
    
    if ([itemDictionary valueForKeyPath:@"reserved"] && [itemDictionary valueForKeyPath:@"reserved"] != [NSNull null])
        item.reserverdSizes = [itemDictionary valueForKey:@"reserved"];
    
    if ([item.sku hasPrefix:@"BTR"])
        item.isMockItem = YES;
    else
        item.isMockItem = NO;
    
    item.discount = [item.retailPrice floatValue] - [[item salePrice]floatValue];
    
    return item;

}

+ (Item *)extractItemfromConfirmationDictionary:(NSDictionary *)itemDictionary forItem:(Item *)item {
    
    if ([itemDictionary valueForKeyPath:@"short_desc"] && [itemDictionary valueForKeyPath:@"short_desc"] != [NSNull null])
        item.shortItemDescription = [itemDictionary valueForKey:@"short_desc"];
    if ([itemDictionary valueForKeyPath:@"price"] && [itemDictionary valueForKeyPath:@"price"] != [NSNull null])
        item.salePrice = [itemDictionary valueForKey:@"price"];
    if ([itemDictionary valueForKeyPath:@"brand"] && [itemDictionary valueForKeyPath:@"brand"] != [NSNull null])
        item.brand = [itemDictionary valueForKey:@"brand"];
    if ([itemDictionary valueForKeyPath:@"sku"] && [itemDictionary valueForKeyPath:@"sku"] != [NSNull null])
        item.sku = [itemDictionary valueForKey:@"sku"];
    if ([itemDictionary valueForKeyPath:@"variant"] && [itemDictionary valueForKeyPath:@"variant"] != [NSNull null])
        item.variant = [itemDictionary valueForKey:@"variant"];
    
    return item;
}

@end






















