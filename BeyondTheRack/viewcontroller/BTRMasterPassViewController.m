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
#import "BTROrderFetcher.h"
#import "BTRConnectionHelper.h"
#import "Order+AppServer.h"
#import "ConfirmationInfo+AppServer.h"

@interface BTRMasterPassViewController ()
@property (nonatomic,strong) Order *order;
@property ConfirmationInfo *confirmationInfo;
@property BOOL shouldLoad;
@end

@implementation BTRMasterPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShouldLoad:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.shouldLoad) {
        if (self.processInfo)
            [self processMasterPassWithInfo:self.processInfo];
        else {
            [[MPManager sharedInstance]setDelegate:self];
            [[MPManager sharedInstance]pairAndCheckoutInViewController:self WithInfo:self.info];
        }
        [self setShouldLoad:NO];
    }
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
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(masterPassInfoDidReceived:)])
                [self.delegate masterPassInfoDidReceived:response];
        }];
    } faild:^(NSError *error) {
        
    }];
}

- (void)processMasterPassWithInfo:(NSDictionary *)info {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRMasterPassFetcher URLforMasterPassProcess]];
    [BTRConnectionHelper postDataToURL:url withParameters:info setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if ([[[response valueForKey:@"payment"]valueForKey:@"success"]boolValue])
            [self getConfirmationInfoWithOrderID:[[response valueForKey:@"order"]valueForKey:@"order_id"]];
        else if ([[[response valueForKey:@"orderInfo"]valueForKey:@"errors"]length] > 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[[UIAlertView alloc]initWithTitle:@"Error" message:[[response valueForKey:@"orderInfo"]valueForKey:@"errors"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            }];
        }
    } faild:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"] || [segue.identifier isEqualToString:@"BTRConfirmationSegueiPadIdentifier"]) {
        BTRConfirmationViewController* vc = [segue destinationViewController];
        vc.info = self.confirmationInfo;
    }
}

- (void)pairRequestFaildByError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Master pass" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    }];
}

#pragma mark confirmation

- (void)getConfirmationInfoWithOrderID:(NSString *)orderID {
    NSString* url = [NSString stringWithFormat:@"%@",[BTROrderFetcher URLforOrderNumber:orderID]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        self.confirmationInfo = [[ConfirmationInfo alloc]init];
        self.confirmationInfo = [ConfirmationInfo extractConfirmationInfoFromConfirmationInfo:response forConformationInfo:self.confirmationInfo];
        NSString * identifierSB;
        if ([BTRViewUtility isIPAD]) {
            identifierSB = @"BTRConfirmationSegueiPadIdentifier";
        } else {
            identifierSB = @"BTRConfirmationSegueIdentifier";
        }
        [self performSegueWithIdentifier:identifierSB sender:self];
    } faild:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%@",error);
    }];
}

@end
