//
//  BTRMasterPassViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRMasterPassViewController.h"
#import "BTRMasterPassFetcher.h"
#import "BTRConfirmationViewController.h"
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

- (void)preCheckoutDidCompleteWithData:(NSDictionary *)data error:(NSError *)error {
    NSLog(@"PRECHECK");
}

- (void)pairingDidCompleteError:(NSError *)error {
    NSLog(@"PAIRD");
}

- (void)checkoutDidCompleteWithError:(NSError *)error withInfo:(NSString *)info {
    [self getInfoForMasterPassAndAddMasterPassInfo:info];
}

- (void)getInfoForMasterPassAndAddMasterPassInfo:(NSString *)checkoutInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager GET:[NSString stringWithFormat:@"%@%@",[BTRMasterPassFetcher URLforMasterPassInfo],checkoutInfo]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary* info = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:0
                                                                    error:NULL];
             [self processMasterPassWithInfo:info];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
    
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"]) {
        
        BTRConfirmationViewController* vc = [segue destinationViewController];
        vc.order = self.order;
        
    }
}

@end
