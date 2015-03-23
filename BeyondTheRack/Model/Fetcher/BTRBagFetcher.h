//
//  BTRBagFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"

@interface BTRBagFetcher : BTRFetcher


/*
 
 Bag calls requires a valid "session" http header.
 
 GET www.mobile.btrdev.com/siteapi/bag
 [{"event_id":"25744","sku":"NOVNOV702","variant":"Z","cart_time":1426859370,"quantity":"2"}]
 
 POST  www.mobile.btrdev.com/siteapi/bag/add
 {"event_id":"25744","sku":"NOVNOV702","variant":"Z"}
 
 POST www.mobile.btrdev.com/siteapi/bag/remove
 {"event_id":"25744","sku":"NOVNOV702","variant":"Z"}
 
 POST www.mobile.btrdev.com/siteapi/bag/clear
 => nothing required

 
 */

@end
