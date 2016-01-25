//
//  BTRPaypalCheckoutViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRPaypalCheckoutViewController.h"
#import "Order+AppServer.h"
#import "BTRPaypalFetcher.h"
#import "BTROrderFetcher.h"
#import "BTRConfirmationViewController.h"
#import "BTRConnectionHelper.h"
#import "ConfirmationInfo+AppServer.h"

@interface BTRPaypalCheckoutViewController ()

@property Order *order;
@property BOOL didLogined;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) ConfirmationInfo *confirmationInfo;

@end

@implementation BTRPaypalCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setDelegate:self];
    [self setDidLogined:NO];
    if (self.delegate)
        [self loadPaypalURLWithURL:self.payPalURL];
    else
        [self processPayPalWithInfo:self.paypalInfo];
}

- (void)loadPaypalURLWithURL:(NSString *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request.URL absoluteString] lowercaseString];
    if (urlString.length > 0) {
        if ([request.URL.port intValue] == 80) {
            urlString = [urlString stringByReplacingOccurrencesOfString:@":80" withString:@""];
        }
        
        if ([urlString rangeOfString:@"_flow"].location != NSNotFound) {
        }
        
        if ([urlString rangeOfString:[[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforCancelPaypal]] lowercaseString]].location != NSNotFound)
            [self dismissViewControllerAnimated:YES completion:nil];

        if ([urlString rangeOfString:[[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPayment]] lowercaseString]].location != NSNotFound) {
            [self setDidLogined:YES];
            [self getOrderInfoOfCallBackURLRequest:request.URL.absoluteString];
            [self.webView setHidden:YES];
            return NO;
        }
        if ([urlString rangeOfString:[[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcess]] lowercaseString]].location != NSNotFound) {
            [self.webView setHidden:NO];
            [self getOrderInfoOfCallBackURLRequest:request.URL.absoluteString];
            return NO;
        }
    }
    return TRUE;
}

- (void)getOrderInfoOfCallBackURLRequest:(NSString *)url {
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (self.delegate) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate payPalInfoDidReceived:response];
            }];
            return;
        }
        if ([[[response valueForKey:@"payment"]valueForKey:@"success"]boolValue])
           [self getConfirmationInfoWithOrderID:[[response valueForKey:@"order"]valueForKey:@"order_id"]];
        else
            [self dismissViewControllerAnimated:YES completion:nil];
    } faild:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)processPayPalWithInfo:(NSDictionary *)info {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcess]];
    [BTRConnectionHelper postDataToURL:url withParameters:info setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if ([[[response valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
            [self getConfirmationInfoWithOrderID:[[response valueForKey:@"order"]valueForKey:@"order_id"]];
        }else if ([[[response valueForKey:@"paypalInfo"] valueForKey:@"success"]boolValue] && [[response valueForKey:@"paypalInfo"]valueForKey:@"paypalUrl"])
            [self loadPaypalURLWithURL:[[response valueForKey:@"paypalInfo"]valueForKey:@"paypalUrl"]];
        else
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Paypal Checkout does not work now. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    } faild:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)callBackProcessWithTransactionID:(NSString *)transatcionID {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcessCallBackWithTransactionNumber:transatcionID]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSLog(@"%@",response);
    } faild:^(NSError *error) {
        
    }];
}

- (void)getConfirmationInfoWithOrderID:(NSString *)orderID {
    NSString* url = [NSString stringWithFormat:@"%@",[BTROrderFetcher URLforOrderNumber:orderID]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        self.confirmationInfo = [[ConfirmationInfo alloc]init];
        self.confirmationInfo = [ConfirmationInfo extractConfirmationInfoFromConfirmationInfo:response forConformationInfo:self.confirmationInfo];
        NSString * identifierSB;
        identifierSB = @"BTRConfirmationSegueIdentifier";
        [self performSegueWithIdentifier:identifierSB sender:self];
    } faild:^(NSError *error) {
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"] || [segue.identifier isEqualToString:@"BTRConfirmationSegueiPadIdentifier"] ) {
        BTRConfirmationViewController* confirm = [segue destinationViewController];
        confirm.info = self.confirmationInfo;
    }
}

@end
