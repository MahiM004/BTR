//
//  FAQ.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QA : NSObject
@property (nonatomic, retain) NSString* question;
@property (nonatomic, retain) NSArray* answer;
@end


@interface FAQ : NSObject
@property (nonatomic, retain) NSString* faqCategory;
@property (nonatomic, retain) NSArray* questionsAndAnswers;
@end
