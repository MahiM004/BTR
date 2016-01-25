//
//  Order+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Order+AppServer.h"
#import "Item+AppServer.h"

@implementation Order (AppServer)


+ (Order *)orderWithAppServerInfo:(NSDictionary *)orderDictionary {
    Order *order = [[Order alloc] init];
    order = [self extractOrderfromJSONDictionary:orderDictionary forOrder:order isValidating:NO];
    return order;
}


+ (Order *)extractOrderfromJSONDictionary:(NSDictionary *)orderDictionary forOrder:(Order *)order isValidating:(BOOL)isValidating{

    NSDictionary *successfulorder = orderDictionary[@"order"];
    
    // order info
    if ([successfulorder valueForKeyPath:@"order_id"] && [successfulorder valueForKeyPath:@"order_id"] != [NSNull null])
        order.orderId = [successfulorder valueForKeyPath:@"order_id"];
    
    if (!isValidating) {
        
        // payment method
        order.paymentType = [orderDictionary valueForKey:@"paymentMethod"];
        
        // card info
        NSDictionary *cardInfoDic = orderDictionary[@"cardInfo"];
        if ([cardInfoDic valueForKeyPath:@"cvv"] && [cardInfoDic valueForKeyPath:@"cvv"] != [NSNull null])
            order.ccvNumber = [cardInfoDic valueForKeyPath:@"cvv"];
        if ([cardInfoDic valueForKeyPath:@"force_card_update"] && [cardInfoDic valueForKeyPath:@"force_card_update"] != [NSNull null])
            order.forceCardUpdate = [cardInfoDic valueForKeyPath:@"force_card_update"];
        if ([cardInfoDic valueForKeyPath:@"lockCCFields"] && [cardInfoDic valueForKeyPath:@"lockCCFields"] != [NSNull null])
            order.lockCCFields = [[cardInfoDic valueForKeyPath:@"lockCCFields"] stringValue];
        if ([cardInfoDic valueForKeyPath:@"month"] && [cardInfoDic valueForKeyPath:@"month"] != [NSNull null])
            order.expiryMonth = [cardInfoDic valueForKeyPath:@"month"];
        if ([cardInfoDic valueForKeyPath:@"name"] && [cardInfoDic valueForKeyPath:@"name"] != [NSNull null])
            order.cardHolderName = [cardInfoDic valueForKeyPath:@"name"];
        if ([cardInfoDic valueForKeyPath:@"number"] && [cardInfoDic valueForKeyPath:@"number"] != [NSNull null])
            order.cardNumber = [cardInfoDic valueForKeyPath:@"number"];
        if ([cardInfoDic valueForKeyPath:@"payment_type"] && [cardInfoDic valueForKeyPath:@"payment_type"] != [NSNull null])
            order.paymentType = [cardInfoDic valueForKeyPath:@"payment_type"];
        if ([cardInfoDic valueForKeyPath:@"remember_card"] && [cardInfoDic valueForKeyPath:@"remember_card"] != [NSNull null])
            order.rememberCard = [[cardInfoDic valueForKeyPath:@"remember_card"] stringValue];
        if ([cardInfoDic valueForKeyPath:@"require_ccv"] && [cardInfoDic valueForKeyPath:@"require_ccv"] != [NSNull null])
            order.requireCcv = [[cardInfoDic valueForKeyPath:@"require_ccv"] stringValue];
        if ([cardInfoDic valueForKeyPath:@"token"] && [cardInfoDic valueForKeyPath:@"token"] != [NSNull null])
            order.cardToken = [cardInfoDic valueForKeyPath:@"token"];
        if ([cardInfoDic valueForKeyPath:@"type"] && [cardInfoDic valueForKeyPath:@"type"] != [NSNull null])
            order.cardType = [cardInfoDic valueForKeyPath:@"type"];
        if ([cardInfoDic valueForKeyPath:@"use_token"] && [cardInfoDic valueForKeyPath:@"use_token"] != [NSNull null])
            order.useToken = [[cardInfoDic valueForKeyPath:@"use_token"] stringValue];
        if ([cardInfoDic valueForKeyPath:@"year"] && [cardInfoDic valueForKeyPath:@"year"] != [NSNull null])
            order.expiryYear = [cardInfoDic valueForKeyPath:@"year"];
    }
    
    // order Info
    
    NSDictionary *orderInfoDic = orderDictionary[@"orderInfo"];
    
    if ([orderInfoDic valueForKeyPath:@"billto_shipto"] && [orderInfoDic valueForKeyPath:@"billto_shipto"] != [NSNull null])
        order.billingSameAsShipping = [[orderInfoDic valueForKeyPath:@"billto_shipto"] stringValue];
    if ([orderInfoDic valueForKeyPath:@"eligible_pickup"] && [orderInfoDic valueForKeyPath:@"eligible_pickup"] != [NSNull null])
        order.eligiblePickup = [[orderInfoDic valueForKeyPath:@"eligible_pickup"] stringValue];
    if ([orderInfoDic valueForKeyPath:@"is_gift"] && [orderInfoDic valueForKeyPath:@"is_gift"] != [NSNull null])
        order.isGift = [orderInfoDic valueForKeyPath:@"is_gift"];
    if ([orderInfoDic valueForKeyPath:@"is_pickup"] && [orderInfoDic valueForKeyPath:@"is_pickup"] != [NSNull null])
        order.isPickup = [[orderInfoDic valueForKeyPath:@"is_pickup"] stringValue];
    if ([orderInfoDic valueForKeyPath:@"recipient_message"] && [orderInfoDic valueForKeyPath:@"recipient_massage"] != [NSNull null])
        order.recipientGiftMessage = [orderInfoDic valueForKeyPath:@"recipient_massage"];
    if ([orderInfoDic valueForKeyPath:@"vip_pickup"] && [orderInfoDic valueForKeyPath:@"vip_pickup"] != [NSNull null])
        order.vipPickup = [[orderInfoDic valueForKeyPath:@"vip_pickup"] stringValue];
    if ([orderInfoDic valueForKeyPath:@"vip_pickup_eligible"] && [orderInfoDic valueForKeyPath:@"vip_pickup_eligible"] != [NSNull null])
        order.vipPickupEligible = [[orderInfoDic valueForKeyPath:@"vip_pickup_eligible"] stringValue];
    
    /**
     
     Items in Order
     
     */
    
    NSArray *ArrayOfItems = orderDictionary[@"products"];
    NSMutableArray* tempProductArray = [[NSMutableArray alloc]init];
    for (NSDictionary* itemDic in ArrayOfItems) {
        Item *newItem = [[Item alloc]init];
        [tempProductArray addObject:[Item extractItemfromJsonDictionary:itemDic forItem:newItem]];
    }
    order.items = tempProductArray;
    
    
    /**
     
     Billing Address
     
     */
    
    NSDictionary *billingAddressDic = orderInfoDic[@"billing"];
    if (!order.billingAddress)
        order.billingAddress = [[Address alloc]init];
    
    if ([billingAddressDic valueForKeyPath:@"address1"] && [billingAddressDic valueForKeyPath:@"address1"] != [NSNull null])
        order.billingAddress.addressLine1 = [billingAddressDic valueForKeyPath:@"address1"];
    if ([billingAddressDic valueForKeyPath:@"address2"] && [billingAddressDic valueForKeyPath:@"address2"] != [NSNull null])
        order.billingAddress.addressLine2 = [billingAddressDic valueForKeyPath:@"address2"];
    if ([billingAddressDic valueForKeyPath:@"city"] && [billingAddressDic valueForKeyPath:@"city"] != [NSNull null])
        order.billingAddress.city = [billingAddressDic valueForKeyPath:@"city"];
    if ([billingAddressDic valueForKeyPath:@"country"] && [billingAddressDic valueForKeyPath:@"country"] != [NSNull null]) {
        order.billingAddress.country = [billingAddressDic valueForKeyPath:@"country"];
        order.country = [[billingAddressDic valueForKeyPath:@"country"]uppercaseString];
    }
    if ([billingAddressDic valueForKeyPath:@"phone"] && [billingAddressDic valueForKeyPath:@"phone"] != [NSNull null])
        order.billingAddress.phoneNumber = [billingAddressDic valueForKeyPath:@"phone"];
    if ([billingAddressDic valueForKeyPath:@"postal"] && [billingAddressDic valueForKeyPath:@"postal"] != [NSNull null])
        order.billingAddress.postalCode = [billingAddressDic valueForKeyPath:@"postal"];
    if ([billingAddressDic valueForKeyPath:@"state"] && [billingAddressDic valueForKeyPath:@"state"] != [NSNull null])
        order.billingAddress.province = [billingAddressDic valueForKeyPath:@"state"];
    if ([billingAddressDic valueForKeyPath:@"name"] && [billingAddressDic valueForKeyPath:@"name"] != [NSNull null])
        order.billingAddress.name = [billingAddressDic valueForKeyPath:@"name"];
    
    /**
     
     Shipping Address
     
     */
    
    NSDictionary *shippingAddressDic = orderInfoDic[@"shipping"];
    if (!order.shippingAddress)
        order.shippingAddress = [[Address alloc]init];
    
    if ([shippingAddressDic valueForKeyPath:@"address1"] && [shippingAddressDic valueForKeyPath:@"address1"] != [NSNull null])
        order.shippingAddress.addressLine1 = [shippingAddressDic valueForKeyPath:@"address1"];
    if ([shippingAddressDic valueForKeyPath:@"address2"] && [shippingAddressDic valueForKeyPath:@"address2"] != [NSNull null])
        order.shippingAddress.addressLine2 = [shippingAddressDic valueForKeyPath:@"address2"];
    if ([shippingAddressDic valueForKeyPath:@"city"] && [shippingAddressDic valueForKeyPath:@"city"] != [NSNull null])
        order.shippingAddress.city = [shippingAddressDic valueForKeyPath:@"city"];
    if ([shippingAddressDic valueForKeyPath:@"country"] && [shippingAddressDic valueForKeyPath:@"country"] != [NSNull null])
        order.shippingAddress.country = [shippingAddressDic valueForKeyPath:@"country"];
    if ([shippingAddressDic valueForKeyPath:@"phone"] && [shippingAddressDic valueForKeyPath:@"phone"] != [NSNull null])
        order.shippingAddress.phoneNumber = [shippingAddressDic valueForKeyPath:@"phone"];
    if ([shippingAddressDic valueForKeyPath:@"postal"] && [shippingAddressDic valueForKeyPath:@"postal"] != [NSNull null])
        order.shippingAddress.postalCode = [shippingAddressDic valueForKeyPath:@"postal"];
    if ([shippingAddressDic valueForKeyPath:@"state"] && [shippingAddressDic valueForKeyPath:@"state"] != [NSNull null]) 
        order.shippingAddress.province = [shippingAddressDic valueForKeyPath:@"state"];
    if ([shippingAddressDic valueForKeyPath:@"name"] && [shippingAddressDic valueForKeyPath:@"name"] != [NSNull null])
        order.shippingAddress.name = [shippingAddressDic valueForKeyPath:@"name"];
    
    /**
     
     Shipping Promo
     
     */

    
    NSDictionary *shippingPromo = orderInfoDic[@"shipping_promo_address"];
    if (!order.promoBillingAddress)
        order.promoBillingAddress = [[Address alloc]init];
    
    NSDictionary *shippingPromoBilling = shippingPromo[@"billing"];
    
    if ([shippingPromoBilling valueForKeyPath:@"address1"] && [shippingPromoBilling valueForKeyPath:@"address1"] != [NSNull null])
        order.promoBillingAddress.addressLine1 = [shippingPromoBilling valueForKeyPath:@"address1"];
    if ([shippingPromoBilling valueForKeyPath:@"address2"] && [shippingPromoBilling valueForKeyPath:@"address2"] != [NSNull null])
        order.promoBillingAddress.addressLine2 = [shippingPromoBilling valueForKeyPath:@"address2"];
    if ([shippingPromoBilling valueForKeyPath:@"city"] && [shippingPromoBilling valueForKeyPath:@"city"] != [NSNull null])
        order.promoBillingAddress.city = [shippingPromoBilling valueForKeyPath:@"city"];
    if ([shippingPromoBilling valueForKeyPath:@"country"] && [shippingPromoBilling valueForKeyPath:@"country"] != [NSNull null])
        order.promoBillingAddress.country = [shippingPromoBilling valueForKeyPath:@"country"];
    if ([shippingAddressDic valueForKeyPath:@"phone"] && [shippingAddressDic valueForKeyPath:@"phone"] != [NSNull null])
        order.promoBillingAddress.phoneNumber = [shippingAddressDic valueForKeyPath:@"phone"];
    if ([shippingAddressDic valueForKeyPath:@"postal"] && [shippingAddressDic valueForKeyPath:@"postal"] != [NSNull null])
        order.promoBillingAddress.postalCode = [shippingAddressDic valueForKeyPath:@"postal"];
    if ([shippingAddressDic valueForKeyPath:@"state"] && [shippingAddressDic valueForKeyPath:@"state"] != [NSNull null])
        order.promoBillingAddress.province = [shippingAddressDic valueForKeyPath:@"state"];
    if ([shippingAddressDic valueForKeyPath:@"name"] && [shippingAddressDic valueForKeyPath:@"name"] != [NSNull null])
        order.promoBillingAddress.name = [shippingAddressDic valueForKeyPath:@"name"];
    
    if ([shippingPromo valueForKeyPath:@"isFreeshipAddress"] && [shippingPromo valueForKeyPath:@"isFreeshipAddress"] != [NSNull null])
        order.isFreeshipAddress = [[shippingPromo valueForKeyPath:@"isFreeshipAddress"] stringValue];
    
    
    NSDictionary *shippingPromoAddress = shippingPromo[@"shipping"];
    if (!order.promoShippingAddress)
        order.promoShippingAddress = [[Address alloc]init];
    
    if ([shippingPromoAddress valueForKeyPath:@"address1"] && [shippingPromoAddress valueForKeyPath:@"address1"] != [NSNull null])
        order.promoShippingAddress.addressLine1 = [shippingPromoAddress valueForKeyPath:@"address1"];
    if ([shippingPromoAddress valueForKeyPath:@"address2"] && [shippingPromoAddress valueForKeyPath:@"address2"] != [NSNull null])
        order.promoShippingAddress.addressLine2 = [shippingPromoAddress valueForKeyPath:@"address2"];
    if ([shippingPromoAddress valueForKeyPath:@"city"] && [shippingPromoAddress valueForKeyPath:@"city"] != [NSNull null])
        order.promoShippingAddress.city = [shippingPromoAddress valueForKeyPath:@"city"];
    if ([shippingPromoAddress valueForKeyPath:@"country"] && [shippingPromoAddress valueForKeyPath:@"country"] != [NSNull null])
        order.promoShippingAddress.country = [shippingPromoAddress valueForKeyPath:@"country"];
    if ([shippingPromoAddress valueForKeyPath:@"phone"] && [shippingPromoAddress valueForKeyPath:@"phone"] != [NSNull null])
        order.promoShippingAddress.phoneNumber = [shippingPromoAddress valueForKeyPath:@"phone"];
    if ([shippingPromoAddress valueForKeyPath:@"postal"] && [shippingPromoAddress valueForKeyPath:@"postal"] != [NSNull null])
        order.promoShippingAddress.postalCode = [shippingPromoAddress valueForKeyPath:@"postal"];
    if ([shippingPromoAddress valueForKeyPath:@"state"] && [shippingPromoAddress valueForKeyPath:@"state"] != [NSNull null])
        order.promoShippingAddress.province = [shippingPromoAddress valueForKeyPath:@"state"];
    if ([shippingPromoAddress valueForKeyPath:@"name"] && [shippingPromoAddress valueForKeyPath:@"name"] != [NSNull null])
        order.promoShippingAddress.name = [shippingPromoAddress valueForKeyPath:@"name"];
    
    /**
     
     Pickup Address
     
     */
    
    NSDictionary *pickUpaddress = orderInfoDic[@"pickup"];
    if (!order.pickupAddress)
        order.pickupAddress = [[Address alloc]init];
    
    if ([pickUpaddress valueForKeyPath:@"address1"] && [pickUpaddress valueForKeyPath:@"address1"] != [NSNull null])
        order.pickupAddress.addressLine1 = [pickUpaddress valueForKeyPath:@"address1"];
    if ([pickUpaddress valueForKeyPath:@"address2"] && [pickUpaddress valueForKeyPath:@"address2"] != [NSNull null])
        order.pickupAddress.addressLine2 = [pickUpaddress valueForKeyPath:@"address2"];
    if ([pickUpaddress valueForKeyPath:@"city"] && [pickUpaddress valueForKeyPath:@"city"] != [NSNull null])
        order.pickupAddress.city = [pickUpaddress valueForKeyPath:@"city"];
    if ([pickUpaddress valueForKeyPath:@"country"] && [pickUpaddress valueForKeyPath:@"country"] != [NSNull null])
        order.pickupAddress.country = [pickUpaddress valueForKeyPath:@"country"];
    if ([pickUpaddress valueForKeyPath:@"postal"] && [pickUpaddress valueForKeyPath:@"postal"] != [NSNull null])
        order.pickupAddress.postalCode = [pickUpaddress valueForKeyPath:@"postal"];
    if ([pickUpaddress valueForKeyPath:@"state"] && [pickUpaddress valueForKeyPath:@"state"] != [NSNull null])
        order.pickupAddress.province = [pickUpaddress valueForKeyPath:@"state"];
    if ([pickUpaddress valueForKeyPath:@"state"] && [pickUpaddress valueForKeyPath:@"state"] != [NSNull null])
        order.pickupAddress.province = [pickUpaddress valueForKeyPath:@"state"];
    if ([pickUpaddress valueForKeyPath:@"title"] && [pickUpaddress valueForKeyPath:@"title"] != [NSNull null])
        order.pickupTitle = [pickUpaddress valueForKeyPath:@"title"];
    
    /**
     
     Saving
     
     */
    
    if ([orderDictionary valueForKeyPath:@"savings"] && [orderDictionary valueForKeyPath:@"savings"] != [NSNull null])
        order.saving = [orderDictionary valueForKeyPath:@"savings"];
    
    /**
     
     Promo Items
     
     */
    
    NSArray * promoArray = [orderDictionary valueForKey:@"promo_item"];
    if (promoArray.count > 0) {
        NSMutableArray* items = [[NSMutableArray alloc]init];
        for (NSDictionary* promoDictionary in promoArray) {
            PromoItem* newItem = [[PromoItem alloc]init];
            if ([promoDictionary valueForKeyPath:@"opt_in_default"] && [promoDictionary valueForKeyPath:@"opt_in_default"] != [NSNull null])
                newItem.selectedByDefault = [promoDictionary valueForKey:@"opt_in_default"];
            if ([promoDictionary valueForKeyPath:@"country_ship_to_eligible"] && [promoDictionary valueForKeyPath:@"country_ship_to_eligible"] != [NSNull null])
                newItem.eligibleCountry = [promoDictionary valueForKey:@"country_ship_to_eligible"];
            if ([promoDictionary valueForKeyPath:@"opt_in_text"] && [promoDictionary valueForKeyPath:@"opt_in_text"] != [NSNull null])
                newItem.text = [promoDictionary valueForKey:@"opt_in_text"];
            if ([promoDictionary valueForKeyPath:@"image"] && [promoDictionary valueForKeyPath:@"image"] != [NSNull null])
                newItem.image = [promoDictionary valueForKey:@"image"];
            if ([promoDictionary valueForKeyPath:@"sku"] && [promoDictionary valueForKeyPath:@"sku"] != [NSNull null])
                newItem.sku = [promoDictionary valueForKeyPath:@"sku"];
            if ([promoDictionary valueForKeyPath:@"promo_item_id"] && [promoDictionary valueForKeyPath:@"promo_item_id"] != [NSNull null])
                newItem.promoItemID = [promoDictionary valueForKeyPath:@"promo_item_id"];
            if ([promoDictionary valueForKeyPath:@"promo_id"] && [promoDictionary valueForKeyPath:@"promo_id"] != [NSNull null])
                newItem.promoID = [promoDictionary valueForKeyPath:@"promo_id"];
            [items addObject:newItem];
        }
        order.promoItems = items;
    }

    /**
     
     Paypal
     
     */
    
    NSDictionary *paypalDic = orderDictionary[@"paypalInfo"];
    if (paypalDic)
        order.paypalInfo = paypalDic;
    
    /**
     
     Total Price
     
     */
    
    NSDictionary *totalPriceDictionary = orderDictionary[@"total"];
    
    if ([totalPriceDictionary valueForKeyPath:@"bag_total"] && [totalPriceDictionary valueForKeyPath:@"bag_total"] != [NSNull null])
        order.bagTotalPrice = [NSString stringWithFormat:@"%.2f",[[totalPriceDictionary valueForKeyPath:@"bag_total"]floatValue]];
    if ([totalPriceDictionary valueForKeyPath:@"sub_total"] && [totalPriceDictionary valueForKeyPath:@"sub_total"] != [NSNull null])
        order.subTotalPrice = [NSString stringWithFormat:@"%.2f",[[totalPriceDictionary valueForKeyPath:@"sub_total"]floatValue]];
    if ([totalPriceDictionary valueForKeyPath:@"order_total"] && [totalPriceDictionary valueForKeyPath:@"order_total"] != [NSNull null])
        order.orderTotalPrice = [NSString stringWithFormat:@"%.2f",[[totalPriceDictionary valueForKeyPath:@"order_total"]floatValue]];
    if ([totalPriceDictionary valueForKeyPath:@"all_total"] && [totalPriceDictionary valueForKeyPath:@"all_total"] != [NSNull null])
        order.allTotalPrice = [NSString stringWithFormat:@"%.2f",[[totalPriceDictionary valueForKeyPath:@"all_total"]floatValue]];
    if ([totalPriceDictionary valueForKeyPath:@"ship_total"] && [totalPriceDictionary valueForKeyPath:@"ship_total"] != [NSNull null])
        order.shippingPrice = [NSString stringWithFormat:@"%.2f",[[totalPriceDictionary valueForKeyPath:@"ship_total"]floatValue]];
    if ([totalPriceDictionary valueForKeyPath:@"currency"] && [totalPriceDictionary valueForKeyPath:@"currency"] != [NSNull null])
        order.currency = [totalPriceDictionary valueForKeyPath:@"currency"];
    
    
    // credits
    NSDictionary *credits = [totalPriceDictionary valueForKey:@"credit_buckets"];
    if ([credits valueForKeyPath:@"post"] && [credits valueForKeyPath:@"post"] != [NSNull null])
        order.accountCredit = [credits valueForKeyPath:@"post"];
    if ([credits valueForKeyPath:@"pre"] && [credits valueForKeyPath:@"pre"] != [NSNull null])
        order.promoCredit = [credits valueForKeyPath:@"pre"];
    
    
    NSDictionary* payment = [orderDictionary valueForKey:@"payment"];
    if (payment) {
        if ([payment valueForKeyPath:@"success"] && [payment valueForKeyPath:@"success"] != [NSNull null]) {
            order.isAccepted = [[orderDictionary valueForKeyPath:@"success"]boolValue];
        }
    }
    
    /**
     
    TAX
     
     */
    
    NSDictionary *taxes = totalPriceDictionary[@"taxes"];
    order.taxes = [taxes valueForKey:@"receipt_lines"];
    
    /**
     
     VANITY
     
     */
    
    NSArray *vanityCodes = orderDictionary[@"vanity_codes"];
    if ([vanityCodes count] > 0)
        order.vanityCodes = [vanityCodes valueForKey:@"codes"];
    
    return order;
}


@end


























