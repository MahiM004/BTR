//
//  Order+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Order+AppServer.h"

@implementation Order (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    Order *order = nil;
    
    order = [NSEntityDescription insertNewObjectForEntityForName:@"Order"
                                                    inManagedObjectContext:context];
    
    order.orderStatus = @"dummy";
}


+ (Order *)orderWithAppServerInfo:(NSDictionary *)orderDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    Order *order = nil;
    NSString *unique = orderDictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Order"];
    request.predicate = [NSPredicate predicateWithFormat:@"orderId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        order = [matches firstObject];
        
        if ([orderDictionary valueForKeyPath:@"id"])
            order.orderId = [orderDictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        order = [NSEntityDescription insertNewObjectForEntityForName:@"Order"
                                                        inManagedObjectContext:context];
        
        if ([[orderDictionary valueForKeyPath:@"id"] stringValue])
            order.orderId = [[orderDictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return order;
}

+ (NSMutableArray *)loadOrdersFromAppServerArray:(NSArray *)orders // of AppServer Order NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *orderArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *order in orders) {
        
        NSObject *someObject = [self orderWithAppServerInfo:order inManagedObjectContext:context];
        if (someObject)
            [orderArray addObject:someObject];
        
    }
    
    return orderArray;
}




+ (Order *)extractOrderfromJSONDictionary:(NSDictionary *)orderDictionary forOrder:(Order *)order {
    
    
    NSDictionary *cardInfoDic = orderDictionary[@"cardInfo"];
    order = [self extractCardInfofromJSONDictionary:cardInfoDic forOrder:order];

    NSDictionary *orderInfoDic = orderDictionary[@"orderInfo"];
    order = [self extractOrderfromJSONDictionary:orderInfoDic forOrder:order];

    
  
    return order;
}



+ (Order *)extractCardInfofromJSONDictionary:(NSDictionary *)cardInfoDic forOrder:(Order *)order {
    
    
    if ([cardInfoDic valueForKeyPath:@"cvv"] && [cardInfoDic valueForKeyPath:@"cvv"] != [NSNull null]) {
        order.ccvNumber = [cardInfoDic valueForKeyPath:@"cvv"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"force_card_update"] && [cardInfoDic valueForKeyPath:@"force_card_update"] != [NSNull null]) {
        order.forceCardUpdate = [cardInfoDic valueForKeyPath:@"force_card_update"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"lockCCFields"] && [cardInfoDic valueForKeyPath:@"lockCCFields"] != [NSNull null]) {
        order.lockCCFields = [cardInfoDic valueForKeyPath:@"lockCCFields"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"month"] && [cardInfoDic valueForKeyPath:@"month"] != [NSNull null]) {
        order.expiryMonth = [cardInfoDic valueForKeyPath:@"month"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"name"] && [cardInfoDic valueForKeyPath:@"name"] != [NSNull null]) {
        order.cardHolderName = [cardInfoDic valueForKeyPath:@"name"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"number"] && [cardInfoDic valueForKeyPath:@"number"] != [NSNull null]) {
        order.cardNumber = [cardInfoDic valueForKeyPath:@"number"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"payment_type"] && [cardInfoDic valueForKeyPath:@"payment_type"] != [NSNull null]) {
        order.paymentType = [cardInfoDic valueForKeyPath:@"payment_type"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"remember_card"] && [cardInfoDic valueForKeyPath:@"remember_card"] != [NSNull null]) {
        order.rememberCard = [cardInfoDic valueForKeyPath:@"remember_card"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"require_ccv"] && [cardInfoDic valueForKeyPath:@"require_ccv"] != [NSNull null]) {
        order.requireCcv = [cardInfoDic valueForKeyPath:@"require_ccv"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"token"] && [cardInfoDic valueForKeyPath:@"token"] != [NSNull null]) {
        order.cardToken = [cardInfoDic valueForKeyPath:@"token"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"type"] && [cardInfoDic valueForKeyPath:@"type"] != [NSNull null]) {
        order.cardType = [cardInfoDic valueForKeyPath:@"type"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"use_token"] && [cardInfoDic valueForKeyPath:@"use_token"] != [NSNull null]) {
        order.useToken = [cardInfoDic valueForKeyPath:@"use_token"];
    }
    
    if ([cardInfoDic valueForKeyPath:@"year"] && [cardInfoDic valueForKeyPath:@"year"] != [NSNull null]) {
        order.expiryYear = [cardInfoDic valueForKeyPath:@"year"];
    }
    
    return order;
}



+ (Order *)extractOrderInfofromJSONDictionary:(NSDictionary *)orderInfoDic forOrder:(Order *)order {
    
    
    
    if ([orderInfoDic valueForKeyPath:@"billto_shipto"] && [orderInfoDic valueForKeyPath:@"billto_shipto"] != [NSNull null]) {
        order.billingSameAsShipping = [orderInfoDic valueForKeyPath:@"billto_shipto"];
    }
    
    if ([orderInfoDic valueForKeyPath:@"eligible_pickup"] && [orderInfoDic valueForKeyPath:@"eligible_pickup"] != [NSNull null]) {
        order.eligiblePickup = [orderInfoDic valueForKeyPath:@"eligible_pickup"];
    }
 
    if ([orderInfoDic valueForKeyPath:@"is_gift"] && [orderInfoDic valueForKeyPath:@"is_gift"] != [NSNull null]) {
        order.isGift = [orderInfoDic valueForKeyPath:@"is_gift"];
    }

    if ([orderInfoDic valueForKeyPath:@"is_pickup"] && [orderInfoDic valueForKeyPath:@"is_pickup"] != [NSNull null]) {
        order.isPickup = [orderInfoDic valueForKeyPath:@"is_pickup"];
    }

    if ([orderInfoDic valueForKeyPath:@"recipient_message"] && [orderInfoDic valueForKeyPath:@"recipient_massage"] != [NSNull null]) {
        order.recipientGiftMessage = [orderInfoDic valueForKeyPath:@"recipient_massage"];
    }

    if ([orderInfoDic valueForKeyPath:@"vip_pickup"] && [orderInfoDic valueForKeyPath:@"vip_pickup"] != [NSNull null]) {
        order.vipPickup = [orderInfoDic valueForKeyPath:@"vip_pickup"];
    }

    if ([orderInfoDic valueForKeyPath:@"vip_pickup_eligible"] && [orderInfoDic valueForKeyPath:@"vip_pickup_eligible"] != [NSNull null]) {
        order.vipPickupEligible = [orderInfoDic valueForKeyPath:@"vip_pickup_eligible"];
    }
    
    
    /**
     
     Billing Address
     
     */

    NSDictionary *billingAddressDic = orderInfoDic[@"billing"];
    
    if ([billingAddressDic valueForKeyPath:@"address1"] && [billingAddressDic valueForKeyPath:@"address1"] != [NSNull null]) {
        order.billingAddressLine1 = [billingAddressDic valueForKeyPath:@"address1"];
    }

    if ([billingAddressDic valueForKeyPath:@"address2"] && [billingAddressDic valueForKeyPath:@"address2"] != [NSNull null]) {
        order.billingAddressLine2 = [billingAddressDic valueForKeyPath:@"address2"];
    }
    
    if ([billingAddressDic valueForKeyPath:@"city"] && [billingAddressDic valueForKeyPath:@"city"] != [NSNull null]) {
        order.billingCity = [billingAddressDic valueForKeyPath:@"city"];
    }
    
    if ([billingAddressDic valueForKeyPath:@"country"] && [billingAddressDic valueForKeyPath:@"country"] != [NSNull null]) {
        order.billingCountry = [billingAddressDic valueForKeyPath:@"country"];
    }

    if ([billingAddressDic valueForKeyPath:@"name"] && [billingAddressDic valueForKeyPath:@"name"] != [NSNull null]) {
        order.billingName = [billingAddressDic valueForKeyPath:@"name"];
    }

    if ([billingAddressDic valueForKeyPath:@"phone"] && [billingAddressDic valueForKeyPath:@"phone"] != [NSNull null]) {
        order.billingPhoneNumber = [billingAddressDic valueForKeyPath:@"phone"];
    }

    if ([billingAddressDic valueForKeyPath:@"postal"] && [billingAddressDic valueForKeyPath:@"postal"] != [NSNull null]) {
        order.billingPostalCode = [billingAddressDic valueForKeyPath:@"postal"];
    }

    if ([billingAddressDic valueForKeyPath:@"state"] && [billingAddressDic valueForKeyPath:@"state"] != [NSNull null]) {
        order.billingProvince = [billingAddressDic valueForKeyPath:@"state"];
    }
 
    
    
    /**
     
     Shipping Address
     
     */
    
    NSDictionary *shippingAddressDic = orderInfoDic[@"shipping"];
    
    if ([shippingAddressDic valueForKeyPath:@"address1"] && [shippingAddressDic valueForKeyPath:@"address1"] != [NSNull null]) {
        order.shippingAddressLine1 = [shippingAddressDic valueForKeyPath:@"address1"];
    }
 
    if ([shippingAddressDic valueForKeyPath:@"address2"] && [shippingAddressDic valueForKeyPath:@"address2"] != [NSNull null]) {
        order.shippingAddressLine2 = [shippingAddressDic valueForKeyPath:@"address2"];
    }
 
    if ([shippingAddressDic valueForKeyPath:@"city"] && [shippingAddressDic valueForKeyPath:@"city"] != [NSNull null]) {
        order.shippingCity = [shippingAddressDic valueForKeyPath:@"city"];
    }
 
    if ([shippingAddressDic valueForKeyPath:@"country"] && [shippingAddressDic valueForKeyPath:@"country"] != [NSNull null]) {
        order.shippingCountry = [shippingAddressDic valueForKeyPath:@"country"];
    }
 
    if ([shippingAddressDic valueForKeyPath:@"name"] && [shippingAddressDic valueForKeyPath:@"name"] != [NSNull null]) {
        order.shippingRecipientName = [shippingAddressDic valueForKeyPath:@"name"];
    }
 
    if ([shippingAddressDic valueForKeyPath:@"phone"] && [shippingAddressDic valueForKeyPath:@"phone"] != [NSNull null]) {
        order.shippingPhoneNumber = [shippingAddressDic valueForKeyPath:@"phone"];
    }
 
    if ([shippingAddressDic valueForKeyPath:@"postal"] && [shippingAddressDic valueForKeyPath:@"postal"] != [NSNull null]) {
        order.shippingPostalCode = [shippingAddressDic valueForKeyPath:@"postal"];
    }
 
    if ([shippingAddressDic valueForKeyPath:@"state"] && [shippingAddressDic valueForKeyPath:@"state"] != [NSNull null]) {
        order.shippingProvince = [shippingAddressDic valueForKeyPath:@"state"];
    }
 
    
    
    /**
     
     Shipping Promo
     
     */
    
    NSDictionary *shippingPromo = orderInfoDic[@"shipping_promo_address"];
    
    
    if ([shippingPromo valueForKeyPath:@"isFreeshipAddress"] && [shippingPromo valueForKeyPath:@"isFreeshipAddress"] != [NSNull null]) {
        order.isFreeshipAddress = [shippingPromo valueForKeyPath:@"isFreeshipAddress"];
    }
    
    NSDictionary *shippingPromoBilling = shippingPromo[@"billing"];
    
    if ([shippingPromoBilling valueForKeyPath:@"address1"] && [shippingPromoBilling valueForKeyPath:@"address1"] != [NSNull null]) {
        order.promoBillingAddress1 = [shippingPromoBilling valueForKeyPath:@"address1"];
    }
    
    if ([shippingPromoBilling valueForKeyPath:@"address2"] && [shippingPromoBilling valueForKeyPath:@"address2"] != [NSNull null]) {
        order.promoBillingAddress2 = [shippingPromoBilling valueForKeyPath:@"address2"];
    }
    
    if ([shippingPromoBilling valueForKeyPath:@"city"] && [shippingPromoBilling valueForKeyPath:@"city"] != [NSNull null]) {
        order.promoBillingCity = [shippingPromoBilling valueForKeyPath:@"city"];
    }
    
    if ([shippingPromoBilling valueForKeyPath:@"country"] && [shippingPromoBilling valueForKeyPath:@"country"] != [NSNull null]) {
        order.promoBillingCountry = [shippingPromoBilling valueForKeyPath:@"country"];
    }
    
    if ([shippingAddressDic valueForKeyPath:@"name"] && [shippingAddressDic valueForKeyPath:@"name"] != [NSNull null]) {
        order.promoBillingName = [shippingAddressDic valueForKeyPath:@"name"];
    }
    
    if ([shippingAddressDic valueForKeyPath:@"phone"] && [shippingAddressDic valueForKeyPath:@"phone"] != [NSNull null]) {
        order.promoBillingPhone = [shippingAddressDic valueForKeyPath:@"phone"];
    }
    
    if ([shippingAddressDic valueForKeyPath:@"postal"] && [shippingAddressDic valueForKeyPath:@"postal"] != [NSNull null]) {
        order.promoBillingPostal = [shippingAddressDic valueForKeyPath:@"postal"];
    }
    
    if ([shippingAddressDic valueForKeyPath:@"state"] && [shippingAddressDic valueForKeyPath:@"state"] != [NSNull null]) {
        order.promoBillingState = [shippingAddressDic valueForKeyPath:@"state"];
    }
    
    
    
    NSDictionary *shippingPromoAddress = shippingPromo[@"shipping"];
    
    if ([shippingPromoAddress valueForKeyPath:@"address1"] && [shippingPromoAddress valueForKeyPath:@"address1"] != [NSNull null]) {
        order.promoShipAddress1 = [shippingPromoAddress valueForKeyPath:@"address1"];
    }
 
    if ([shippingPromoAddress valueForKeyPath:@"address2"] && [shippingPromoAddress valueForKeyPath:@"address2"] != [NSNull null]) {
        order.promoShipAddress2 = [shippingPromoAddress valueForKeyPath:@"address2"];
    }
    
    if ([shippingPromoAddress valueForKeyPath:@"city"] && [shippingPromoAddress valueForKeyPath:@"city"] != [NSNull null]) {
        order.promoShipCity = [shippingPromoAddress valueForKeyPath:@"city"];
    }
    
    if ([shippingPromoAddress valueForKeyPath:@"country"] && [shippingPromoAddress valueForKeyPath:@"country"] != [NSNull null]) {
        order.promoShipCountry = [shippingPromoAddress valueForKeyPath:@"country"];
    }
    
    if ([shippingPromoAddress valueForKeyPath:@"name"] && [shippingPromoAddress valueForKeyPath:@"name"] != [NSNull null]) {
        order.promoShipName = [shippingPromoAddress valueForKeyPath:@"name"];
    }
    
    if ([shippingPromoAddress valueForKeyPath:@"phone"] && [shippingPromoAddress valueForKeyPath:@"phone"] != [NSNull null]) {
        order.promoShipPhone = [shippingPromoAddress valueForKeyPath:@"phone"];
    }
    
    if ([shippingPromoAddress valueForKeyPath:@"postal"] && [shippingPromoAddress valueForKeyPath:@"postal"] != [NSNull null]) {
        order.promoShipPostal = [shippingPromoAddress valueForKeyPath:@"postal"];
    }
    
    if ([shippingPromoAddress valueForKeyPath:@"state"] && [shippingPromoAddress valueForKeyPath:@"state"] != [NSNull null]) {
        order.promoShipState = [shippingPromoAddress valueForKeyPath:@"state"];
    }

    
    /**
     
     Total Price
     
     */
    
    NSDictionary *totalPriceDictionary = shippingPromo[@"total"];
    
    if ([totalPriceDictionary valueForKeyPath:@"bag_total"] && [totalPriceDictionary valueForKeyPath:@"bag_total"] != [NSNull null]) {
        order.totalPrice = [totalPriceDictionary valueForKeyPath:@"bag_total"];
    }
    
    if ([totalPriceDictionary valueForKeyPath:@"sub_total"] && [totalPriceDictionary valueForKeyPath:@"sub_total"] != [NSNull null]) {
        order.subTotalPrice = [totalPriceDictionary valueForKeyPath:@"sub_total"];
    }
    
    return order;
}



@end


























