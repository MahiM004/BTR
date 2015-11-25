//
//  BTRAccountEmbeddedTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountEmbeddedTVC.h"
#import "BTRLoginViewController.h"
#import "BTRNotificationsVC.h"
#import "BTRContactUSViewController.h"
#import "BTRTrackOrdersVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "BTRUserFetcher.h"
#import "User+AppServer.h"
#import "BTRFAQFetcher.h"
#import "FAQ+AppServer.h"
#import "BTRContactFetcher.h"
#import "Contact+AppServer.h"
#import "BTROrderHistoryFetcher.h"
#import "OrderHistoryBag+AppServer.h"
#import "OrderHistoryItem+AppServer.h"
#import "BTRConnectionHelper.h"
#import "SDVersion.h"

@interface BTRAccountEmbeddedTVC ()

@property (strong, nonatomic) NSString *sessionId;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;
@property (strong, nonatomic) NSMutableDictionary *itemsDictionary;
@property (strong, nonatomic) NSMutableArray *headersArray;
@property (nonatomic, strong) Contact *contactInfo;

@end




@implementation BTRAccountEmbeddedTVC

- (NSMutableArray *)headersArray {
    if (!_headersArray) _headersArray = [[NSMutableArray alloc] init];
    return _headersArray;
}

- (NSMutableDictionary *)itemsDictionary {
    if (!_itemsDictionary) _itemsDictionary = [[NSMutableDictionary alloc] init];
    return _itemsDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appVersionLabel.text = [NSString stringWithFormat:@"Application Version : %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.deviceModelLabel.text = [NSString stringWithFormat:@"Device Model : %@",[SDVersion deviceName]];
    
    self.user = [[User alloc] init];
    [self fetchUserWithSuccess:^(User *user) {
        self.delegate.user = user;
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@ %@", [user name], [user lastName]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)signOutButtonTapped:(UIButton *)sender {
    [self.delegate signOutDidSelect];
}

#pragma mark - Load User Info RESTful

- (void)fetchUserWithSuccess:(void (^)(id  responseObject)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfo]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            self.user = [User userWithAppServerInfo:response forUser:[self user]];
            success(self.user);
        }
    } faild:^(NSError *error) {
        failure(nil, error);
    }];
}

#pragma mark - Track Orders RESTful

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            if ([BTRViewUtility isIPAD] == YES ) {
                [self.delegate deviceType:@"BTRAccountInformationSegueIdentifieriPad"];
            } else {
                [self.delegate deviceType:@"BTRAccountInformationSegueIdentifier"];
            }
            [self.delegate userInformationDidSelect];
            break;
        case 2:
            if ([BTRViewUtility isIPAD] == YES ) {
                [self.delegate deviceType:@"BTRNotificationsSegueiPadIdentifier"];
            } else {
                [self.delegate deviceType:@"BTRNotificationsSegueIdentifier"];
            }
            [self.delegate notificationSettingDidSelect];
            break;
        case 0:
            [self.delegate trackOrderDidSelect];
            break;
        case 3:
            [self.delegate helpDidSelect];
            break;
        default:
            break;
    }
}

- (NSString*) deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini"        // (2nd Generation iPad Mini - Cellular)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end












