//
//  BTRHTMLSizeChartViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-01-26.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRHTMLSizeChartViewController.h"
#import <Google/Analytics.h>

@interface BTRHTMLSizeChartViewController ()
@property NSString *defaultString;
@end

@implementation BTRHTMLSizeChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BTRGAHelper logScreenWithName:@"/SizeChart"];
        [self.webView setDelegate:self];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"size" ofType:@"html"];
    self.defaultString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewWillLayoutSubviews {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSString *width = [NSString stringWithFormat:@"%f",screenBounds.size.width];
    NSString *fixedString = [self.defaultString stringByReplacingOccurrencesOfString:@"deviceWidth" withString:width];
    [self.webView loadHTMLString:fixedString baseURL:nil];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    if ( inType == UIWebViewNavigationTypeReload ) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
