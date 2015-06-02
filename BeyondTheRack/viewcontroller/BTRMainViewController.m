//
//  BTREventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRMainViewController.h"
#import "BTRShoppingBagViewController.h"



#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "BTREventsCDTVC.h"
#import "BTRFacetsHandler.h"
#import "BTRSearchViewController.h"

#import "BTRBagFetcher.h"
#import <math.h>


#define YOUR_CATAGORY 4

@interface BTRMainViewController ()


@property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;

@end

@implementation BTRMainViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
    
    [self getCartCountServerCallforSessionId:[btrSettings sessionId] success:^(NSString *bagCountString) {
        
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


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Get bag count

- (void)getCartCountServerCallforSessionId:(NSString *)sessionId
                                   success:(void (^)(id  responseObject)) success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBagCount]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary  *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
             
             NSString *bagCount = [NSString stringWithFormat:@"%@",entitiesPropertyList[@"count"]];
             BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
             sharedShoppingBag.bagCount = [bagCount integerValue];
             
             success(bagCount);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"errtr: %@", error);
             failure(operation, error);
             
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




- (IBAction)unwindFromShoppingBagToEventsScene:(UIStoryboardSegue *)unwindSegue
{
    
}


- (NSInteger) modulaForIndex:(NSInteger)inputInt withCategoryCount:(NSInteger)count
{
    NSInteger relevantInt = (inputInt >= 0) ? (inputInt % count) : ((inputInt % count) + count);

    return relevantInt;
}


- (IBAction)unwindFromShoppingBagToMainScene:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindFromMyAccount:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindToEventViewController:(UIStoryboardSegue *)unwindSegue
{
}


@end














