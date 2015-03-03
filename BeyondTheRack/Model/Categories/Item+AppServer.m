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
    
    item.shortItemDescription = @"dummy";
}




+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    NSString *unique = itemDictionary[@"sku"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.predicate = [NSPredicate predicateWithFormat:@"sku == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        item = [matches firstObject];
        
        item = [self extractItemFromProductJSONDictionary:itemDictionary forItem:item];
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                             inManagedObjectContext:context];
        
        item = [self extractItemFromProductJSONDictionary:itemDictionary forItem:item];
    }
    
    return item;
}


+ (Item *)itemWithSearchResponseInfo:(NSDictionary *)itemDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    NSString *unique = itemDictionary[@"sku"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.predicate = [NSPredicate predicateWithFormat:@"sku == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        item = [matches firstObject];
        
        item = [self extractItemFromSearchJSONDictionary:itemDictionary forItem:item];
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                        inManagedObjectContext:context];
        
        item = [self extractItemFromSearchJSONDictionary:itemDictionary forItem:item];
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



+ (NSMutableArray *)loadItemsFromSearchResponseArray:(NSArray *)items // of AppServer Item NSDictionary
                       intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in items) {
        
        NSObject *someObject = [self itemWithSearchResponseInfo:item inManagedObjectContext:context];
        
        if (someObject)
            [itemArray addObject:someObject];
        
    }
    
    return itemArray;
}


+ (Item *)extractItemFromProductJSONDictionary:(NSDictionary *)itemDictionary forItem:(Item *)item {

    
    NSNumberFormatter *nformatter = [[NSNumberFormatter alloc] init];
    nformatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    if ([itemDictionary valueForKeyPath:@"event_id"] && [itemDictionary valueForKeyPath:@"event_id"] != [NSNull null])
        item.eventId = [itemDictionary valueForKeyPath:@"event_id"];
    
    if ([itemDictionary valueForKeyPath:@"short_desc"] && [itemDictionary valueForKeyPath:@"short_desc"] != [NSNull null])
        item.shortItemDescription = [itemDictionary valueForKey:@"short_desc"];
    
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
    
    if ([itemDictionary valueForKeyPath:@"retail_price_us"] && [itemDictionary valueForKeyPath:@"retail_price_us"] != [NSNull null])
        item.retailUSD = [nformatter numberFromString:[itemDictionary valueForKey:@"retail_price_us"]];
    
    if ([itemDictionary valueForKeyPath:@"retail_price_ca"] && [itemDictionary valueForKeyPath:@"retail_price_ca"] != [NSNull null])
        item.retailCAD = [nformatter numberFromString:[itemDictionary valueForKey:@"retail_price_ca"]];
    
    if ([itemDictionary valueForKeyPath:@"regular_price_us"] && [itemDictionary valueForKeyPath:@"regular_price_us"] != [NSNull null])
        item.priceUSD = [nformatter numberFromString:[itemDictionary valueForKey:@"regular_price_us"]];
    
    if ([itemDictionary valueForKeyPath:@"regular_price_ca"] && [itemDictionary valueForKeyPath:@"regular_price_ca"] != [NSNull null])
        item.priceCAD = [nformatter numberFromString:[itemDictionary valueForKey:@"regular_price_ca"]];
    
    if ([itemDictionary valueForKeyPath:@"employee_price_us"] && [itemDictionary valueForKeyPath:@"employee_price_us"] != [NSNull null])
        item.employeePriceUSD = [nformatter numberFromString:[itemDictionary valueForKey:@"employee_price_us"]];
    
    if ([itemDictionary valueForKeyPath:@"employee_price_ca"] && [itemDictionary valueForKeyPath:@"employee_price_ca"] != [NSNull null])
        item.employeePriceCAD = [nformatter numberFromString:[itemDictionary valueForKey:@"employee_price_ca"] ];
    
    if ([itemDictionary valueForKeyPath:@"clearance_price_us"] && [itemDictionary valueForKeyPath:@"clearance_price_us"] != [NSNull null])
        item.clearancePriceUSD = [nformatter numberFromString:[itemDictionary valueForKey:@"clearance_price_us"] ];
    
    if ([itemDictionary valueForKeyPath:@"clearance_price_ca"] && [itemDictionary valueForKeyPath:@"clearance_price_ca"] != [NSNull null])
        item.clearancePriceCAD = [nformatter numberFromString:[itemDictionary valueForKey:@"clearance_price_ca"] ];
    
    if ([itemDictionary valueForKeyPath:@"drop_ship"] && [itemDictionary valueForKeyPath:@"drop_ship"] != [NSNull null])
        item.dropShip = [itemDictionary valueForKey:@"drop_ship"];

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

    if ([itemDictionary valueForKeyPath:@"restricted_shipping"] && [itemDictionary valueForKeyPath:@"restricted_shipping"] != [NSNull null])
        item.restrictedShipping = [itemDictionary valueForKey:@"restricted_shipping"];

    
    
    return item;

}





