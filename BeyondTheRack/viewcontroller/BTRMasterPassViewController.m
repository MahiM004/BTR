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
#import "BTRConnectionHelper.h"
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

- (void)preCheckoutDidCompleteWithData:(NSDictionary *)data error:(NSError *)error {
    NSLog(@"PRECHECK");
}

- (void)pairingDidCompleteError:(NSError *)error {
    NSLog(@"PAIRD");
}

- (void)checkoutDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkoutDidCompleteWithError:(NSError *)error withInfo:(NSString *)info {
    [self getInfoForMasterPassAndAddMasterPassInfo:info];
}

- (void)getInfoForMasterPassAndAddMasterPassInfo:(NSString *)checkoutInfo {
    NSString* url = [NSString stringWithFormat:@"%@%@",[BTRMasterPassFetcher URLforMasterPassInfo],checkoutInfo];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [self processMasterPassWithInfo:response];
    } faild:^(NSError *error) {
        
    }];
}

- (void)processMasterPassWithInfo:(NSDictionary *)info {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRMasterPassFetcher URLforMasterPassProcess]];
    [BTRConnectionHelper postDataToURL:url withParameters:info setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if ([[[response valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
            self.order =[[Order alloc]init];
            self.order = [Order orderWithAppServerInfo:response];
            [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
        }
    } faild:^(NSError *error) {
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
