//
//  Item+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Item.h"

@interface Item (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadItemsFromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context;

@end



//"price_retail_ca":190,"price_retail_us":190,"price_reg_ca":115,"price_reg_us":115,"price_clear_ca":0,"price_clear_us":0,"price_emp_ca":76.96,"price_emp_us":77.63,"price_sort_ca":115,"price_sort_us":115,"