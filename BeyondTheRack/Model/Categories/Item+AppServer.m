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
        
        if ([itemDictionary valueForKeyPath:@"event_id"])
            item.eventId = [itemDictionary valueForKeyPath:@"event_id"];
        
        if ([itemDictionary valueForKeyPath:@"short_decs"])
            item.shortItemDescription = [itemDictionary valueForKey:@"short_decs"];
        
        if ([itemDictionary valueForKeyPath:@"long_desc"])
            item.longItemDescription = [itemDictionary valueForKey:@"long_desc"];
        
        if ([itemDictionary valueForKeyPath:@"image_count"])
            item.imageCount = [itemDictionary valueForKey:@"image_count"];
        
        if ([itemDictionary valueForKeyPath:@"sku"])
            item.sku = [itemDictionary valueForKey:@"sku"];
        
        if ([itemDictionary valueForKeyPath:@"priority_a"])
            item.priorityA = [itemDictionary valueForKey:@"priority_a"];
        
        if ([itemDictionary valueForKeyPath:@"priority_b"])
            item.priorityB = [itemDictionary valueForKey:@"priority_b"];
        
        if ([itemDictionary valueForKeyPath:@"brand"])
            item.brand = [itemDictionary valueForKey:@"brand"];
    
        if ([itemDictionary valueForKeyPath:@"attribute_list"])
            item.attributeList = [itemDictionary valueForKey:@"attribute_list"];
        
        if ([itemDictionary valueForKeyPath:@"product_type"])
            item.productType = [itemDictionary valueForKey:@"product_type"];
        
        if ([itemDictionary valueForKeyPath:@"category_list"])
            item.categoryList = [itemDictionary valueForKey:@"category_list"];
        
        if ([itemDictionary valueForKeyPath:@"related_skus_list"])
            item.relatedSkuslist = [itemDictionary valueForKey:@"related_skus_list"];
        
        if ([itemDictionary valueForKeyPath:@"special_notes"])
            item.specialNote = [itemDictionary valueForKey:@"special_notes"];
        
        if ([itemDictionary valueForKeyPath:@"general_notes"])
            item.generalNote = [itemDictionary valueForKey:@"general_notes"];
        
        if ([itemDictionary valueForKeyPath:@"image_count"])
            item.imageCount = [itemDictionary valueForKey:@"image_count"];

        if ([itemDictionary[@"images"] valueForKeyPath:@"small"])
            item.imageName1 = [itemDictionary[@"images"] valueForKey:@"small"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"medium"])
            item.imageName2 = [itemDictionary[@"images"] valueForKey:@"medium"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"large"])
            item.imageName3 = [itemDictionary[@"images"] valueForKey:@"large"];
        
        if ([itemDictionary valueForKeyPath:@"retail_usd"])
            item.retailUSD = [itemDictionary valueForKey:@"retail_usd"];
        
        if ([itemDictionary valueForKeyPath:@"retail_cad"])
            item.retailCAD = [itemDictionary valueForKey:@"retail_cad"];
        
        if ([itemDictionary valueForKeyPath:@"price_usd"])
            item.priceUSD = [itemDictionary valueForKey:@"price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"price_cad"])
            item.priceCAD = [itemDictionary valueForKey:@"price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_usd"])
            item.employeePriceUSD = [itemDictionary valueForKey:@"employee_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_cad"])
            item.employeePriceCAD = [itemDictionary valueForKey:@"employee_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_usd"])
            item.clearancePriceUSD = [itemDictionary valueForKey:@"clearance_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_cad"])
            item.clearancePriceCAD = [itemDictionary valueForKey:@"clearance_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"vendor_id"])
            item.vendorId = [itemDictionary valueForKey:@"vendor_id"];
        
        if ([itemDictionary valueForKeyPath:@"drop_ship"])
            item.dropShip = [itemDictionary valueForKey:@"drop_ship"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_cad"])
            item.clearancePriceCAD = [itemDictionary valueForKey:@"clearance_price_cad"];
        
        
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
        
        
        if ([itemDictionary valueForKeyPath:@"event_id"])
            item.eventId = [itemDictionary valueForKeyPath:@"event_id"];
        
        if ([itemDictionary valueForKeyPath:@"short_decs"])
            item.shortItemDescription = [itemDictionary valueForKey:@"short_decs"];
        
        if ([itemDictionary valueForKeyPath:@"long_desc"])
            item.longItemDescription = [itemDictionary valueForKey:@"long_desc"];
        
        if ([itemDictionary valueForKeyPath:@"image_count"])
            item.imageCount = [itemDictionary valueForKey:@"image_count"];
        
        if ([itemDictionary valueForKeyPath:@"sku"])
            item.sku = [itemDictionary valueForKey:@"sku"];
        
        if ([itemDictionary valueForKeyPath:@"priority_a"])
            item.priorityA = [itemDictionary valueForKey:@"priority_a"];
        
        if ([itemDictionary valueForKeyPath:@"priority_b"])
            item.priorityB = [itemDictionary valueForKey:@"priority_b"];
        
        if ([itemDictionary valueForKeyPath:@"brand"])
            item.brand = [itemDictionary valueForKey:@"brand"];
        
        if ([itemDictionary valueForKeyPath:@"attribute_list"])
            item.attributeList = [itemDictionary valueForKey:@"attribute_list"];
        
        if ([itemDictionary valueForKeyPath:@"product_type"])
            item.productType = [itemDictionary valueForKey:@"product_type"];
        
        if ([itemDictionary valueForKeyPath:@"category_list"])
            item.categoryList = [itemDictionary valueForKey:@"category_list"];
        
        if ([itemDictionary valueForKeyPath:@"related_skus_list"])
            item.relatedSkuslist = [itemDictionary valueForKey:@"related_skus_list"];
        
        if ([itemDictionary valueForKeyPath:@"special_notes"])
            item.specialNote = [itemDictionary valueForKey:@"special_notes"];
        
        if ([itemDictionary valueForKeyPath:@"general_notes"])
            item.generalNote = [itemDictionary valueForKey:@"general_notes"];
        
        if ([itemDictionary valueForKeyPath:@"image_count"])
            item.imageCount = [itemDictionary valueForKey:@"image_count"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"small"])
            item.imageName1 = [itemDictionary[@"images"] valueForKey:@"small"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"medium"])
            item.imageName2 = [itemDictionary[@"images"] valueForKey:@"medium"];
        
        if ([itemDictionary[@"images"] valueForKeyPath:@"large"])
            item.imageName3 = [itemDictionary[@"images"] valueForKey:@"large"];
        
        if ([itemDictionary valueForKeyPath:@"retail_usd"])
            item.retailUSD = [itemDictionary valueForKey:@"retail_usd"];
        
        if ([itemDictionary valueForKeyPath:@"retail_cad"])
            item.retailCAD = [itemDictionary valueForKey:@"retail_cad"];
        
        if ([itemDictionary valueForKeyPath:@"price_usd"])
            item.priceUSD = [itemDictionary valueForKey:@"price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"price_cad"])
            item.priceCAD = [itemDictionary valueForKey:@"price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_usd"])
            item.employeePriceUSD = [itemDictionary valueForKey:@"employee_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"employee_price_cad"])
            item.employeePriceCAD = [itemDictionary valueForKey:@"employee_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_usd"])
            item.clearancePriceUSD = [itemDictionary valueForKey:@"clearance_price_usd"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_cad"])
            item.clearancePriceCAD = [itemDictionary valueForKey:@"clearance_price_cad"];
        
        if ([itemDictionary valueForKeyPath:@"vendor_id"])
            item.vendorId = [itemDictionary valueForKey:@"vendor_id"];
        
        if ([itemDictionary valueForKeyPath:@"drop_ship"])
            item.dropShip = [itemDictionary valueForKey:@"drop_ship"];
        
        if ([itemDictionary valueForKeyPath:@"clearance_price_cad"])
            item.clearancePriceCAD = [itemDictionary valueForKey:@"clearance_price_cad"];
        
        
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
