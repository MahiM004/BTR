//
//  SKUContents+AppServer.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-12-22.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "SKUContents.h"

@interface SKUContents (AppServer)

+ (SKUContents *)extractSKUContentFromContentInformation:(NSDictionary *)contentInformation forSKUContent:(SKUContents *)content;

@end
