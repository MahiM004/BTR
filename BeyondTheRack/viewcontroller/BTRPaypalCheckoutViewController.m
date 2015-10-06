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
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BTRPaypalCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setDelegate:self];
    [self setDidLogined:NO];
    
    NSDictionary *paypal = [self.paypalInfo valueForKey:@"paypalInfo"];
    if ([[paypal valueForKey:@"mode"]isEqualToString:@"token"]) {
        [self loadPaypalURLWithURL:[paypal valueForKey:@"paypalUrl"]];
    } else {
        [self processPayPalWithInfo:self.paypalInfo];
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
            [self getOrderInfoOfCallBackURL:[request.URL absoluteString]];
            return false;
        }
    }
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.didLogined) {
//        NSMutableDictionary *newInfo = [NSMutableDictionary dictionaryWithDictionary:self.paypalInfo];
//        [newInfo setObject:[NSDictionary dictionaryWithObject:@"billingAgreement" forKey:@"mode"] forKey:@"paypalInfo"];
//        [self processPayPalWithInfo:newInfo];
    }
}

- (void)getOrderInfoOfCallBackURL:(NSString *)callBackURL {
    [BTRConnectionHelper getDataFromURL:callBackURL withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if ([[[response valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
            [self callBackProcessWithTransactionID:[[response valueForKey:@"payment"]valueForKey:@"transactionId"]];
            self.order =[[Order alloc]init];
            self.order = [Order orderWithAppServerInfo:response];
            [self setTransactionID:[[response valueForKey:@"payment"]valueForKey:@"transactionId"]];
            [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
        }
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
            self.order =[[Order alloc]init];
            self.order = [Order orderWithAppServerInfo:response];
            [self setTransactionID:[[response valueForKey:@"payment"]valueForKey:@"transactionId"]];
            [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
        }else
           [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"]) {
        BTRConfirmationViewController* confirm = [segue destinationViewController];
        confirm.order = self.order;
        confirm.transactionID = self.transactionID;
    }
}

@end
