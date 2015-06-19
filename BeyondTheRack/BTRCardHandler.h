//
//  BTRCardHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRCardHandler : NSObject

+ (BTRCardHandler *)sharedCardData;

@property (strong, nonatomic) NSMutableArray *cardDisplayNameArray;
@property (strong, nonatomic) NSMutableArray *cardTypeArray;

@end
