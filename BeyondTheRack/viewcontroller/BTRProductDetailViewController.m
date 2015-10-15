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
#import "BTRConnectionHelper.h"

#define SIZE_NOT_SELECTED_STRING @"-1"

@interface BTRProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (strong, nonatomic) NSString *variant;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;
@property (strong, nonatomic) Item *itemSelectedfromSearchResult;
@property (strong, nonatomic) NSDictionary *variantInventoryDictionaryforItemfromSearch;
@property (strong, nonatomic) NSDictionary *attributesDictionaryforItemfromSearch;
@property (weak, nonatomic) IBOutlet UIButton *addTobagButton;
@property (weak, nonatomic) IBOutlet UIView *addToBagView;

//iPad added property
@property UIViewController  *currentDetailViewController;
@property CGFloat rightMargin;
@end

@implementation BTRProductDetailViewController

- (NSMutableArray *)bagItemsArray {
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BTRViewUtility isIPAD] == YES) {
        [self adjustViewsForOrientation:self.interfaceOrientation];
    }
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    self.bagButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[sharedShoppingBag bagCount]];;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.variant == nil)
        self.variant = SIZE_NOT_SELECTED_STRING;
    
    NSLog(@"update add_to_bag for search: no event_id is provided");
    
    if ([[[self productItem] brand] length] > 1)
        [self.eventTitleLabel setText:[[self productItem] brand]];
    else
        [self.eventTitleLabel setText:@"Product Detail"];
    
    [self.view setBackgroundColor:[BTRViewUtility BTRBlack]];
    [self.headerView setBackgroundColor:[BTRViewUtility BTRBlack]];
    if ([BTRViewUtility isIPAD] == YES) {
        [self presentWithIdentifier:@"portraitView"];
    }
    if ([[self originVCString] isEqualToString:SEARCH_SCENE]) {
        [self fetchItemforProductSku:[[self productItem] sku]
                            success:^(Item *responseObject) {
                                [self setItemSelectedfromSearchResult:responseObject];
                            } failure:^(NSError *error) {
                                
                            }];
    }
    if (self.disableAddToCart) {
        self.addTobagButton.enabled = NO;
        self.addToBagView.backgroundColor = [UIColor grayColor];
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
        [self cartIncrementServerCallWithSuccess:^(NSString *successString) {
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

- (void)cartIncrementServerCallWithSuccess:(void (^)(id  responseObject)) success
                                    failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]];
    NSDictionary *params = (@{
                              @"event_id": [[self productItem] eventId],
                              @"sku": [[self productItem] sku],
                              @"variant":[self variant],
                              });
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (![[response valueForKey:@"success"]boolValue]) {
            if ([response valueForKey:@"error_message"]) {
                [[[UIAlertView alloc]initWithTitle:@"Error" message:[response valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            }
            return;
        }
        if (self.quantity.intValue > 1) {
            NSDictionary *itemInfo = (@{@"event_id": [[self productItem] eventId],
                                        @"sku": [[self productItem] sku],
                                        @"variant":[self variant],
                                        @"quantity":[self quantity]
                                        });
            NSDictionary *updateParam = (@{@"key1" : itemInfo});
            NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforSetBag]];
            [BTRConnectionHelper postDataToURL:url withParameters:updateParam setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
                [self updateBagWithDictionary:response];
                success(@"TRUE");
            } faild:^(NSError *error) {
                failure(error);
            }];
            
        } else {
            
            [self updateBagWithDictionary:response];
            success(@"TRUE");
        }

    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (void)updateBagWithDictionary:(NSDictionary *)entitiesPropertyList {
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
}

- (void)fetchItemforProductSku:(NSString *)productSku
                      success:(void (^)(id  responseObject)) success
                      failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [self setAttributesDictionaryforItemfromSearch:response[@"attributes"]];
        [self setVariantInventoryDictionaryforItemfromSearch:response[@"variant_inventory"]];
        Item *productItem = [Item itemWithAppServerInfo:response withEventId:[self eventId]];
        success(productItem);
    } faild:^(NSError *error) {
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
            embeddedVC.attributesDictionary = [self attributesDictionary];
            embeddedVC.variantInventoryDictionary = [self variantInventoryDictionary];
        }
    }
}

#pragma mark - BTRProductDetailEmbeddedTVC Delegate

- (void)variantCodeforAddtoBag:(NSString *)variant {
    self.variant = variant;
}

- (void)quantityForAddToBag:(NSString *)qty {
    self.quantity = qty;
}
//iPad added methods
- (void)presentDetailController:(UIViewController*)detailVC{
    if(self.currentDetailViewController){
        [self removeCurrentDetailViewController];
    }
    [self addChildViewController:detailVC];
    detailVC.view.frame = [self frameForDetailController];
    [self.detailView addSubview:detailVC.view];
    self.currentDetailViewController = detailVC;
    [detailVC didMoveToParentViewController:self];
}
- (void)removeCurrentDetailViewController{
    [self.currentDetailViewController willMoveToParentViewController:nil];
    [self.currentDetailViewController.view removeFromSuperview];
    [self.currentDetailViewController removeFromParentViewController];
}
- (CGRect)frameForDetailController{
    CGRect detailFrame = self.detailView.bounds;
    return detailFrame;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self adjustViewsForOrientation:toInterfaceOrientation];
}
-(void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        _rightMargin = 0;
        [self presentWithIdentifier:@"portraitView"];
    }else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        _rightMargin = 250;
        [self presentWithIdentifier:@"landScapeView"];
    }
}
-(void)presentWithIdentifier:(NSString *)identifierStoryBoard {
    BTRProductDetailOrientationViewController *embeddedVC = [self.storyboard instantiateViewControllerWithIdentifier:identifierStoryBoard];
    if ([[self originVCString] isEqualToString:SEARCH_SCENE]) {
        embeddedVC.productItem = [self itemSelectedfromSearchResult];
        embeddedVC.variantInventoryDictionary = [self variantInventoryDictionaryforItemfromSearch];
        embeddedVC.attributesDictionary = [self attributesDictionaryforItemfromSearch];
        embeddedVC.rightMargin = _rightMargin;
        NSLog(@"search item selection to PDP not tested DUE to CONSTRUCTION OF BACKEND API!");
    } else {
        embeddedVC.productItem = [self productItem];
        embeddedVC.eventId = [self eventId];
        embeddedVC.attributesDictionary = [self attributesDictionary];
        embeddedVC.variantInventoryDictionary = [self variantInventoryDictionary];
        embeddedVC.rightMargin = _rightMargin;
    }
    [self presentDetailController:embeddedVC];
}

@end
















