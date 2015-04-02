//
//  BTRProductDetailViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailViewController.h"

#import "BTRProductShowcaseVC.h"
#import "BTRProductDetailEmbeddedTVC.h"
#import "BTRBagFetcher.h"

@interface BTRProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (strong, nonatomic) NSString *sessionId;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end

@implementation BTRProductDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if ([[[self productItem] brand] length] > 1)
        [self.eventTitleLabel setText:[[self productItem] brand]];
    else
        [self.eventTitleLabel setText:@"Product Detail"];

    
    [self.view setBackgroundColor:[BTRViewUtility BTRBlack]];
    [self.headerView setBackgroundColor:[BTRViewUtility BTRBlack]];
    
    
}


- (IBAction)addToBagTapped:(UIButton *)sender {
    

    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
   // [sharedShoppingBag addBagItem:[self ]]
    // REST
    
}




#pragma mark - Add to Bag RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}



/*
 
 Bag calls requires a valid "session" http header.
 
 GET www.mobile.btrdev.com/siteapi/bag
 [{"event_id":"25744","sku":"NOVNOV702","variant":"Z","cart_time":1426859370,"quantity":"2"}]
 
 POST  www.mobile.btrdev.com/siteapi/bag/add
 {"event_id":"25744","sku":"NOVNOV702","variant":"Z"}
 
 POST www.mobile.btrdev.com/siteapi/bag/remove
 {"event_id":"25744","sku":"NOVNOV702","variant":"Z"}
 
 POST www.mobile.btrdev.com/siteapi/bag/clear
 => nothing required
 
 
 */


- (void)fetchUserDataIntoDocument:(UIManagedDocument *)document
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
    
    
    int pass_the_params;
    
    [manager POST:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                               options:0
                                                                                 error:NULL];
         if (entitiesPropertyList) {
             
           
             //  User *user = [User userWithAppServerInfo:entitiesPropertyList inManagedObjectContext:[self managedObjectContext]];
            
             [document saveToURL:[document fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
             
         
             //    success(user);
         }
         
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


// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"ProductDetailEmbeddedSegueIdentifier"])
    {
        BTRProductDetailEmbeddedTVC *embeddedVC = [segue destinationViewController];
        embeddedVC.productItem = [self productItem];
        
    }
}



@end
