//
//  BTRAccountEmbeddedTVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+AppServer.h"

@protocol BTRAccountDelegate <NSObject>

@required

@property (nonatomic,strong) User* user;
-(void)deviceType:(NSString*)type;
- (void) signOutDidSelect;
- (void) trackOrderDidSelect;
- (void) helpDidSelect;
- (void) userInformationDidSelect;
- (void) notificationSettingDidSelect;

@end


@interface BTRAccountEmbeddedTVC : UITableViewController
@property (nonatomic, strong) User *user;;
@property (strong, nonatomic) id <BTRAccountDelegate> delegate;
@end
