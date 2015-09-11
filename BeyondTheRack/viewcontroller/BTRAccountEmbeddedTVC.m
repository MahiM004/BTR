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
@property (nonatomic, strong) User *user;
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
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@ %@", [user name], [user lastName]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)signOutButtonTapped:(UIButton *)sender {
    
    [self logutUserServerCallWithSuccess:^(NSString *didSucceed) {
        BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
        [btrSettings clearSession];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BTRLoginViewController *viewController = (BTRLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BTRLoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
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

- (void)fetchOrderHistoryWithSuccess:(void (^)(id  responseObject)) success
                             failure:(void (^)(NSError *error)) failure {
    
    [[self itemsDictionary] removeAllObjects];
    [[self headersArray] removeAllObjects];
    
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderHistoryFetcher URLforOrderHistory]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response.count > 0) {
            NSArray *allKeysArray = response.allKeys;
            NSMutableArray *tempHeaderArray = [[NSMutableArray alloc] init];
            if ([allKeysArray count] != 0) {
                for (NSString *key in allKeysArray) {
                    OrderHistoryBag *ohBag = [[OrderHistoryBag alloc] init];
                    NSDictionary *tempDictionary = [response objectForKey:key];
                    ohBag = [OrderHistoryBag extractOrderHistoryfromJSONDictionary:tempDictionary forOrderHistoryBag:ohBag];
                    [tempHeaderArray addObject:ohBag];
                    NSArray *tempArray = tempDictionary[@"lines"];
                    NSMutableArray *linesArray = [[NSMutableArray alloc] init];
                    linesArray = [OrderHistoryItem loadOrderHistoryItemsfromAppServerArray:tempArray forOrderHistoryItemsArray:linesArray];
                    [self.itemsDictionary setObject:linesArray forKey:key];
                }
                self.headersArray = tempHeaderArray;
            }
            success(@"TRUE");
        }else {
            [self hideHUD];
            [[[UIAlertView alloc]initWithTitle:@"Empty" message:@"You dont have any order to track" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        }
        
    } faild:^(NSError *error) {
        [self hideHUD];
        failure(error);
    }];
}

#pragma mark - Getting Contact US

- (void)fetchContactWithSuccess:(void (^)(id  responseObject)) success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRContactFetcher URLForContact]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            self.contactInfo = [Contact contactWithAppServerInfo:response];
            success(self.contactInfo);
        }
    } faild:^(NSError *error) {
        failure(nil,error);
    }];
}

- (IBAction)trackOrdersTapped:(UIButton *)sender {
    
    [self.tableView setUserInteractionEnabled:FALSE];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchOrderHistoryWithSuccess:^(NSString *successString) {
            [self performSegueWithIdentifier:@"BTRTrackOrdersSegueIdentifier" sender:self];
        } failure:^(NSError *error) {
            [self hideHUD];
        }];
    });
    [self.tableView setUserInteractionEnabled:TRUE];
}

- (IBAction)helpTapped:(UIButton *)sender {
    if (self.contactInfo == nil) {
        [self fetchContactWithSuccess:^(id responseObject) {
            [self performSegueWithIdentifier:@"BTRContactusSegueIdentifier" sender:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    } else
        [self performSegueWithIdentifier:@"BTRContactusSegueIdentifier" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BTRNotificationsSegueIdentifier"]) {
        BTRNotificationsVC *vc = [segue destinationViewController];
        vc.user = [self user];
        
    } else if ([[segue identifier] isEqualToString:@"BTRTrackOrdersSegueIdentifier"]) {
        BTRTrackOrdersVC *vc = [segue destinationViewController];
        vc.headersArray = [self headersArray];
        vc.itemsDictionary = [self itemsDictionary];
        
    } else if ([[segue identifier] isEqualToString:@"BTRContactusSegueIdentifier"]) {
        BTRContactUSViewController* vc = [segue destinationViewController];
        vc.contactInformaion = self.contactInfo;
    }
}
-(void)hideHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
@end












