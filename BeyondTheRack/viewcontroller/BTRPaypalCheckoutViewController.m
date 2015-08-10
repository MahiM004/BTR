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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        if ([urlString rangeOfString:[[self cancelURL] lowercaseString]].location != NSNotFound) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if ([urlString rangeOfString:[[self paymentURL] lowercaseString]].location != NSNotFound) {
            [self setDidLogined:YES];
            [self.webView setHidden:YES];
        }
        if ([urlString rangeOfString:[[self fastPayURL] lowercaseString]].location != NSNotFound) {
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
             NSMutableDictionary* info = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             [self processPayPalWithInfo:info];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];

}


- (void)processPayPalWithInfo:(NSDictionary *)info {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager POST:[NSString stringWithFormat:@"%@",[BTRPaypalFetcher URLforPaypalProcess]]
       parameters:info
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              if ([[[entitiesPropertyList valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
                  self.order =[[Order alloc]init];
                  self.order = [Order orderWithAppServerInfo:entitiesPropertyList];
                  [self setTransactionID:[[entitiesPropertyList valueForKey:@"payment"]valueForKey:@"transactionId"]];
                  [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
              }
              else
                  [self loadPaypalURLWithURL:[[entitiesPropertyList valueForKey:@"paypalInfo"]valueForKey:@"paypalUrl"]];
              
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
        confirm.transactionID = self.transactionID;
    }
}

//- (NSDictionary *)makePayPalInfoWithURL:(NSString *)url {
//    
//    NSMutableDictionary *paypalInfo = [[NSMutableDictionary alloc]init];
//    [paypalInfo setObject:@"token" forKey:@"mode"];
////    [paypalInfo setObject:self.payerEmail forKey:@"email"];
//    NSArray *partsOfURL = [url componentsSeparatedByString:@"/"];
//    NSString *parameters = [partsOfURL lastObject];
//    NSArray *elements = [parameters componentsSeparatedByString:@"?"];
//    NSString *getParams = [elements lastObject];
//    NSArray *keys = [getParams componentsSeparatedByString:@"&"];
//    for (NSString *key in keys) {
//        NSArray *components = [key componentsSeparatedByString:@"="];
//        [paypalInfo setObject:[components lastObject] forKey:[components firstObject]];
//    }
//    return paypalInfo;
//}

- (NSString *)fastPayURL {
    return @"www.mobile.btrdev.com/siteapi/checkout/process/paypal/";
}

- (NSString *)paymentURL {
    return @"www.mobile.btrdev.com/siteapi/checkout/info/paypal?token=";
}

- (NSString *)cancelURL {
    return @"http://www.mobile.btrdev.com/siteapi/checkout/paypal?token=";
}

@end
