//
//  MPPairingViewController.m
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPLightboxViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MPLightboxViewController ()
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, assign) MPLightBoxType type;
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation MPLightboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height -20 )];
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    
    self.loadingView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width / 2.) - 40, (self.view.frame.size.height / 2.) - 40, 80, 80)];
    self.loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    self.loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(self.loadingView.frame.size.width / 2., self.loadingView.frame.size.height / 2.);
    [activityView startAnimating];
    activityView.tag = 100;
    [self.loadingView addSubview:activityView];
    
    [self.view addSubview:self.loadingView];
}

- (void)initiateLightBoxOfType:(MPLightBoxType)type WithOptions:(NSDictionary *)options{
    self.options = options;
    self.type = type;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"mp_lightbox_base" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlString baseURL:nil];
}

-(void) checkIfLoadDone:(UIWebView *) webView {
    if (webView.loading) { return; }
    
    // remove loading view
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.options
                                                       options:0
                                                         error:&error];
    
    if (error) {
        NSLog(@"JSON Parse Error: %@", [error localizedDescription]);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        int type = self.type;
        if (self.type == MPLightBoxTypePreCheckout) {
            type = 1; // Hacks for now TODO
        }
        
        NSString *command = [NSString stringWithFormat:@"initiateLightbox(%d, %@);", type, jsonString];
        
        NSLog(@"%@",command);
        
        [webView stringByEvaluatingJavaScriptFromString:command];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *currentUrl = request.URL;
    NSString *currentUrlString = [NSString stringWithFormat:@"%@://%@%@",currentUrl.scheme,currentUrl.host,currentUrl.path];
    
    if ([currentUrlString isEqualToString:[[self.options objectForKey:@"callbackUrl"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]]) {
        
        if (self.type == MPLightBoxTypeConnect) {
            NSLog(@"PAIR LIGHT");
            if (self.delegate && [self.delegate respondsToSelector:@selector(pairingDidCompleteError:)]) {
                [self.delegate pairingView:self didCompletePairingWithError:nil];
            }
        }
        else if (self.type == MPLightBoxTypeCheckout) {
            NSLog(@"chekout LIGHT");
            if (self.delegate && [self.delegate respondsToSelector:@selector(lightBox:didCompleteCheckoutWithError:Info:)]) {
                [self.delegate lightBox:self didCompleteCheckoutWithError:nil Info:[request.URL.absoluteString stringByReplacingOccurrencesOfString:[self.options objectForKey:@"callbackUrl"] withString:@""]];
            }
        }
        else if (self.type == MPLightBoxTypePreCheckout){
            NSLog(@"PRECHECK LIGHT");
            if (self.delegate && [self.delegate respondsToSelector:@selector(lightBox:didCompletePreCheckoutWithData:error:)]) {
                [self.delegate lightBox:self didCompletePreCheckoutWithData:nil error:nil];
            }
        }
        return NO;

    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self performSelector:@selector(checkIfLoadDone:)
               withObject:webView
               afterDelay:0.5];
}

@end
