//
//  BTRRefineResultsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRRefineResultsViewController.h"
#import "BTRSearchFilterTVC.h"
#import "BTRItemFetcher.h"

#import "BTRFacetsHandler.h"

@interface BTRRefineResultsViewController ()

@end


@implementation BTRRefineResultsViewController

@synthesize backgroundImage;


- (void)viewDidLoad {
    
    [super viewDidLoad];
            
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.headerView.opaque = NO;
    self.headerView.backgroundColor = [UIColor clearColor];
    UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:self.headerView.frame];
    bgToolbar.barStyle = UIBarStyleDefault;
    [self.headerView.superview insertSubview:bgToolbar belowSubview:self.headerView];
    UIImageView *backgroundImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    backgroundImageView.image = [self.backgroundImage applyDarkEffect];
    [self.view insertSubview:backgroundImageView belowSubview:[self headerView]];
}



#pragma mark - Load Results RESTful


- (void)fetchItemsforSearchQuery:(NSString *)searchQuery
                withSortString:(NSString *)sortString
              withFacetsString:(NSString *)facetsString
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:[BTRItemFetcher contentTypeForSearchQuery]];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withSortString:sortString withFacetString:facetsString andPageNumber:0]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                            options:0
                                                                              error:NULL];
         
         BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
         [sharedFacetsHandler updateFacetsFromResponseDictionary:entitiesPropertyList];
         
         success(entitiesPropertyList);         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(error);
     }];
    
}


#pragma mark - Navigation


- (IBAction)clearTapped:(UIButton *)sender {
    
    BTRFacetsHandler * sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    [sharedFacetHandler resetFacets];
    [self performSegueWithIdentifier:@"unwindFromRefineResultsCleared" sender:self];
}


- (IBAction)applyButtonTapped:(UIButton *)sender {

    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    NSString *facetString = [sharedFacetHandler getFacetStringForRESTfulRequest];
    NSString *sortString = [sharedFacetHandler getSortStringForRESTfulRequest];
    
    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                  withSortString:sortString
                withFacetsString:facetString
                         success:^(NSDictionary *responseDictionary) {
                             
                             if ([self.delegate respondsToSelector:@selector(refineSceneWillDisappearWithResponseDictionary:)]) {
                                 [self.delegate refineSceneWillDisappearWithResponseDictionary:responseDictionary];
                             }
                             
                             [self performSegueWithIdentifier:@"unwindFromRefineResultsApplied" sender:self];
                             
                         } failure:^(NSError *error) {

                         }];
}



@end



















