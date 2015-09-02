//
//  BTREventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRMainViewController.h"
#import "BTRShoppingBagViewController.h"
#import "BTRCategoryViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "BTREventsTVC.h"
#import "BTRFacetsHandler.h"
#import "BTRSearchViewController.h"
#import "BTRBagFetcher.h"
#import "BTRConnectionHelper.h"
#import <math.h>


@interface BTRMainViewController ()

@property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;

@end

@implementation BTRMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCartCountServerCallWithSuccess:^(NSString *bagCountString) {
        self.bagButton.badgeValue = bagCountString;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    [sharedFacetHandler resetFacets];
    sharedFacetHandler.searchString = @"";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BTRViewUtility BTRBlack];
    self.headerView.backgroundColor = [BTRViewUtility BTRBlack];
}

#pragma mark - Get bag count

- (void)getCartCountServerCallWithSuccess:(void (^)(id  responseObject)) success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBagCount]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES success:^(NSDictionary *response) {
        NSString *bagCount = [NSString stringWithFormat:@"%@",response[@"count"]];
        BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
        sharedShoppingBag.bagCount = [bagCount integerValue];
        success(bagCount);
    } faild:^(NSError *error) {
        NSLog(@"errtr: %@", error);
        failure(nil, error);
    }];
}



#pragma mark - Navigation


- (IBAction)searchButtonTapped:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSearchViewController *viewController = (BTRSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchNavigationControllerIdentifier"];
    [self presentViewController:viewController animated:NO completion:nil];
}


- (IBAction)tappedShoppingBag:(id)sender {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSInteger) modulaForIndex:(NSInteger)inputInt withCategoryCount:(NSInteger)count {
    NSInteger relevantInt = (inputInt >= 0) ? (inputInt % count) : ((inputInt % count) + count);
    return relevantInt;
}

- (IBAction)unwindFromShoppingBagToEventsScene:(UIStoryboardSegue *)unwindSegue {
}


- (IBAction)unwindFromShoppingBagToMainScene:(UIStoryboardSegue *)unwindSegue {
}


- (IBAction)unwindFromMyAccount:(UIStoryboardSegue *)unwindSegue {
}


- (IBAction)unwindToEventViewController:(UIStoryboardSegue *)unwindSegue {
}

@end














