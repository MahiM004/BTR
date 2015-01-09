//
//  PaymentDetail+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "PaymentDetail.h"

@interface PaymentDetail (AppServer)

+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (PaymentDetail *)paymentDetailWithAppServerInfo:(NSDictionary *)paymentDetailDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadPaymentDetailsFromAppServerArray:(NSArray *)paymentDetails // of AppServer PaymentDetail NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
