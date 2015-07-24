//
//  FAQ+AppServer.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FAQ.h"

@interface FAQ (AppServer)

+ (NSArray *)arrayOfFAQWithAppServerInfo:(NSDictionary *)FAQDictionary;

@end
