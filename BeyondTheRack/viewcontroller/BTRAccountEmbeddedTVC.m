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
#import "BTRTrackOrdersVC.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "BTRUserFetcher.h"
#import "User+AppServer.h"
#import "BTROrderHistoryFetcher.h"
#import "OrderHistoryBag+AppServer.h"
#import "OrderHistoryItem+AppServer.h"


@interface BTRAccountEmbeddedTVC ()


@property (strong, nonatomic) NSString *sessionId;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (strong, nonatomic) NSMutableDictionary *itemsDictionary;
@property (strong, nonatomic) NSMutableArray *headersArray;


@property (nonatomic, strong) User *user;


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
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self logutUserServerCallforSessionId:[sessionSettings sessionId] success:^(NSString *didSucceed) {
        
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
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfo]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
         if (entitiesPropertyList) {
            
             self.user = [User userWithAppServerInfo:entitiesPropertyList forUser:[self user]];
         
             success(self.user);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
         failure(operation, error);
 
     }];
    
}


#pragma mark - Logout User RESTful


- (void)logutUserServerCallforSessionId:(NSString *)sessionId
                          success:(void (^)(id  responseObject)) success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserLogout]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData) {
             
             FBSDKLoginManager *fbAuth = [[FBSDKLoginManager alloc] init];
             [fbAuth logOut];
             
             success(@"TRUE");
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(operation, error);
         
     }];
    
}

#pragma mark - Track Orders RESTful


- (void)fetchOrderHistoryforSessionId:(NSString *)sessionId
                              success:(void (^)(id  responseObject)) success
                              failure:(void (^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTROrderHistoryFetcher URLforOrderHistory]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                               options:0
                                                                                 error:NULL];
         [[self itemsDictionary] removeAllObjects];
         [[self headersArray] removeAllObjects];
         
         if (entitiesPropertyList) {
                          
             NSArray *allKeysArray = entitiesPropertyList.allKeys;
             
             if ([allKeysArray count] != 0) {
                 
                 for (NSString *key in allKeysArray) {
                     
                     OrderHistoryBag *ohBag = [[OrderHistoryBag alloc] init];
                     NSDictionary *tempDictionary = [entitiesPropertyList objectForKey:key];
                     ohBag = [OrderHistoryBag extractOrderHistoryfromJSONDictionary:tempDictionary forOrderHistoryBag:ohBag];
                     [self.headersArray addObject:ohBag];
                     
                     NSArray *tempArray = tempDictionary[@"lines"];
                     
                     NSMutableArray *linesArray = [[NSMutableArray alloc] init];
                     linesArray = [OrderHistoryItem loadOrderHistoryItemsfromAppServerArray:tempArray forOrderHistoryItemsArray:linesArray];
                     
                     [self.itemsDictionary setObject:linesArray forKey:key];
                 }
             }
             
             success(@"TRUE");
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (IBAction)trackOrdersTapped:(UIButton *)sender {
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self fetchOrderHistoryforSessionId:[sessionSettings sessionId] success:^(NSString *successString) {
        
        [self performSegueWithIdentifier:@"BTRTrackOrdersSegueIdentifier" sender:self];
        
    } failure:^(NSError *error) {
        
    }];
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
     }
 }
 


@end












