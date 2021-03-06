//
//  BTRInitializeViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRInitializeViewController.h"

#import "BTRCategoryFetcher.h"
#import "EventCategory+AppServer.h"
#import "BTRMainViewController.h"
#import "BTRCategoryData.h"
#import "BTRConnectionHelper.h"
#import "BTRLoader.h"
#import "BTRAppDelegate.h"
#import "BTRNoInternetConnectionViewController.h"

@interface BTRInitializeViewController ()

@end


@implementation BTRInitializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [BTRLoader showLoaderInView:self.view];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self fetchCategoriesWithSuccess:^(NSMutableArray *eventCategoriesArray) {
            [self performSegueWithIdentifier:@"BTRMainSceneSegueIdentifier" sender:self];
        } failure:^(NSError *error) {
            [BTRLoader hideLoaderFromView:self.view];
            BTRAppDelegate *appdel = (BTRAppDelegate *)[[UIApplication sharedApplication]delegate];
            if ([appdel connected] == 0)  {
                BTRNoInternetConnectionViewController *noInt = [[BTRNoInternetConnectionViewController alloc]initWithNibName:@"BTRNoInternetView" bundle:nil];
                [self presentViewController:noInt animated:YES completion:nil];
            } else {
                BTRNoInternetConnectionViewController *noInt = [[BTRNoInternetConnectionViewController alloc]initWithNibName:@"BTRErrorView" bundle:nil];
                [self presentViewController:noInt animated:YES completion:nil];
            }
        }];
    });
    
}

# pragma mark - Load Categories

- (void)fetchCategoriesWithSuccess:(void (^)(id  responseObject)) success
                            failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRCategoryFetcher URLforCategories]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response ,NSString *jSonString) {
        NSArray * entitiesPropertyList = (NSArray *)response;
        NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
        categoriesArray = [EventCategory loadCategoriesfromAppServerArray:entitiesPropertyList forCategoriesArray:categoriesArray];
        BTRCategoryData *sharedCategoryData = [BTRCategoryData sharedCategoryData];
        [sharedCategoryData clearCategoryData];
        for (EventCategory *eventCategory in categoriesArray) {
            [[sharedCategoryData categoryNameArray]  addObject:[[eventCategory displayName]uppercaseString]];
            [[sharedCategoryData categoryUrlArray]  addObject:[eventCategory name]];
        }
        success(categoriesArray);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [BTRLoader hideLoaderFromView:self.view];
}

@end