//
//  BTRProductDetailViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailViewController.h"

#import "BTRProductShowcaseVC.h"
#import "BTRBagFetcher.h"
#import "BagItem+AppServer.h"

@interface BTRProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (strong, nonatomic) NSString *sessionId;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *variant;

@end

@implementation BTRProductDetailViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.sessionId = [[NSUserDefaults standardUserDefaults] stringForKey:@"Session"];
}




- (void)viewDidLoad {
    
    [super viewDidLoad];

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
    

    //BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
   // [sharedShoppingBag addBagItem:[self ]]
    // REST
    
    [self variant]; int validate_size_is_selected;
    
    [self addToBagAndDataIntoDocument:[self beyondTheRackDocument]
                              success:^(NSString *didSucceed) {
                                  
                                  
                                  
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  
                              }];

    
}


#pragma mark - Add to Bag RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}



- (void)addToBagAndDataIntoDocument:(UIManagedDocument *)document
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
    
    
    NSLog(@"var: %@", [self variant]);
    NSLog(@"sku: %@", [[self productItem] sku]);
    NSLog(@"evid:%@", [[self productItem] eventId]);
    
    
    NSDictionary *params = (@{
                              @"event_id": [[self productItem] eventId],
                              @"sku": [[self productItem] sku],
                              @"variant":[self variant]
                              });
    
    [manager POST:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              /*
              NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                    options:0
                                                                                      error:NULL];
              
              */
              /*
              if (entitiesPropertyList) {
                  
                  [BagItem loadBagItemsFromAppServerArray:entitiesPropertyList intoManagedObjectContext:[self managedObjectContext]];
                  [document saveToURL:[document fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                  
                }*/
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"%@",error);
              
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


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation

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










