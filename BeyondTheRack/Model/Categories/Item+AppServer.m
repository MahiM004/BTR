//
//  Item+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Item+AppServer.h"

@implementation Item (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    
    item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                    inManagedObjectContext:context];
    
    item.itemDescription = @"dummy";
}


+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    NSString *unique = itemDictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.predicate = [NSPredicate predicateWithFormat:@"itemId = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        item = [matches firstObject];
        
        if ([itemDictionary valueForKeyPath:@"event_id"] && [itemDictionary valueForKeyPath:@"event_id"] != [NSNull null])
            item.eventId = [itemDictionary valueForKeyPath:@"event_id"];
        
        if ([itemDictionary valueForKeyPath:@"short_decs"] && [itemDictionary valueForKeyPath:@"short_decs"] != [NSNull null])
            item.shortItemDescription = [itemDictionary valueForKey:@"short_decs"];
        
        if ([itemDictionary valueForKeyPath:@"long_desc"] && [itemDictionary valueForKeyPath:@"long_desc"] != [NSNull null])
            item.longItemDescription = [itemDictionary valueForKey:@"long_desc"];
        
        if ([itemDictionary valueForKeyPath:@"sku"] && [itemDictionary valueForKeyPath:@"sku"] != [NSNull null])
            item.sku = [itemDictionary valueForKey:@"sku"];
        
        if ([itemDictionary valueForKeyPath:@"priority_a"] && [itemDictionary valueForKeyPath:@"priority_a"] != [NSNull null])
            item.priorityA = [itemDictionary valueForKey:@"priority_a"];
        
        if ([itemDictionary valueForKeyPath:@"priority_b"] && [itemDictionary valueForKeyPath:@"priority_b"] != [NSNull null])
            item.priorityB = [itemDictionary valueForKey:@"priority_b"];
        
        if ([itemDictionary valueForKeyPath:@"brand"] && [itemDictionary valueForKeyPath:@"brand"] != [NSNull null])
            item.brand = [itemDictionary valueForKey:@"brand"];
        
        if ([itemDictionary valueForKeyPath:@"attribute_list"] && [itemDictionary valueForKeyPath:@"attribute_list"] != [NSNull null])
            item.attributeList = [itemDictionary valueForKey:@"attribute_list"];
        
        if ([itemDictionary valueForKeyPath:@"product_type"] && [itemDictionary valueForKeyPath:@"product_type"] != [NSNull null])
            item.productType = [itemDictionary valueForKey:@"product_type"];
        
        if ([itemDictionary valueForKeyPath:@"category_list"] && [itemDictionary valueForKeyPath:@"category_list"] != [NSNull null])
            item.categoryList = [itemDictionary valueForKey:@"category_list"];
        
        if ([itemDictionary valueForKeyPath:@"related_skus_list"] && [itemDictionary valueForKeyPath:@"related_skus_list"] != [NSNull null])
            item.relatedSkuslist = [itemDictionary valueForKey:@"related_skus_list"];
        
        if ([itemDictionary valueForKeyPath:@"special_notes"] && [itemDictionary valueForKeyPath:@"special_notes"] != [NSNull null])
            item.specialNote = [itemDictionary valueForKey:@"special_notes"];
        
        if ([itemDictionary valueForKeyPath:@"general_notes"] && [itemDictionary valueForKeyPath:@"general_notes"] != [NSNull null])
            item.generalNote = [itemDictionary valueForKey:@"general_notes"];
        
        if ([itemDictionary valueForKeyPath:@"image_count"] && [itemDictionary valueForKeyPath:@"image_count"] != [NSNull null])
            item.imageCount = [itemDictionary valueForKey:@"image_count"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"small"] && [itemDictionary[@"images"] valueForKeyPath:@"small"] != [NSNull null])
            item.imageName1 = [itemDictionary[@"images"] valueForKey:@"small"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"medium"] && [itemDictionary[@"images"] valueForKeyPath:@"medium"] != [NSNull null])
            item.imageName2 = [itemDictionary[@"images"] valueForKey:@"medium"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"large"] && [itemDictionary[@"images"] valueForKeyPath:@"large"] != [NSNull null])
            item.imageName3 = [itemDictionary[@"images"] valueForKey:@"large"];
        
        if ([itemDictionary valueForKeyPath:@"retail_usd"] && [itemDictionary valueForKeyPath:@"retail_usd"] != [NSNull null])
            item.retailUSD = [itemDictionary valueForKey:@"retail_usd"];
        
        if ([itemDictionary valueForKeyPath:@"retail_cad"] && [itemDictionary valueForKeyPath:@"retail_cad"] != [NSNull null])
            item.retailCAD = [itemDictionary valueForKey:@"retail_cad"];
        
        if ([itemDictionary valueForKeyPath:@"price_usd"] && [itemDictionary valueForKeyPath:@"price_usd"] != [NSNull null])
            item.priceUSD = [itemDictionary valueForKey:@"price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"price_cad"] && [itemDictionary valueForKeyPath:@"price_cad"] != [NSNull null])
            item.priceCAD = [itemDictionary valueForKey:@"price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_usd"] && [itemDictionary valueForKeyPath:@"employee_price_usd"] != [NSNull null])
            item.employeePriceUSD = [itemDictionary valueForKey:@"employee_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_cad"] && [itemDictionary valueForKeyPath:@"employee_price_cad"] != [NSNull null])
            item.employeePriceCAD = [itemDictionary valueForKey:@"employee_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_usd"] && [itemDictionary valueForKeyPath:@"clearance_price_usd"] != [NSNull null])
            item.clearancePriceUSD = [itemDictionary valueForKey:@"clearance_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_cad"] && [itemDictionary valueForKeyPath:@"clearance_price_cad"] != [NSNull null])
            item.clearancePriceCAD = [itemDictionary valueForKey:@"clearance_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"vendor_id"] && [itemDictionary valueForKeyPath:@"vendor_id"] != [NSNull null])
            item.vendorId = [itemDictionary valueForKey:@"vendor_id"];
        
        if ([itemDictionary valueForKeyPath:@"drop_ship"] && [itemDictionary valueForKeyPath:@"drop_ship"] != [NSNull null])
            item.dropShip = [itemDictionary valueForKey:@"drop_ship"];
        
        
        
        /*
         if ([itemDictionary[@"images"] valueForKeyPath:@"small"])
         item.imageName4 = [itemDictionary[@"images"] valueForKey:@"small"];
         
         if ([itemDictionary[@"images"] valueForKeyPath:@"medium"])
         item.imageName5 = [itemDictionary[@"images"] valueForKey:@"medium"];
         
         if ([itemDictionary[@"images"] valueForKeyPath:@"large"])
         item.imageName6 = [itemDictionary[@"images"] valueForKey:@"large"];
         
         @dynamic expiryDateTime;
         @dynamic videoName1;
         @dynamic videoName2;
         @dynamic shipTime;
         
         */

        
        
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                        inManagedObjectContext:context];
        
        
        if ([itemDictionary valueForKeyPath:@"event_id"] && [itemDictionary valueForKeyPath:@"event_id"] != [NSNull null])
            item.eventId = [itemDictionary valueForKeyPath:@"event_id"];
        
        if ([itemDictionary valueForKeyPath:@"short_decs"] && [itemDictionary valueForKeyPath:@"short_decs"] != [NSNull null])
            item.shortItemDescription = [itemDictionary valueForKey:@"short_decs"];
        
        if ([itemDictionary valueForKeyPath:@"long_desc"] && [itemDictionary valueForKeyPath:@"long_desc"] != [NSNull null])
            item.longItemDescription = [itemDictionary valueForKey:@"long_desc"];
        
        if ([itemDictionary valueForKeyPath:@"sku"] && [itemDictionary valueForKeyPath:@"sku"] != [NSNull null])
            item.sku = [itemDictionary valueForKey:@"sku"];
        
        if ([itemDictionary valueForKeyPath:@"priority_a"] && [itemDictionary valueForKeyPath:@"priority_a"] != [NSNull null])
            item.priorityA = [itemDictionary valueForKey:@"priority_a"];
        
        if ([itemDictionary valueForKeyPath:@"priority_b"] && [itemDictionary valueForKeyPath:@"priority_b"] != [NSNull null])
            item.priorityB = [itemDictionary valueForKey:@"priority_b"];
        
        if ([itemDictionary valueForKeyPath:@"brand"] && [itemDictionary valueForKeyPath:@"brand"] != [NSNull null])
            item.brand = [itemDictionary valueForKey:@"brand"];
        
        if ([itemDictionary valueForKeyPath:@"attribute_list"] && [itemDictionary valueForKeyPath:@"attribute_list"] != [NSNull null])
            item.attributeList = [itemDictionary valueForKey:@"attribute_list"];
        
        if ([itemDictionary valueForKeyPath:@"product_type"] && [itemDictionary valueForKeyPath:@"product_type"] != [NSNull null])
            item.productType = [itemDictionary valueForKey:@"product_type"];
        
        if ([itemDictionary valueForKeyPath:@"category_list"] && [itemDictionary valueForKeyPath:@"category_list"] != [NSNull null])
            item.categoryList = [itemDictionary valueForKey:@"category_list"];
        
        if ([itemDictionary valueForKeyPath:@"related_skus_list"] && [itemDictionary valueForKeyPath:@"related_skus_list"] != [NSNull null])
            item.relatedSkuslist = [itemDictionary valueForKey:@"related_skus_list"];
        
        if ([itemDictionary valueForKeyPath:@"special_notes"] && [itemDictionary valueForKeyPath:@"special_notes"] != [NSNull null])
            item.specialNote = [itemDictionary valueForKey:@"special_notes"];
        
        if ([itemDictionary valueForKeyPath:@"general_notes"] && [itemDictionary valueForKeyPath:@"general_notes"] != [NSNull null])
            item.generalNote = [itemDictionary valueForKey:@"general_notes"];
        
        if ([itemDictionary valueForKeyPath:@"image_count"] && [itemDictionary valueForKeyPath:@"image_count"] != [NSNull null])
            item.imageCount = [itemDictionary valueForKey:@"image_count"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"small"] && [itemDictionary[@"images"] valueForKeyPath:@"small"] != [NSNull null])
            item.imageName1 = [itemDictionary[@"images"] valueForKey:@"small"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"medium"] && [itemDictionary[@"images"] valueForKeyPath:@"medium"] != [NSNull null])
            item.imageName2 = [itemDictionary[@"images"] valueForKey:@"medium"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"large"] && [itemDictionary[@"images"] valueForKeyPath:@"large"] != [NSNull null])
            item.imageName3 = [itemDictionary[@"images"] valueForKey:@"large"];
        
        if ([itemDictionary valueForKeyPath:@"retail_usd"] && [itemDictionary valueForKeyPath:@"retail_usd"] != [NSNull null])
            item.retailUSD = [itemDictionary valueForKey:@"retail_usd"];
        
        if ([itemDictionary valueForKeyPath:@"retail_cad"] && [itemDictionary valueForKeyPath:@"retail_cad"] != [NSNull null])
            item.retailCAD = [itemDictionary valueForKey:@"retail_cad"];
        
        if ([itemDictionary valueForKeyPath:@"price_usd"] && [itemDictionary valueForKeyPath:@"price_usd"] != [NSNull null])
            item.priceUSD = [itemDictionary valueForKey:@"price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"price_cad"] && [itemDictionary valueForKeyPath:@"price_cad"] != [NSNull null])
            item.priceCAD = [itemDictionary valueForKey:@"price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_usd"] && [itemDictionary valueForKeyPath:@"employee_price_usd"] != [NSNull null])
            item.employeePriceUSD = [itemDictionary valueForKey:@"employee_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_cad"] && [itemDictionary valueForKeyPath:@"employee_price_cad"] != [NSNull null])
            item.employeePriceCAD = [itemDictionary valueForKey:@"employee_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_usd"] && [itemDictionary valueForKeyPath:@"clearance_price_usd"] != [NSNull null])
            item.clearancePriceUSD = [itemDictionary valueForKey:@"clearance_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_cad"] && [itemDictionary valueForKeyPath:@"clearance_price_cad"] != [NSNull null])
            item.clearancePriceCAD = [itemDictionary valueForKey:@"clearance_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"vendor_id"] && [itemDictionary valueForKeyPath:@"vendor_id"] != [NSNull null])
            item.vendorId = [itemDictionary valueForKey:@"vendor_id"];
        
        if ([itemDictionary valueForKeyPath:@"drop_ship"] && [itemDictionary valueForKeyPath:@"drop_ship"] != [NSNull null])
            item.dropShip = [itemDictionary valueForKey:@"drop_ship"];

        
        
        /*
         if ([itemDictionary[@"images"] valueForKeyPath:@"small"])
         item.imageName4 = [itemDictionary[@"images"] valueForKey:@"small"];
         
         if ([itemDictionary[@"images"] valueForKeyPath:@"medium"])
         item.imageName5 = [itemDictionary[@"images"] valueForKey:@"medium"];
         
         if ([itemDictionary[@"images"] valueForKeyPath:@"large"])
         item.imageName6 = [itemDictionary[@"images"] valueForKey:@"large"];
         
         @dynamic expiryDateTime;
         @dynamic videoName1;
         @dynamic videoName2;
         @dynamic shipTime;
         
         */
    }
    
    return item;
}

+ (NSMutableArray *)loadItemsFromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in items) {
        
        NSObject *someObject = [self itemWithAppServerInfo:item inManagedObjectContext:context];
        if (someObject)
            [itemArray addObject:someObject];
        
    }
    
    return itemArray;
}


@end
