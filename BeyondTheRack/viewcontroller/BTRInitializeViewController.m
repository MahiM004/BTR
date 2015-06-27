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
    
    [self fetchCategoriesWithSuccess:^(NSMutableArray *eventCategoriesArray) {
                                  
                                  [self performSegueWithIdentifier:@"BTRMainSceneSegueIdentifier" sender:self];

                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                              }];

}



# pragma mark - Load Categories



- (void)fetchCategoriesWithSuccess:(void (^)(id  responseObject)) success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRCategoryFetcher URLforCategories]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSArray * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
         
         NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
         
         categoriesArray = [EventCategory loadCategoriesfromAppServerArray:entitiesPropertyList forCategoriesArray:categoriesArray];//loadCategoriesFromAppServerArray:entitiesPropertyList];
         
         BTRCategoryData *sharedCategoryData = [BTRCategoryData sharedCategoryData];
         
         for (EventCategory *eventCategory in categoriesArray) {
             
             [[sharedCategoryData categoryNameArray]  addObject:[eventCategory displayName]];
             [[sharedCategoryData categoryUrlArray]  addObject:[eventCategory name]];
         }
    
         success(categoriesArray);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         //NSLog(@"Error: %@", error);
     }];
    
}




@end






