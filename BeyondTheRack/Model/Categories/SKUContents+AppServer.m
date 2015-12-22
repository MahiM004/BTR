//
//  SKUContents+AppServer.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-12-22.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "SKUContents+AppServer.h"

@implementation SKUContents (AppServer)

+ (SKUContents *)extractSKUContentFromContentInformation:(NSDictionary *)contentInformation forSKUContent:(SKUContents *)content {
    
    if ([contentInformation valueForKeyPath:@"WHITE_GLOVE_TITLE"] && [contentInformation valueForKeyPath:@"WHITE_GLOVE_TITLE"] != [NSNull null])
        content.whiteGloveTitle = [[contentInformation valueForKey:@"WHITE_GLOVE_TITLE"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"WHITE_GLOVE_LINK"] && [contentInformation valueForKeyPath:@"WHITE_GLOVE_LINK"] != [NSNull null])
        content.whiteGloveLink = [[contentInformation valueForKey:@"WHITE_GLOVE_LINK"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"WHITE_GLOVE_MESSAGE"] && [contentInformation valueForKeyPath:@"WHITE_GLOVE_MESSAGE"] != [NSNull null])
        content.whiteGloveMessage = [[contentInformation valueForKey:@"WHITE_GLOVE_MESSAGE"]valueForKey:@"text"];
    
    if ([contentInformation valueForKeyPath:@"DROP_SHIP_TITLE"] && [contentInformation valueForKeyPath:@"DROP_SHIP_TITLE"] != [NSNull null])
        content.dropShipTitle = [[contentInformation valueForKey:@"DROP_SHIP_TITLE"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"DROP_SHIP_LINK"] && [contentInformation valueForKeyPath:@"DROP_SHIP_LINK"] != [NSNull null])
        content.dropShipLink = [[contentInformation valueForKey:@"DROP_SHIP_LINK"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"DROP_SHIP_MESSAGE"] && [contentInformation valueForKeyPath:@"DROP_SHIP_MESSAGE"] != [NSNull null])
        content.dropShipMessage = [[contentInformation valueForKey:@"DROP_SHIP_MESSAGE"]valueForKey:@"text"];
    
    if ([contentInformation valueForKeyPath:@"FLAT_RATE_DROP_SHIP_TITLE"] && [contentInformation valueForKeyPath:@"FLAT_RATE_DROP_SHIP_TITLE"] != [NSNull null])
        content.flatRateDropShipTitle = [[contentInformation valueForKey:@"FLAT_RATE_DROP_SHIP_TITLE"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"FLAT_RATE_DROP_SHIP_LINK"] && [contentInformation valueForKeyPath:@"FLAT_RATE_DROP_SHIP_LINK"] != [NSNull null])
        content.flatRateDropShipLink = [[contentInformation valueForKey:@"FLAT_RATE_DROP_SHIP_LINK"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"FLAT_RATE_DROP_SHIP_MESSAGE"] && [contentInformation valueForKeyPath:@"FLAT_RATE_DROP_SHIP_MESSAGE"] != [NSNull null])
        content.flatRateDropShipMessage = [[contentInformation valueForKey:@"FLAT_RATE_DROP_SHIP_MESSAGE"]valueForKey:@"text"];
    
    if ([contentInformation valueForKeyPath:@"VARIABLE_SHIP_TITLE"] && [contentInformation valueForKeyPath:@"VARIABLE_SHIP_TITLE"] != [NSNull null])
        content.variableShipTitle = [[contentInformation valueForKey:@"VARIABLE_SHIP_TITLE"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"VARIABLE_SHIP_LINK"] && [contentInformation valueForKeyPath:@"VARIABLE_SHIP_LINK"] != [NSNull null])
        content.variableShipShipLink = [[contentInformation valueForKey:@"VARIABLE_SHIP_LINK"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"VARIABLE_SHIP_MESSAGE"] && [contentInformation valueForKeyPath:@"VARIABLE_SHIP_MESSAGE"] != [NSNull null])
        content.variableShipShipMessage = [[contentInformation valueForKey:@"VARIABLE_SHIP_MESSAGE"]valueForKey:@"text"];
    
    if ([contentInformation valueForKeyPath:@"FLAT_RATE_REGULAR_SHIP_TITLE"] && [contentInformation valueForKeyPath:@"FLAT_RATE_REGULAR_SHIP_TITLE"] != [NSNull null])
        content.flatRateRegularShipTitle = [[contentInformation valueForKey:@"FLAT_RATE_REGULAR_SHIP_TITLE"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"FLAT_RATE_REGULAR_SHIP_LINK"] && [contentInformation valueForKeyPath:@"FLAT_RATE_REGULAR_SHIP_LINK"] != [NSNull null])
        content.flatRateRegularShipLink = [[contentInformation valueForKey:@"FLAT_RATE_REGULAR_SHIP_LINK"]valueForKey:@"text"];
    if ([contentInformation valueForKeyPath:@"FLAT_RATE_REGULAR_SHIP_MESSAGE"] && [contentInformation valueForKeyPath:@"FLAT_RATE_REGULAR_SHIP_MESSAGE"] != [NSNull null])
        content.flatRateRegularShipMessage = [[contentInformation valueForKey:@"FLAT_RATE_REGULAR_SHIP_MESSAGE"]valueForKey:@"text"];
    
    if ([contentInformation valueForKeyPath:@"BTR_RECOMMENDATION"] && [contentInformation valueForKeyPath:@"BTR_RECOMMENDATION"] != [NSNull null])
        content.btrRecommendation = [[contentInformation valueForKey:@"BTR_RECOMMENDATION"]valueForKey:@"text"];
    
    return content;
}

@end
