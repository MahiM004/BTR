//
//  BTRPaymentTypesHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRPaymentTypesHandler : NSObject

+ (BTRPaymentTypesHandler *)sharedPaymentTypes;

@property (strong, nonatomic) NSMutableArray *paymentTypesArray;             /*    as recieved from backend   */
@property (strong, nonatomic) NSMutableArray *creditCardTypeArray;           /*      card codes               */
@property (strong, nonatomic) NSMutableArray *creditCardDisplayNameArray;    /*      card display names       */

- (void)clearData;

- (NSString *)paymentTypeforCardDisplayName:(NSString *)displayName;
- (NSString *)cardDisplayNameforPaymentType:(NSString *)paymentType;

- (NSString *)cardTypeForDispalyName:(NSString *)displayName;
- (NSString *)cardDisplayNameForType:(NSString *)cardType;

@end
