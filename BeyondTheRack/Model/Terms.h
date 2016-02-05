//
//  Terms.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-04.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {USA,Canada} Country;

@interface Terms : NSObject


@property (nonatomic, strong) NSDictionary *response;

- (id)initWithResponse:(NSDictionary *)response;
- (NSString *)makeHTMLStringForCountry:(Country)selectedCountry;

@end
