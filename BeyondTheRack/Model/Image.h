//
//  Image.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-04.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imageUrlId;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * imageSize;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * ratio;
@property (nonatomic, retain) NSString * imageNumber;
@property (nonatomic, retain) NSString * imageId;

@end
