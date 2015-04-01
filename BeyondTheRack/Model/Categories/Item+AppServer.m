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

    NSLog(@"add employee price logic: if 0 not employee else assign it to salePrice: extractItemFromProductJSONDictionary");
    
    
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
    
    if ([itemDictionary valueForKeyPath:@"retail_price_ca"] && [itemDictionary valueForKeyPath:@"retail_price_ca"] != [NSNull null])
        item.retailPrice = [nformatter numberFromString:[itemDictionary valueForKey:@"retail_price_ca"]];
    
    if ([itemDictionary valueForKeyPath:@"regular_price_ca"] && [itemDictionary valueForKeyPath:@"regular_price_ca"] != [NSNull null])
        item.salePrice = [nformatter numberFromString:[itemDictionary valueForKey:@"regular_price_ca"]];
  
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
    
    NSLog(@"the backend search api response must be updated for correct price values @ extractItemFromSearchJSONDictionary");
    
    NSLog(@"add employee price logic: if 0 not employee else assign it to salePrice: extractItemFromSearchJSONDictionary");
    
    if ([itemDictionary valueForKeyPath:@"event_id"] && [itemDictionary valueForKeyPath:@"event_id"] != [NSNull null])
        item.eventId = [itemDictionary valueForKeyPath:@"event_id"];
    
    if ([itemDictionary valueForKeyPath:@"short_description"] && [itemDictionary valueForKeyPath:@"short_description"] != [NSNull null])
        item.shortItemDescription = [itemDictionary valueForKey:@"short_description"];
    
    if ([itemDictionary valueForKeyPath:@"sku"] && [itemDictionary valueForKeyPath:@"sku"] != [NSNull null])
        item.sku = [itemDictionary valueForKey:@"sku"];
    
    if ([itemDictionary valueForKeyPath:@"brand"] && [itemDictionary valueForKeyPath:@"brand"] != [NSNull null])
        item.brand = [itemDictionary valueForKey:@"brand"];
   
    if ([itemDictionary valueForKeyPath:@"price_retail_ca"] && [itemDictionary valueForKeyPath:@"price_retail_ca"] != [NSNull null])
        item.retailPrice = [itemDictionary valueForKey:@"price_retail_ca"];
    
     if ([itemDictionary valueForKeyPath:@"price_reg_ca"] && [itemDictionary valueForKeyPath:@"price_reg_ca"] != [NSNull null])
        item.salePrice = [itemDictionary valueForKey:@"price_reg_ca"];
   
    if ([itemDictionary valueForKeyPath:@"price_emp_ca"] && [itemDictionary valueForKeyPath:@"price_emp_ca"] != [NSNull null])
        item.employeePrice = [itemDictionary valueForKey:@"price_emp_ca"];
    
    return item;
}




@end