+ (Item *)extractItemFromSearchJSONDictionary:(NSDictionary *)itemDictionary forItem:(Item *)item {
    
    if ([itemDictionary valueForKeyPath:@"event_id"] && [itemDictionary valueForKeyPath:@"event_id"] != [NSNull null])
        item.eventId = [itemDictionary valueForKeyPath:@"event_id"];
    
    if ([itemDictionary valueForKeyPath:@"short_description"] && [itemDictionary valueForKeyPath:@"short_description"] != [NSNull null])
        item.shortItemDescription = [itemDictionary valueForKey:@"short_description"];
    
    if ([itemDictionary valueForKeyPath:@"sku"] && [itemDictionary valueForKeyPath:@"sku"] != [NSNull null])
        item.sku = [itemDictionary valueForKey:@"sku"];
    
    if ([itemDictionary valueForKeyPath:@"brand"] && [itemDictionary valueForKeyPath:@"brand"] != [NSNull null])
        item.brand = [itemDictionary valueForKey:@"brand"];
    
    if ([itemDictionary valueForKeyPath:@"price_retail_us"] && [itemDictionary valueForKeyPath:@"price_retail_us"] != [NSNull null])
        item.retailUSD = [itemDictionary valueForKey:@"price_retail_us"];
    
    if ([itemDictionary valueForKeyPath:@"price_retail_ca"] && [itemDictionary valueForKeyPath:@"price_retail_ca"] != [NSNull null])
        item.retailCAD = [itemDictionary valueForKey:@"price_retail_ca"];
    
    if ([itemDictionary valueForKeyPath:@"price_reg_us"] && [itemDictionary valueForKeyPath:@"price_reg_us"] != [NSNull null])
        item.priceUSD = [itemDictionary valueForKey:@"price_reg_us"];
    
    if ([itemDictionary valueForKeyPath:@"price_reg_ca"] && [itemDictionary valueForKeyPath:@"price_reg_ca"] != [NSNull null])
        item.priceCAD = [itemDictionary valueForKey:@"price_reg_ca"];
    
    if ([itemDictionary valueForKeyPath:@"price_emp_us"] && [itemDictionary valueForKeyPath:@"price_emp_us"] != [NSNull null])
        item.employeePriceUSD = [itemDictionary valueForKey:@"price_emp_us"];
    
    if ([itemDictionary valueForKeyPath:@"price_emp_ca"] && [itemDictionary valueForKeyPath:@"price_emp_ca"] != [NSNull null])
        item.employeePriceCAD = [itemDictionary valueForKey:@"price_emp_ca"];
    
    if ([itemDictionary valueForKeyPath:@"price_clear_us"] && [itemDictionary valueForKeyPath:@"price_clear_us"] != [NSNull null])
        item.clearancePriceUSD = [itemDictionary valueForKey:@"price_clear_us"];
    
    if ([itemDictionary valueForKeyPath:@"price_clear_ca"] && [itemDictionary valueForKeyPath:@"price_clear_ca"] != [NSNull null])
        item.clearancePriceCAD = [itemDictionary valueForKey:@"price_clear_ca"];
    
    if ([itemDictionary valueForKeyPath:@"vendor_id"] && [itemDictionary valueForKeyPath:@"vendor_id"] != [NSNull null])
        item.vendorId = [itemDictionary valueForKey:@"vendor_id"];

    
    return item;
}




@end
