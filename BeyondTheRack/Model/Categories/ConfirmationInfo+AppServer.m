//
//  ConfirmationInfo+AppServer.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-10-08.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "ConfirmationInfo+AppServer.h"
#import "Item+AppServer.h"

@implementation ConfirmationInfo (AppServer)

+ (ConfirmationInfo *)extractConfirmationInfoFromConfirmationInfo:(NSDictionary *)info forConformationInfo:(ConfirmationInfo *)confirmation {
    
    if ([info valueForKeyPath:@"order_id"] && [info valueForKeyPath:@"order_id"] != [NSNull null])
        confirmation.orderID = [info valueForKey:@"order_id"];
    if ([info valueForKeyPath:@"email"] && [info valueForKeyPath:@"email"] != [NSNull null])
        confirmation.email = [info valueForKey:@"email"];
    if ([info valueForKeyPath:@"confirmation_number"] && [info valueForKeyPath:@"confirmation_number"] != [NSNull null])
        confirmation.confirmationNumber = [info valueForKey:@"confirmation_number"];
    if ([info valueForKeyPath:@"billing_card_type"] && [info valueForKeyPath:@"billing_card_type"] != [NSNull null])
        confirmation.billingCardType = [info valueForKey:@"billing_card_type"];
    if ([info valueForKeyPath:@"billing_card_lastdigits"] && [info valueForKeyPath:@"billing_card_lastdigits"] != [NSNull null])
        confirmation.billingCardLastdigits = [info valueForKey:@"billing_card_lastdigits"];
    if ([info valueForKeyPath:@"ordered_currency"] && [info valueForKeyPath:@"ordered_currency"] != [NSNull null])
        confirmation.orderCurrency = [info valueForKey:@"ordered_currency"];
    if ([info valueForKeyPath:@"total_order_value"] && [info valueForKeyPath:@"total_order_value"] != [NSNull null])
        confirmation.totalOrderValue = [info valueForKey:@"total_order_value"];
    if ([info valueForKeyPath:@"total_shipping"] && [info valueForKeyPath:@"total_shipping"] != [NSNull null])
        confirmation.totalShipping = [info valueForKey:@"total_shipping"];
    if ([info valueForKeyPath:@"total_tax1"] && [info valueForKeyPath:@"total_tax1"] != [NSNull null])
        confirmation.totalTax1 = [info valueForKey:@"total_tax1"];
    if ([info valueForKeyPath:@"total_tax2"] && [info valueForKeyPath:@"total_tax2"] != [NSNull null])
        confirmation.totalTax2 = [info valueForKey:@"total_tax2"];
    if ([info valueForKeyPath:@"total_discount"] && [info valueForKeyPath:@"total_discount"] != [NSNull null])
        confirmation.totalDiscount = [info valueForKey:@"total_discount"];
    if ([info valueForKeyPath:@"shipping_tax_group"] && [info valueForKeyPath:@"shipping_tax_group"] != [NSNull null])
        confirmation.shippingTaxGroup = [info valueForKey:@"shipping_tax_group"];
    if ([info valueForKeyPath:@"ordered_currency_rate"] && [info valueForKeyPath:@"ordered_currency_rate"] != [NSNull null])
        confirmation.orderedCurrencyRate = [info valueForKey:@"ordered_currency_rate"];
    if ([info valueForKeyPath:@"order_notes"] && [info valueForKeyPath:@"order_notes"] != [NSNull null])
        confirmation.orderNote = [info valueForKey:@"order_notes"];
    if ([info valueForKeyPath:@"total_credit_applied"] && [info valueForKeyPath:@"total_credit_applied"] != [NSNull null])
        confirmation.totalCreditApplied = [info valueForKey:@"total_credit_applied"];
    if ([info valueForKeyPath:@"order_subtotal"] && [info valueForKeyPath:@"order_subtotal"] != [NSNull null])
        confirmation.orderSubtotal = [info valueForKey:@"order_subtotal"];
    if ([info valueForKeyPath:@"bag_total"] && [info valueForKeyPath:@"bag_total"] != [NSNull null])
        confirmation.bagTotal = [info valueForKey:@"bag_total"];
    if ([info valueForKeyPath:@"label_tax1"] && [info valueForKeyPath:@"label_tax1"] != [NSNull null])
        confirmation.labelTax1 = [info valueForKey:@"label_tax1"];
    if ([info valueForKeyPath:@"label_tax2"] && [info valueForKeyPath:@"label_tax2"] != [NSNull null])
        confirmation.labelTax2 = [info valueForKey:@"label_tax2"];
    if ([info valueForKeyPath:@"payment_method"] && [info valueForKeyPath:@"payment_method"] != [NSNull null])
        confirmation.paymentMethod = [info valueForKey:@"payment_method"];
    
    confirmation.billingAddress = [[Address alloc]init];
    if ([info valueForKeyPath:@"billing_name"] && [info valueForKeyPath:@"billing_name"] != [NSNull null])
        confirmation.billingAddress.name = [info valueForKey:@"billing_name"];
    if ([info valueForKeyPath:@"billing_address1"] && [info valueForKeyPath:@"billing_address1"] != [NSNull null])
        confirmation.billingAddress.addressLine1 = [info valueForKey:@"billing_address1"];
    if ([info valueForKeyPath:@"billing_address2"] && [info valueForKeyPath:@"billing_address2"] != [NSNull null])
        confirmation.billingAddress.addressLine2 = [info valueForKey:@"billing_address2"];
    if ([info valueForKeyPath:@"billing_city"] && [info valueForKeyPath:@"billing_city"] != [NSNull null])
        confirmation.billingAddress.city = [info valueForKey:@"billing_city"];
    if ([info valueForKeyPath:@"billing_state"] && [info valueForKeyPath:@"billing_state"] != [NSNull null])
        confirmation.billingAddress.province = [info valueForKey:@"billing_state"];
    if ([info valueForKeyPath:@"billing_country"] && [info valueForKeyPath:@"billing_country"] != [NSNull null])
        confirmation.billingAddress.country = [info valueForKey:@"billing_country"];
    if ([info valueForKeyPath:@"billing_postal"] && [info valueForKeyPath:@"billing_postal"] != [NSNull null])
        confirmation.billingAddress.addressLine1 = [info valueForKey:@"billing_postal"];
    if ([info valueForKeyPath:@"billing_phone"] && [info valueForKeyPath:@"billing_phone"] != [NSNull null])
        confirmation.billingAddress.phoneNumber = [info valueForKey:@"billing_phone"];
    
    confirmation.shippingAddress = [[Address alloc]init];
    if ([info valueForKeyPath:@"shipping_name"] && [info valueForKeyPath:@"shipping_name"] != [NSNull null])
        confirmation.shippingAddress.name = [info valueForKey:@"shipping_name"];
    if ([info valueForKeyPath:@"shipping_address1"] && [info valueForKeyPath:@"shipping_address1"] != [NSNull null])
        confirmation.shippingAddress.addressLine1 = [info valueForKey:@"shipping_address1"];
    if ([info valueForKeyPath:@"shipping_address2"] && [info valueForKeyPath:@"shipping_address2"] != [NSNull null])
        confirmation.shippingAddress.addressLine2 = [info valueForKey:@"shipping_address2"];
    if ([info valueForKeyPath:@"shipping_city"] && [info valueForKeyPath:@"shipping_city"] != [NSNull null])
        confirmation.shippingAddress.city = [info valueForKey:@"shipping_city"];
    if ([info valueForKeyPath:@"shipping_state"] && [info valueForKeyPath:@"shipping_state"] != [NSNull null])
        confirmation.shippingAddress.province = [info valueForKey:@"shipping_state"];
    if ([info valueForKeyPath:@"shipping_country"] && [info valueForKeyPath:@"shipping_country"] != [NSNull null])
        confirmation.shippingAddress.country = [info valueForKey:@"shipping_country"];
    if ([info valueForKeyPath:@"shipping_postal"] && [info valueForKeyPath:@"shipping_postal"] != [NSNull null])
        confirmation.shippingAddress.postalCode = [info valueForKey:@"shipping_postal"];
    if ([info valueForKeyPath:@"shipping_phone"] && [info valueForKeyPath:@"shipping_phone"] != [NSNull null])
        confirmation.shippingAddress.phoneNumber = [info valueForKey:@"shipping_phone"];
    
    if ([info valueForKeyPath:@"items"] && [info valueForKeyPath:@"items"] != [NSNull null]) {
        NSMutableArray* items = [[NSMutableArray alloc]init];
        for (NSDictionary *itemDic in [info valueForKeyPath:@"items"]) {
            Item* newItem = [[Item alloc]init];
            [Item extractItemfromJsonDictionary:itemDic forItem:newItem];
            [items addObject:newItem];
        }
        confirmation.items = [items mutableCopy];
    }
    return confirmation;
}

@end
