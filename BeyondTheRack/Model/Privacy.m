//
//  Privacy.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-03.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "Privacy.h"

@implementation Privacy

+ (NSString *)makeHTMLStringByResponse:(NSDictionary *)response {
    NSString *htmlString = @"<HTML>";
    for (NSDictionary *mainObject in response) {
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
            }
            htmlString = [htmlString stringByAppendingString:@"</BR>"];
            htmlString = [htmlString stringByAppendingString:@"<p>"];
            htmlString = [htmlString stringByAppendingString:text];
            htmlString = [htmlString stringByAppendingString:@"</p>"];
        }
    }
    htmlString = [htmlString stringByAppendingString:@"</HTML>"];
    return htmlString;
}

@end
