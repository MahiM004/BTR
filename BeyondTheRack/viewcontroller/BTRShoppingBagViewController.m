//
//  BTRShoppingBagViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-24.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRShoppingBagViewController.h"
#import "BTREditShoppingBagVC.h"
#import "BTRCheckoutViewController.h"

#import "BTRBagTableViewCell.h"

#import "BagItem+AppServer.h"
#import "Item+AppServer.h"
#import "Order+AppServer.h"

#import "BTRBagFetcher.h"
#import "BTROrderFetcher.h"
#import "BTRItemFetcher.h"

#import "BTRPaymentTypesHandler.h"


 
@interface BTRShoppingBagViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UILabel *bagTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *youSaveLabel;

@property (strong, nonatomic) Order *order;

@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;

@end



@implementation BTRShoppingBagViewController


- (NSMutableArray *)bagItemsArray {

    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}

- (NSMutableArray *)itemsArray {
    
    if (!_itemsArray) _itemsArray = [[NSMutableArray alloc] init];
    return _itemsArray;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    self.bagTitle.text = [NSString stringWithFormat:@"Bag (%@)", [sharedShoppingBag totalBagCountString]];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"$"];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self getCartServerCallforSessionId:[sessionSettings sessionId] success:^(NSString *totalString) {

        //Removed: request by Richard
        //number = [NSDecimalNumber decimalNumberWithString:@"1000.00"];
        //self.youSaveLabel.text = [NSString stringWithFormat:@"you save: %@", [nf stringFromNumber:number]];
        
        
        NSDecimalNumber* number = [NSDecimalNumber decimalNumberWithString:totalString];
        self.subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: %@", [nf stringFromNumber:number]];
        self.bagTitle.text = [NSString stringWithFormat:@"Bag (%lu)", (unsigned long)[self getCountofBagItems]];

        [[self tableView] reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(timerFired:)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    NSLog(@"re-reserve is ignored");
}


- (NSInteger)getCountofBagItems {
    
    NSInteger counter = 0;
    for (int i = 0; i < [[self bagItemsArray] count]; i++) {
        counter += [[[[self bagItemsArray] objectAtIndex:i] quantity] integerValue];
    }
    
    return counter;
}


- (void)timerFired:(NSTimer *)timer {
    [self.tableView reloadData];
}


#pragma mark - Table view Data source




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self bagItemsArray] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingBagCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[BTRBagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShoppingBagCellIdentifier"];
    }
    
    if (indexPath.row < [self.bagItemsArray count]) {
        
        NSString *uniqueSku = [[[self bagItemsArray] objectAtIndex:indexPath.row] sku];
        
        [cell.itemImageView setImageWithURL:[BTRItemFetcher
                                             URLforItemImageForSku:uniqueSku]
                           placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
        
        cell = [self configureCell:cell forBagItem:[self.bagItemsArray objectAtIndex:[indexPath row]] andItem:[self.itemsArray objectAtIndex:[indexPath row]]];
    }
    
    return cell;
}


- (BTRBagTableViewCell *)configureCell:(BTRBagTableViewCell *)cell forBagItem:(BagItem *)bagItem andItem:(Item *)item {
    
    cell.brandLabel.text = [item brand];
    cell.priceLabel.text =  [BTRViewUtility priceStringfromNumber:[bagItem pricing]];
    cell.itemLabel.text = [item shortItemDescription];
    cell.sizeLabel.text = [NSString stringWithFormat:@"Size: %@", [bagItem  variant]];
    cell.qtyLabel.text = [bagItem quantity];
    
    cell.dueDateTime = [bagItem dueDateTime];
    
    NSInteger ti = ((NSInteger)[cell.dueDateTime timeIntervalSinceNow]);
    int seconds = ti % 60;
    int minutes = (ti / 60) % 60;
    
    if (seconds > 0 || minutes > 0) {
        
        cell.remainingTimeLabel.text = [NSString stringWithFormat:@"Remaining time: %02i:%02i", minutes, seconds];
        
    } else if (seconds <= 0 && minutes <= 0) {
        
        cell.remainingTimeLabel.text = [NSString stringWithFormat:@"Time out!"];
    }
    
    return cell;
}

 

