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
#import "BTRConfirmationViewController.h"
#import "BTRConnectionHelper.h"

@interface BTRPaypalCheckoutViewController ()

@property Order *order;
@property BOOL didLogined;
@property (nonatomic, retain) NSString *transactionID;

@end

@implementation BTRPaypalCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setDelegate:self];
    [self setDidLogined:NO];

    if ([[self.paypal valueForKey:@"mode"]isEqualToString:@"token"]) {
        [self loadPaypalURLWithURL:[self.paypal valueForKey:@"paypalUrl"]];
    } else {
        [self getInfoForPaypal];
    }
    // Do any additional setup after loading the view.
}

- (void)loadPaypalURLWithURL:(NSString *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request.URL absoluteString] lowercaseString];
    NSLog(@"%@",urlString);
    if (urlString.length > 0) {
        if ([request.URL.port intValue] == 80) {
            urlString = [urlString stringByReplacingOccurrencesOfString:@":80" withString:@""];
        }
        
        if ([urlString rangeOfString:@"_flow"].location != NSNotFound) {
            // adding steps
        }
        
        if ([urlString rangeOfString:[[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforCancelPaypal]] lowercaseString]].location != NSNotFound)
            [self dismissViewControllerAnimated:YES completion:nil];

        if ([urlString rangeOfString:[[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPayment]] lowercaseString]].location != NSNotFound) {
            [self setDidLogined:YES];
            [self.webView setHidden:YES];
        }
        if ([urlString rangeOfString:[[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcess]] lowercaseString]].location != NSNotFound) {
            [self.webView setHidden:YES];
            [self getInfoForPaypal];
            return false;
        }
    }
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.didLogined)
        [self getInfoForPaypal];
}

- (void)getInfoForPaypal {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalInfo]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (self.isNewAccount) {
            NSMutableDictionary* newInfo = [NSMutableDictionary dictionaryWithDictionary:response];
            [newInfo removeObjectForKey:@"paypalInfo"];
            NSDictionary *paypalInfo = [[NSDictionary alloc]initWithObjectsAndKeys:@"paypalLogin",@"mode", nil];
            [newInfo setObject:paypalInfo forKey:@"paypalInfo"];
            response = [newInfo mutableCopy];
            self.isNewAccount = NO;
        }
        [self processPayPalWithInfo:response];
    } faild:^(NSError *error) {
        
    }];
}

- (void)processPayPalWithInfo:(NSDictionary *)info {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcess]];
    [BTRConnectionHelper postDataToURL:url withParameters:info setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if ([[[response valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
            self.order =[[Order alloc]init];
            self.order = [Order orderWithAppServerInfo:response];
            [self setTransactionID:[[response valueForKey:@"payment"]valueForKey:@"transactionId"]];
            [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
        }
        else
            [self loadPaypalURLWithURL:[[response valueForKey:@"paypalInfo"]valueForKey:@"paypalUrl"]];
    } faild:^(NSError *error) {
        
    }];
}

- (void)callBackProcessWithTransactionID:(NSString *)transatcionID {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcessCallBackWithTransactionNumber:transatcionID]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSLog(@"%@",response);
    } faild:^(NSError *error) {
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"]) {
        BTRConfirmationViewController* confirm = [segue destinationViewController];
        confirm.order = self.order;
        confirm.transactionID = self.transactionID;
    }
}

@end
