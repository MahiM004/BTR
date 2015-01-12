//
//  BTRDocumentHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface BTRDocumentHandler : NSObject

@property (strong, nonatomic) UIManagedDocument *document;

+ (BTRDocumentHandler *)sharedDocumentHandler;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end