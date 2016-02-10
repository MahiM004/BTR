//
//  BTRTERMSViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-04.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRTERMSViewController.h"
#import "BTRLoader.h"
#import "Terms.h"
#import "BTRTermsFetcher.h"

@interface BTRTERMSViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong) Terms *term;
@end

@implementation BTRTERMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [BTRGAHelper logScreenWithName:@"/terms"];
}

- (void)viewDidAppear:(BOOL)animated {
    [BTRLoader showLoaderInView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@",[BTRTermsFetcher URLforTerms]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:NO contentType:kContentTypeJSON success:^(NSDictionary *response, NSString *jSonString) {
        self.term = [[Terms alloc]initWithResponse:response];
        [self.webView loadHTMLString:[self.term makeHTMLStringForCountry:Canada] baseURL:nil];
        [self.segmentController setSelectedSegmentIndex:0];
        [BTRLoader hideLoaderFromView:self.view];
    } faild:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentValueChanged:(id)sender {
    if (self.term) {
        if (self.segmentController.selectedSegmentIndex == 0)
            [self.webView loadHTMLString:[self.term makeHTMLStringForCountry:Canada] baseURL:nil];
        if (self.segmentController.selectedSegmentIndex == 1)
            [self.webView loadHTMLString:[self.term makeHTMLStringForCountry:USA] baseURL:nil];
    }
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
@end
