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

@interface BTRInitializeViewController ()

@property (strong, nonatomic) NSMutableArray *categoryNames;
@property (strong, nonatomic) NSMutableArray *urlCategoryNames;

@end


@implementation BTRInitializeViewController

- (NSMutableArray *)categoryNames {
    if (!_categoryNames) _categoryNames = [[NSMutableArray alloc] init];
    return _categoryNames;
}

- (NSMutableArray *)urlCategoryNames {
    if (!_urlCategoryNames) _urlCategoryNames = [[NSMutableArray alloc] init];
    return _urlCategoryNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self fetchCategoriesWithSuccess:^(NSMutableArray *eventCategoriesArray) {
            [self performSegueWithIdentifier:@"BTRMainSceneSegueIdentifier" sender:self];
        } failure:^(NSError *error) {
            
        }];
        
    });
    
}

# pragma mark - Load Categories

- (void)fetchCategoriesWithSuccess:(void (^)(id  responseObject)) success
                            failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRCategoryFetcher URLforCategories]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSArray * entitiesPropertyList = (NSArray *)response;
        NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
        categoriesArray = [EventCategory loadCategoriesfromAppServerArray:entitiesPropertyList forCategoriesArray:categoriesArray];
        BTRCategoryData *sharedCategoryData = [BTRCategoryData sharedCategoryData];
        for (EventCategory *eventCategory in categoriesArray) {
            [[sharedCategoryData categoryNameArray]  addObject:[eventCategory displayName]];
            [[sharedCategoryData categoryUrlArray]  addObject:[eventCategory name]];
        }
        success(categoriesArray);
    } faild:^(NSError *error) {
        failure(error);
    }];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}



@end






