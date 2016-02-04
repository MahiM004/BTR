//
//  Terms.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-04.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "Terms.h"

@implementation Terms

- (id)initWithResponse:(NSDictionary *)response {
    self = [super init];
    if (self)
        self.response = response;
    return self;
}

- (NSString *)makeHTMLStringForCountry:(Country)selectedCountry {
    NSArray *countryTerm;
    if (selectedCountry == USA)
        countryTerm = [self.response valueForKey:@"ca"];
    else
        countryTerm = [self.response valueForKey:@"us"];
    NSString *htmlString = @"<HTML>";
    for (NSDictionary *mainObject in countryTerm) {
        htmlString = [htmlString stringByAppendingString:@"</BR>"];
        htmlString = [htmlString stringByAppendingString:@"<h1>"];
        htmlString = [htmlString stringByAppendingString:[mainObject valueForKey:@"title"]];
        htmlString = [htmlString stringByAppendingString:@"</h1>"];
        htmlString = [htmlString stringByAppendingString:@"</BR>"];
        for (NSDictionary *subObject in [mainObject valueForKey:@"content"]) {
            htmlString = [htmlString stringByAppendingString:@"</BR>"];
            htmlString = [htmlString stringByAppendingString:@"<h3>"];
            htmlString = [htmlString stringByAppendingString:[subObject valueForKey:@"subheading"]];
            htmlString = [htmlString stringByAppendingString:@"</h3>"];
            NSString *text = @"";
            for (int i = 0; i < [[subObject valueForKey:@"text"]count]; i++) {
                text = [text stringByAppendingString:[[subObject valueForKey:@"text"]objectAtIndex:i]];
                text = [text stringByAppendingString:@"</BR>"];
            }
            htmlString = [htmlString stringByAppendingString:@"<p>"];
            htmlString = [htmlString stringByAppendingString:text];
            htmlString = [htmlString stringByAppendingString:@"</p>"];
        }
    }
    htmlString = [htmlString stringByAppendingString:@"</HTML>"];
    return htmlString;
}

@end
