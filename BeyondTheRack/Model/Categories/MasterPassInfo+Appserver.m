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

    if ([masterPassDictionary valueForKeyPath:@"callbackUrl"] && [masterPassDictionary valueForKeyPath:@"callbackUrl"] != [NSNull null])
        masterPassInfo.callbackUrl = [masterPassDictionary valueForKey:@"callbackUrl"];
    
    if ([masterPassDictionary valueForKeyPath:@"cancelCallback"] && [masterPassDictionary valueForKeyPath:@"cancelCallback"] != [NSNull null])
        masterPassInfo.cancelCallback = [masterPassDictionary valueForKey:@"cancelCallback"];
    
    if ([masterPassDictionary valueForKeyPath:@"loyaltyEnabled"] && [masterPassDictionary valueForKeyPath:@"loyaltyEnabled"] != [NSNull null])
        masterPassInfo.loyaltyEnabled = [masterPassDictionary valueForKey:@"loyaltyEnabled"];
    
    if ([masterPassDictionary valueForKeyPath:@"merchantCheckoutId"] && [masterPassDictionary valueForKeyPath:@"merchantCheckoutId"] != [NSNull null])
        masterPassInfo.merchantCheckoutId = [masterPassDictionary valueForKey:@"merchantCheckoutId"];
    
    if ([masterPassDictionary valueForKeyPath:@"pairingRequestToken"] && [masterPassDictionary valueForKeyPath:@"pairingRequestToken"] != [NSNull null])
        masterPassInfo.allowedCardTypes = [masterPassDictionary valueForKey:@"pairingRequestToken"];
    
    if ([masterPassDictionary valueForKeyPath:@"requestBasicCheckout"] && [masterPassDictionary valueForKeyPath:@"requestBasicCheckout"] != [NSNull null])
        masterPassInfo.requestBasicCheckout = [masterPassDictionary valueForKey:@"requestBasicCheckout"];
    
    if ([masterPassDictionary valueForKeyPath:@"requestPairing"] && [masterPassDictionary valueForKeyPath:@"requestPairing"] != [NSNull null])
        masterPassInfo.requestPairing = [masterPassDictionary valueForKey:@"requestPairing"];
    
    if ([masterPassDictionary valueForKeyPath:@"requestToken"] && [masterPassDictionary valueForKeyPath:@"requestToken"] != [NSNull null])
        masterPassInfo.requestToken = [masterPassDictionary valueForKey:@"requestToken"];
    
    
    return masterPassInfo;
}
@end
