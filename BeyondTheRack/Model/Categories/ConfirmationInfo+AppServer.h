//
//  ConfirmationInfo+AppServer.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-10-08.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfirmationInfo.h"

@interface ConfirmationInfo (AppServer)

+ (ConfirmationInfo *)extractConfirmationInfoFromConfirmationInfo:(NSDictionary *)info forConformationInfo:(ConfirmationInfo *)conformation;

@end
