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


@interface BTRAccountEmbeddedTVC ()

@property (strong, nonatomic) NSString *sessionId;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
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

#pragma mark - Logout User RESTful

- (void)logutUserServerCallWithSuccess:(void (^)(id  responseObject)) success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserLogout]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        FBSDKLoginManager *fbAuth = [[FBSDKLoginManager alloc] init];
        [fbAuth logOut];
        success(@"TRUE");
    } faild:^(NSError *error) {
        failure(nil, error);
    }];
}

#pragma mark - Track Orders RESTful

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.delegate userInformationDidSelect];
            break;
        case 1:
            [self.delegate notificationSettingDidSelect];
            break;
        case 2:
            [self.delegate trackOrderDidSelect];
            break;
        case 3:
            [self.delegate helpDidSelect];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"BTRNotificationsSegueIdentifier"]) {
//        BTRNotificationsVC *vc = [segue destinationViewController];
//        vc.user = [self user];
//        
//    } else if ([[segue identifier] isEqualToString:@"BTRTrackOrdersSegueIdentifier"]) {
//        BTRTrackOrdersVC *vc = [segue destinationViewController];
//        vc.headersArray = [self headersArray];
//        vc.itemsDictionary = [self itemsDictionary];
//        
//    } else if ([[segue identifier] isEqualToString:@"BTRContactusSegueIdentifier"]) {
//        BTRContactUSViewController* vc = [segue destinationViewController];
//        vc.contactInformaion = self.contactInfo;
//    }
}

-(void)hideHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
@end












