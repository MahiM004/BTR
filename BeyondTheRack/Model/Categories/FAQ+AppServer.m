//
//  FAQ+AppServer.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "FAQ+AppServer.h"

@implementation FAQ (AppServer)

+ (NSArray *)arrayOfFAQWithAppServerInfo:(NSDictionary *)FAQDictionary {
    NSMutableArray *allQestionsAndAnswers = [[NSMutableArray alloc]init];
    for (NSDictionary* item in FAQDictionary) {
        FAQ *newItem = [self extractFAQfromJSONDictionary:item];
        [allQestionsAndAnswers addObject:newItem];
    }
    return allQestionsAndAnswers;
}

+ (FAQ *)extractFAQfromJSONDictionary:(NSDictionary *)jsonDictionary
{
    FAQ* newFAQ = [[FAQ alloc]init];
    NSMutableArray* questionsAndAnswers = [[NSMutableArray alloc]init];
    newFAQ.faqCategory = [jsonDictionary valueForKey:@"title"];
    for (NSDictionary* item in [jsonDictionary valueForKey:@"content"]) {
        QA *newQA = [self extractQAfromJSONDictionary:item];
        [questionsAndAnswers addObject:newQA];
    }
    newFAQ.questionsAndAnswers = questionsAndAnswers;
    return newFAQ;
}


+ (QA *)extractQAfromJSONDictionary:(NSDictionary *)dictionary
{
    QA* newQA = [[QA alloc]init];
    newQA.question = [dictionary valueForKey:@"subheading"];
    newQA.answer = [dictionary valueForKey:@"text"];
    return newQA;
}
@end
