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
        
        if ([itemDictionary valueForKeyPath:@"id"])
            if ([itemDictionary valueForKeyPath:@"id"])
                if ([itemDictionary valueForKeyPath:@"id"])
                    if ([itemDictionary valueForKeyPath:@"id"])
                        if ([itemDictionary valueForKeyPath:@"id"])
                            ;

        
        if ([itemDictionary valueForKeyPath:@"id"])
            if ([itemDictionary valueForKeyPath:@"id"])
                if ([itemDictionary valueForKeyPath:@"id"])
                    if ([itemDictionary valueForKeyPath:@"id"])
                        if ([itemDictionary valueForKeyPath:@"id"])
                            if ([itemDictionary valueForKeyPath:@"id"])
                                if ([itemDictionary valueForKeyPath:@"id"])
                                    if ([itemDictionary valueForKeyPath:@"id"])
                                        if ([itemDictionary valueForKeyPath:@"id"])
                                            
                                            ;
        /*
        
        @dynamic expiryDateTime;
        @dynamic imageName1;

        @dynamic imageCount;
        @dynamic imageName5;
        @dynamic imageName6;
        @dynamic imageName2;
        @dynamic imageName3;
        @dynamic imageName4;
        @dynamic videoCount;
        @dynamic videoName2;


        @dynamic retailUSD;
        @dynamic videoName1;
        @dynamic retailCAD;
        @dynamic priceUSD;
        @dynamic priceCAD;
        @dynamic employeePriceUSD;
        @dynamic employeePriceCAD;
        @dynamic clearancePriceUSD;
        @dynamic clearancePriceCAD;
        @dynamic vendorId;
    
        @dynamic specialNote;
        @dynamic generalNote;
        @dynamic shipTime;
        @dynamic dropShip;
        
        */
        
        
        
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                        inManagedObjectContext:context];
        
        if ([[itemDictionary valueForKeyPath:@"id"] stringValue])
            item.itemId = [[itemDictionary valueForKeyPath:@"id"] stringValue];
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
