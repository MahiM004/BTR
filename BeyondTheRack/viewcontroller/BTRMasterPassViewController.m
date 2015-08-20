//
//  BTRMasterPassViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRMasterPassViewController.h"
#import "BTRMasterPassFetcher.h"

@interface BTRMasterPassViewController ()

@end

@implementation BTRMasterPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initilizing
    [[MPManager sharedInstance]setDelegate:self];
    [[MPManager sharedInstance]pairInViewController:self WithInfo:self.info];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pairingDidComplete:(BOOL)success error:(NSError *)error {
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager GET:[NSString stringWithFormat:@"%@", [BTRMasterPassFetcher URLforMasterPassInfo]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                             options:0
                                                                               error:NULL];
        
        if (entitiesPropertyList) {
            
            NSLog(@"%@",entitiesPropertyList);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    NSLog(@"compelete");
}
- (void)checkoutDidComplete:(BOOL)success error:(NSError *)error {
    NSLog(@"Sold");
}


- (NSString *)serverAddress{
    return self.info.callbackUrl;
}
- (BOOL)isAppPaired{
    return YES;
}
- (NSArray *)supportedDataTypes{
    return nil;
}
- (NSArray *)supportedCardTypes {
    return nil;
}

@end
