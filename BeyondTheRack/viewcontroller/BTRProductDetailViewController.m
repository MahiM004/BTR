//
//  BTRProductDetailViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailViewController.h"
#import "BTRShoppingBagViewController.h"
#import "BTRProductShowcaseVC.h"
#import "BTRBagFetcher.h"
#import "BagItem+AppServer.h"
#import "BTRItemFetcher.h"


#define SIZE_NOT_SELECTED_STRING @"-1"

@interface BTRProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (strong, nonatomic) NSString *variant;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;
@property (strong, nonatomic) Item *itemSelectedfromSearchResult;
@property (strong, nonatomic) NSDictionary *variantInventoryDictionaryforItemfromSearch;
@property (strong, nonatomic) NSDictionary *attributesDictionaryforItemfromSearch;

@end

@implementation BTRProductDetailViewController


- (NSMutableArray *)bagItemsArray {
    
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    self.bagButton.badgeValue = [sharedShoppingBag totalBagCountString];
}

 
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.variant = SIZE_NOT_SELECTED_STRING;
    
    NSLog(@"update add_to_bag for search: no event_id is provided");
    
    if ([[[self productItem] brand] length] > 1)
        [self.eventTitleLabel setText:[[self productItem] brand]];
    else
        [self.eventTitleLabel setText:@"Product Detail"];
    
    [self.view setBackgroundColor:[BTRViewUtility BTRBlack]];
    [self.headerView setBackgroundColor:[BTRViewUtility BTRBlack]];
    
    if ([[self originVCString] isEqualToString:SEARCH_SCENE]) {
        
        [self fetchItemforProductSku:[[self productItem] sku]
                            success:^(Item *responseObject) {
                                [self setItemSelectedfromSearchResult:responseObject];
                                
                            } failure:^(NSError *error) {
                                
                            }];
    }
}


- (IBAction)addToBagTapped:(UIButton *)sender {
    
      
     if ([[self variant] isEqualToString:SIZE_NOT_SELECTED_STRING]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Size"
                                                       message:@"Please select a size!"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        
    } else {

        BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
        [self cartIncrementServerCallforSessionId:[sessionSettings sessionId] success:^(NSString *successString) {
            
            if ([successString isEqualToString:@"TRUE"]) {
                UIStoryboard *storyboard = self.storyboard;
                BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];                
                [self presentViewController:vc animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
 
}


#pragma mark - RESTful Calls



- (void)cartIncrementServerCallforSessionId:(NSString *)sessionId
                                    success:(void (^)(id  responseObject)) success
                                    failure:(void (^)(NSError *error)) failure
{
    [[self bagItemsArray] removeAllObjects];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    NSDictionary *params = (@{
                              @"event_id": [[self productItem] eventId],
                              @"sku": [[self productItem] sku],
                              @"variant":[self variant]
                              });
    
    [manager POST:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              
              NSArray *bagJsonReservedArray = entitiesPropertyList[@"bag"][@"reserved"];
              NSArray *bagJsonExpiredArray = entitiesPropertyList[@"bag"][@"expired"];
              NSDate *serverTime = [NSDate date];
              
              self.bagItemsArray = [BagItem loadBagItemsfromAppServerArray:bagJsonReservedArray
                                                        withServerDateTime:serverTime
                                                          forBagItemsArray:[self bagItemsArray]
                                                                 isExpired:@"false"];
              
              [self.bagItemsArray addObjectsFromArray:[BagItem loadBagItemsfromAppServerArray:bagJsonExpiredArray
                                                                           withServerDateTime:serverTime
                                                                             forBagItemsArray:[self bagItemsArray]
                                                                                    isExpired:@"true"]];
              
              BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
              [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
              
              success(@"TRUE");
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
              failure(error);
              
          }];
}




- (void)fetchItemforProductSku:(NSString *)productSku
                      success:(void (^)(id  responseObject)) success
                      failure:(void (^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                              options:0
                                                                                error:NULL];
         
         [self setAttributesDictionaryforItemfromSearch:entitiesPropertyList[@"attributes"]];
         [self setVariantInventoryDictionaryforItemfromSearch:entitiesPropertyList[@"variant_inventory"]];
         
         Item *productItem = [Item itemWithAppServerInfo:entitiesPropertyList withEventId:[self eventId]];
         
         success(productItem);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
    
}



#pragma mark - Navigation



- (IBAction)backButtonTapped:(UIButton *)sender {
    
    if ([[self originVCString] isEqualToString:SEARCH_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToSearchScene" sender:self];
    
    if ([[self originVCString] isEqualToString:EVENT_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToShowcase" sender:self];
}


- (IBAction)bagButtonTapped:(UIButton *)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"ProductDetailEmbeddedSegueIdentifier"]) {
        
        BTRProductDetailEmbeddedTVC *embeddedVC = [segue destinationViewController];
        embeddedVC.delegate = self;
        
        if ([[self originVCString] isEqualToString:SEARCH_SCENE]) {
            
            embeddedVC.productItem = [self itemSelectedfromSearchResult];
            embeddedVC.variantInventoryDictionary = [self variantInventoryDictionaryforItemfromSearch];
            embeddedVC.attributesDictionary = [self attributesDictionaryforItemfromSearch];
            
            NSLog(@"search item selection to PDP not tested DUE to CONSTRUCTION OF BACKEND API!");
            
        } else {
            
            embeddedVC.productItem = [self productItem];
            embeddedVC.eventId = [self eventId];
            embeddedVC.variantInventoryDictionary = [self variantInventoryDictionary];
            embeddedVC.attributesDictionary = [self attributesDictionary];
        }

    }
}


#pragma mark - BTRProductDetailEmbeddedTVC Delegate

- (void)variantCodeforAddtoBag:(NSString *)variant {
    
    self.variant = variant;
}





@end
















