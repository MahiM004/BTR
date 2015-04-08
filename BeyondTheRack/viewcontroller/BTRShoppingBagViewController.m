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

@property (weak, nonatomic) IBOutlet UILabel *bagTitle;


@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *youSaveLabel;


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
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"$"];
    
    [self getCartServerCallforSessionId:[self sessionId] success:^(NSString *succString) {
        
        [[self tableView] reloadData];
        self.bagTitle.text = [NSString stringWithFormat:@"Bag (%lu)", (unsigned long)[[self bagItemsArray] count]];
        
        NSDecimalNumber* number = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", [self getSubtotalSale]]];
        self.subtotalLabel.text = [NSString stringWithFormat:@"Sub total: %@", [nf stringFromNumber:number]];
        
        number = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", [self getSubtotalRetail] - [self getSubtotalSale]]];
        self.youSaveLabel.text = [NSString stringWithFormat:@"You Save: %@", [nf stringFromNumber:number]];
        
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
    cell.sizeLabel.text = [NSString stringWithFormat:@"Size: %@", [[self.bagItemsArray objectAtIndex:indexPath.row]  variant]];
        
    return cell;
}



- (float)getSubtotalSale {
 
    float subtotal = 0.0;
    
    for (BagItem *bagItem in self.bagItemsArray) {
        
        Item *item = [Item getItemforSku:[bagItem sku] fromManagedObjectContext:[self managedObjectContext]];
        subtotal += [[bagItem quantity] intValue] * [[item salePrice] floatValue];
    }
    
    return subtotal;
}



- (float)getSubtotalRetail {
    
    float subtotal = 0.0;
    
    for (BagItem *bagItem in self.bagItemsArray) {
        
        Item *item = [Item getItemforSku:[bagItem sku] fromManagedObjectContext:[self managedObjectContext]];
        subtotal += [[bagItem quantity] intValue] * [[item retailPrice] floatValue];
    }
    
    return subtotal;
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
    //serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    /*
     
     bag call is text!
     
     bag increment is json
     
     type of bag has changed on the incerement.
     
     getting (null) on the bag call
     
     */
    
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
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
             
             NSLog(@"%@", entitiesPropertyList);
             
             [self.bagItemsArray removeAllObjects];
             [self.bagItemsArray addObjectsFromArray:[BagItem extractBagItemsfromAppServerArray:entitiesPropertyList]];

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


- (IBAction)unwindToShoppingBagScene:(UIStoryboardSegue *)unwindSegue {
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}










@end

























