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

@property (strong, nonatomic) NSMutableArray *paymentTypesArray;
@property (strong, nonatomic) NSMutableArray *creditCardTypeArray;
@property (strong, nonatomic) NSMutableArray *creditCardDisplayNameArray;

- (void)clearData;

@end
