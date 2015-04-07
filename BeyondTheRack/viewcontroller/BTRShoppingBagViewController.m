//
//  BTRShoppingBagViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-24.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRShoppingBagViewController.h"
#import "BTRApprovePurchaseViewController.h"
#import "BTRBagTableViewCell.h"

#import "BagItem+AppServer.h"
#import "Item+AppServer.h"
#import "BTRBagFetcher.h"
#import "BTRItemFetcher.h"

@interface BTRShoppingBagViewController ()


@property (strong, nonatomic) NSString *sessionId;
@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end



@implementation BTRShoppingBagViewController


- (NSMutableArray *)bagItemsArray {

    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.sessionId = [[NSUserDefaults standardUserDefaults] stringForKey:@"Session"];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDocument];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getCartServerCallforSessionId:[self sessionId] success:^(NSString *succString) {
        
        [[self tableView] reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self bagItemsArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingBagCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[BTRBagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShoppingBagCellIdentifier"];
    }
    
    NSString *uniqueSku = [[[self bagItemsArray] objectAtIndex:indexPath.row] sku];
    
    Item *item = [Item getItemforSku:uniqueSku fromManagedObjectContext:[self managedObjectContext]];
    
    [cell.itemImageView setImageWithURL:[BTRItemFetcher
                                         URLforItemImageForSku:uniqueSku]
                                         placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
 
    cell.brandLabel.text = [item brand];
    cell.priceLabel.text =  [BTRViewUtility priceStringfromNumber:[item salePrice]]; 
    cell.quantityLabel.text = [NSString stringWithFormat:@"Qty: %@", [[self.bagItemsArray objectAtIndex:indexPath.row] quantity]];
    cell.itemLabel.text = [item shortItemDescription];
    
    return cell;
}



#pragma mark - Bag RESTful Calls


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}



- (void)getCartServerCallforSessionId:(NSString *)sessionId
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
    
    
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBag]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             
             NSArray *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             [self.bagItemsArray removeAllObjects];
             [self.bagItemsArray addObjectsFromArray:[BagItem loadBagItemsFromAppServerArray:entitiesPropertyList intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext]];
             [self.beyondTheRackDocument saveToURL:self.beyondTheRackDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            
             success(@"TRUE");
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             
             NSLog(@"errtr: %@", error);
             failure(operation, error);
             
         }];
}







#pragma mark - Navigation


- (IBAction)tappedCheckout:(UIButton *)sender {
    
    

}



- (IBAction)tappedClose:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)unwindToShoppingBagScene:(UIStoryboardSegue *)unwindSegue
{
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}










@end

























