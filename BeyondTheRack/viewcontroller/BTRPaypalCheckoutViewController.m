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

@interface BTRPaypalCheckoutViewController ()
@property Order *order;
@property NSDictionary *paypalInfo;
@property NSString* resultURL;
@property BOOL didLogined;
@end

@implementation BTRPaypalCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setDelegate:self];
    [self setDidLogined:NO];
    [self loadPaypalURL];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPaypalURL {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.paypalURL]]];
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
        
        if ([urlString rangeOfString:[[self cancelURL] lowercaseString]].location != NSNotFound) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if ([urlString rangeOfString:[[self paymentURL] lowercaseString]].location != NSNotFound) {
            [self setResultURL:urlString];
            [self setDidLogined:YES];
            [self.webView setHidden:YES];
        }
    }
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.didLogined)
        [self getInfoForPaypal];
}


- (void)getInfoForPaypal {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager GET:[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalInfo]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             self.paypalInfo = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             [self processPayPal];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];

}


- (void)processPayPal {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager POST:[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcess]]
       parameters:self.paypalInfo
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              if ([[[entitiesPropertyList valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
                  [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

          }];

}

- (void)callBackProcessWithTransactionID:(NSString *)transatcionID {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager GET:[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcessCallBackWithTransactionNumber:transatcionID]]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              NSLog(@"%@",entitiesPropertyList);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"]) {
        BTRConfirmationViewController* confirm = [segue destinationViewController];
        confirm.order = self.order;
    }
}

- (NSString *)paymentURL {
    return @"www.mobile.btrdev.com/siteapi/checkout/info/paypal?token=";
}

- (NSString *)cancelURL {
    return @"http://www.mobile.btrdev.com/siteapi/checkout/paypal?token=";
}

@end
