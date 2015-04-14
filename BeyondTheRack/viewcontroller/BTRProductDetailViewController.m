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

#define SIZE_NOT_SELECTED_STRING @"-1"

@interface BTRProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (strong, nonatomic) NSString *sessionId;
@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *variant;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;

@end

@implementation BTRProductDetailViewController


- (NSMutableArray *)bagItemsArray {
    
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}

 
- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.sessionId = [[NSUserDefaults standardUserDefaults] stringForKey:@"Session"];
    self.variant = SIZE_NOT_SELECTED_STRING;
    
    [self setupDocument];
    
    
    NSLog(@"update add_to_bag for search: no event_id is provided");
    
    if ([[[self productItem] brand] length] > 1)
        [self.eventTitleLabel setText:[[self productItem] brand]];
    else
        [self.eventTitleLabel setText:@"Product Detail"];

    
    [self.view setBackgroundColor:[BTRViewUtility BTRBlack]];
    [self.headerView setBackgroundColor:[BTRViewUtility BTRBlack]];
    
    
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

        [self cartIncrementServerCallforSessionId:[self sessionId] success:^(NSString *successString) {
            
            if ([successString isEqualToString:@"TRUE"]) {
             
                UIStoryboard *storyboard = self.storyboard;
                BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
                [vc.bagItemsArray addObjectsFromArray:[self bagItemsArray]];
                
                [self presentViewController:vc animated:YES completion:nil];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        
    }
 
}


#pragma mark - Add to Bag RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}



- (void)cartIncrementServerCallforSessionId:(NSString *)sessionId
                                    success:(void (^)(id  responseObject)) success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];

    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *sessionIdString = [self sessionId];
    [manager.requestSerializer setValue:sessionIdString forHTTPHeaderField:@"SESSION"];
    
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
              
              NSArray *bagJsonArray = entitiesPropertyList[@"bag"][@"reserved"];

              NSDate *serverTime = [NSDate date];
              
              [self.bagItemsArray addObjectsFromArray:[BagItem loadBagItemsfromAppServerArray:bagJsonArray withServerDateTime:serverTime intoManagedObjectContext:self.managedObjectContext]];
              [self.beyondTheRackDocument saveToURL:self.beyondTheRackDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
              
              success(@"TRUE");
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
              failure(operation, error);
              
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


- (IBAction)searchButtonTapped:(UIButton *)sender {
   
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSearchViewController *viewController = (BTRSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchNavigationControllerIdentifier"];
    [self presentViewController:viewController animated:NO completion:nil];*/
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"ProductDetailEmbeddedSegueIdentifier"])
    {
        BTRProductDetailEmbeddedTVC *embeddedVC = [segue destinationViewController];
        embeddedVC.delegate = self;
        embeddedVC.productItem = [self productItem];
        embeddedVC.eventId = [self eventId];
        
    }
}


#pragma mark - BTRProductDetailEmbeddedTVC Delegate

- (void)variantCodeforAddtoBag:(NSString *)variant {
    
    self.variant = variant;
}





@end










