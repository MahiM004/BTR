//
//  BTRPrivacyVC.m
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 05/02/16.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRPrivacyVC.h"
#import "BTRLoader.h"
#import "Privacy.h"
#import "BTRPrivacyFetcher.h"
@interface BTRPrivacyVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) Privacy * privacy;
@end

@implementation BTRPrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [BTRGAHelper logScreenWithName:@"/privacy"];
}

- (void)viewDidAppear:(BOOL)animated {
    [BTRLoader showLoaderInView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@",[BTRPrivacyFetcher URLforPrivacy]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:NO contentType:kContentTypeJSON success:^(NSDictionary *response, NSString *jSonString) {
        [self.webView loadHTMLString:[Privacy makeHTMLStringByResponse:response] baseURL:nil];
        [BTRLoader hideLoaderFromView:self.view];
    } faild:^(NSError *error) {
        
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
@end
