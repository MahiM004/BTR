//
//  BTRMasterPassViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRMasterPassViewController.h"
#import "BTRMasterPassFetcher.h"
#import "Order+AppServer.h"

@interface BTRMasterPassViewController ()
@property (nonatomic,strong) Order *order;
@end

@implementation BTRMasterPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initilizing
    [[MPManager sharedInstance]setDelegate:self];
    [[MPManager sharedInstance]pairAndCheckoutInViewController:self WithInfo:self.info];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preCheckoutDidComplete:(BOOL)success data:(NSDictionary *)data error:(NSError *)error {
    NSLog(@"PRECHECK");
}

-(void)pairingDidComplete:(BOOL)success error:(NSError *)error {
    NSLog(@"PAIRD");
}

- (void)checkoutDidComplete:(BOOL)success error:(NSError *)error withInfo:(NSDictionary *)info;{
    
    NSLog(@"Sold");
    [self processMasterPassWithInfo:info];

}

//- (void)getInfoForMasterPassAndAddMasterPassInfo:(NSDictionary *)checkoutInfo {
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
//    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    manager.responseSerializer = serializer;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
//    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
//    [manager GET:[NSString stringWithFormat:@"%@",[BTRMasterPassFetcher URLforMasterPassInfo]]
//      parameters:nil
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSDictionary* info = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                                  options:0
//                                                                    error:NULL];
//             NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
//             [dic removeObjectForKey:@"masterPassInfo"];
//             [dic setValue:[checkoutInfo valueForKey:@"masterPassInfo"] forKey:@"masterPassInfo"];
//             [self processMasterPassWithInfo:dic];
//             
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             
//         }];
//    
//}

- (void)processMasterPassWithInfo:(NSDictionary *)info {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager POST:[NSString stringWithFormat:@"%@",[BTRMasterPassFetcher URLforMasterPassProcess]]
       parameters:info
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              if ([[[entitiesPropertyList valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
                  self.order =[[Order alloc]init];
                  self.order = [Order orderWithAppServerInfo:entitiesPropertyList];
                  [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
              }

          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
          }];
}

@end
