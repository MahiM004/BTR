//
//  MasterPassInfo+Appserver.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "MasterPassInfo+Appserver.h"

@implementation MasterPassInfo (AppServer)

+ (MasterPassInfo *)masterPassInfoWithAppServerInfo:(NSDictionary *)masterPassDictionary {
    
    MasterPassInfo *masterPassInfo = [[MasterPassInfo alloc] init];
    
    masterPassInfo = [self extractMasterPassInfofromJSONDictionary:masterPassDictionary forMasterPass:masterPassInfo];
    
    return masterPassInfo;
}

+ (MasterPassInfo *)extractMasterPassInfofromJSONDictionary:(NSDictionary *)dictionary forMasterPass:(MasterPassInfo *)masterPassInfo {

    NSDictionary* masterPassDictionary = [dictionary valueForKey:@"masterpassInfo"];
    
    if ([masterPassDictionary valueForKeyPath:@"allowedCardTypes"] && [masterPassDictionary valueForKeyPath:@"allowedCardTypes"] != [NSNull null])
        masterPassInfo.allowedCardTypes = [[masterPassDictionary valueForKey:@"allowedCardTypes"] componentsSeparatedByString:@","];
    if ([masterPassDictionary valueForKeyPath:@"requestedDataTypes"] && [masterPassDictionary valueForKeyPath:@"requestedDataTypes"] != [NSNull null])
        masterPassInfo.requestDataType = [masterPassDictionary valueForKey:@"requestedDataTypes"];
    if ([masterPassDictionary valueForKeyPath:@"callbackUrl"] && [masterPassDictionary valueForKeyPath:@"callbackUrl"] != [NSNull null])
        masterPassInfo.callbackUrl = [masterPassDictionary valueForKey:@"callbackUrl"];
    if ([masterPassDictionary valueForKeyPath:@"cancelCallback"] && [masterPassDictionary valueForKeyPath:@"cancelCallback"] != [NSNull null])
        masterPassInfo.cancelCallback = [masterPassDictionary valueForKey:@"cancelCallback"];
    if ([masterPassDictionary valueForKeyPath:@"loyaltyEnabled"] && [masterPassDictionary valueForKeyPath:@"loyaltyEnabled"] != [NSNull null])
        masterPassInfo.loyaltyEnabled = [masterPassDictionary valueForKey:@"loyaltyEnabled"];
    if ([masterPassDictionary valueForKeyPath:@"mode"] && [masterPassDictionary valueForKeyPath:@"mode"] != [NSNull null])
        masterPassInfo.mode = [masterPassDictionary valueForKey:@"mode"];
    if ([masterPassDictionary valueForKeyPath:@"merchantCheckoutId"] && [masterPassDictionary valueForKeyPath:@"merchantCheckoutId"] != [NSNull null])
        masterPassInfo.merchantCheckoutId = [masterPassDictionary valueForKey:@"merchantCheckoutId"];
    if ([masterPassDictionary valueForKeyPath:@"pairingRequestToken"] && [masterPassDictionary valueForKeyPath:@"pairingRequestToken"] != [NSNull null])
        masterPassInfo.pairingRequestToken = [masterPassDictionary valueForKey:@"pairingRequestToken"];
    if ([masterPassDictionary valueForKeyPath:@"requestBasicCheckout"] && [masterPassDictionary valueForKeyPath:@"requestBasicCheckout"] != [NSNull null])
        masterPassInfo.requestBasicCheckout = [masterPassDictionary valueForKey:@"requestBasicCheckout"];
    if ([masterPassDictionary valueForKeyPath:@"requestPairing"] && [masterPassDictionary valueForKeyPath:@"requestPairing"] != [NSNull null])
        masterPassInfo.requestPairing = [masterPassDictionary valueForKey:@"requestPairing"];
    if ([masterPassDictionary valueForKeyPath:@"requestToken"] && [masterPassDictionary valueForKeyPath:@"requestToken"] != [NSNull null])
        masterPassInfo.requestToken = [masterPassDictionary valueForKey:@"requestToken"];
    if ([masterPassDictionary valueForKeyPath:@"shippingLocationProfile"] && [masterPassDictionary valueForKeyPath:@"shippingLocationProfile"] != [NSNull null])
        masterPassInfo.shippingLocationProfile = [masterPassDictionary valueForKey:@"shippingLocationProfile"];
    if ([masterPassDictionary valueForKeyPath:@"suppressShippingAddressEnable"] && [masterPassDictionary valueForKeyPath:@"suppressShippingAddressEnable"] != [NSNull null])
        masterPassInfo.suppressShippingAddressEnable = [masterPassDictionary valueForKey:@"suppressShippingAddressEnable"];
    if ([masterPassDictionary valueForKeyPath:@"version"] && [masterPassDictionary valueForKeyPath:@"version"] != [NSNull null])
        masterPassInfo.version = [masterPassDictionary valueForKey:@"version"];
    
    
    return masterPassInfo;
}
@end
