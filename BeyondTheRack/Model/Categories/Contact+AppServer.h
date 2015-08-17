//
//  Contact+AppServer.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Contact (AppServer)

+ (Contact *)contactWithAppServerInfo:(NSDictionary *)contactDictionary;

@end
