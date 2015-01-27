//
//  PaymentDetail+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "PaymentDetail+AppServer.h"

@implementation PaymentDetail (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    PaymentDetail *paymentDetail = nil;
    
    paymentDetail = [NSEntityDescription insertNewObjectForEntityForName:@"PaymentDetail"
                                                    inManagedObjectContext:context];
    
    paymentDetail.cardholderName = @"dummy";
}


+ (PaymentDetail *)paymentDetailWithAppServerInfo:(NSDictionary *)paymentDetailDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    PaymentDetail *paymentDetail = nil;
    NSString *unique = paymentDetailDictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PaymentDetail"];
    request.predicate = [NSPredicate predicateWithFormat:@"paymentDetailId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        paymentDetail = [matches firstObject];
        
        if ([paymentDetailDictionary valueForKeyPath:@"id"])
            paymentDetail.paymentDetailId = [paymentDetailDictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        paymentDetail = [NSEntityDescription insertNewObjectForEntityForName:@"PaymentDetail"
                                                        inManagedObjectContext:context];
        
        if ([[paymentDetailDictionary valueForKeyPath:@"id"] stringValue])
            paymentDetail.paymentDetailId = [[paymentDetailDictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return paymentDetail;
}

+ (NSMutableArray *)loadPaymentDetailsFromAppServerArray:(NSArray *)paymentDetails // of AppServer PaymentDetail NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *paymentDetailArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *paymentDetail in paymentDetails) {
        
        NSObject *someObject = [self paymentDetailWithAppServerInfo:paymentDetail inManagedObjectContext:context];
        if (someObject)
            [paymentDetailArray addObject:someObject];
        
    }
    
    return paymentDetailArray;
}


@end