#pragma mark - Bag RESTful Calls


- (void)getCartServerCallforSessionId:(NSString *)sessionId
                              success:(void (^)(id  responseObject)) success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBag]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             NSArray *bagJsonArray = entitiesPropertyList[@"bag"][@"reserved"];
             
             NSDate *serverTime = [NSDate date];
             if ([entitiesPropertyList valueForKeyPath:@"time"] && [entitiesPropertyList valueForKeyPath:@"time"] != [NSNull null]) {
                 
                 serverTime = [NSDate dateWithTimeIntervalSince1970:[[entitiesPropertyList valueForKeyPath:@"time"] integerValue]];
             }

             NSNumber *total = entitiesPropertyList[@"total"];
             NSString *totalString = [NSString stringWithFormat:@"%@",total];
             
             [[self bagItemsArray] removeAllObjects];
             self.bagItemsArray = [BagItem loadBagItemsfromAppServerArray:bagJsonArray withServerDateTime:serverTime forBagItemsArray:[self bagItemsArray]];
            
             NSArray *productJsonArray = entitiesPropertyList[@"products"];
             self.itemsArray = [Item loadItemsfromAppServerArray:productJsonArray forItemsArray:[self itemsArray]];
             
             BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
             [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
             
             success(totalString);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"errtr: %@", error);
             failure(operation, error);
             
         }];
}


- (void)getCheckoutInfoforSessionId:(NSString *)sessionId
                              success:(void (^)(id  responseObject)) success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTROrderFetcher URLforCheckoutInfo]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             
             NSDictionary *paymentsDictionary = entitiesPropertyList[@"paymentMethods"];
             [self setOrder:[Order orderWithAppServerInfo:entitiesPropertyList]];

             success(paymentsDictionary);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"errtr: %@", error);
             failure(operation, error);
             
         }];
}




#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([[segue identifier] isEqualToString:@"BTREditBagSegueIdentifier"]) {
        
        BTREditShoppingBagVC *editVC = [segue destinationViewController];
        editVC.bagItemsArray = [self bagItemsArray];
        editVC.itemsArray = [self itemsArray];
    
    } else if ([[segue identifier] isEqualToString:@"BTRCheckoutSegueIdentifier"]) {
        
        BTRCheckoutViewController *checkoutVC = [segue destinationViewController];
        checkoutVC.order = [self order];
    }
}


- (IBAction)tappedCheckout:(UIButton *)sender {
    
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self getCheckoutInfoforSessionId:[sessionSettings sessionId] success:^(NSDictionary *paymentsDictionary) {
        
        BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
        
        NSArray *allKeysArray = paymentsDictionary.allKeys;
        
        for (NSString *key in allKeysArray) {
            [[sharedPaymentTypes paymentTypesArray] addObject:key];
        }
        
        NSDictionary *creditCardsDic = paymentsDictionary[@"creditcard"][@"type"];
        NSArray *allCreditCardKeysArray = creditCardsDic.allKeys;
        
        for (NSString *key in allCreditCardKeysArray) {
            
            [[sharedPaymentTypes creditCardTypeArray] addObject:key];
            
            NSString *tempString = [creditCardsDic valueForKey:key];
            [[sharedPaymentTypes creditCardDisplayNameArray] addObject:tempString];
        }
        
        
        [self performSegueWithIdentifier:@"BTRCheckoutSegueIdentifier" sender:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}



- (IBAction)tappedClose:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)unwindToShoppingBagScene:(UIStoryboardSegue *)unwindSegue {
    
}

- (IBAction)unwindToShoppingBagScenefromDoneEditing:(UIStoryboardSegue *)unwindSegue {
    
}








@end

























