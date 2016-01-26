//
//  BTRHTMLSizeChartViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-01-26.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRHTMLSizeChartViewController.h"

@interface BTRHTMLSizeChartViewController ()
@property NSString *defaultString;
@end

@implementation BTRHTMLSizeChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"size" ofType:@"html"];
    self.defaultString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewWillLayoutSubviews {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSString *width = [NSString stringWithFormat:@"%f",screenBounds.size.width];
    NSString *fixedString = [self.defaultString stringByReplacingOccurrencesOfString:@"deviceWidth" withString:width];
    [self.webView loadHTMLString:fixedString baseURL:nil];
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