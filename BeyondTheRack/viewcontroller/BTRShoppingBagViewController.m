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
#import "BTRPaypalFetcher.h"
#import "BTRPaypalCheckoutViewController.h"

 
@interface BTRShoppingBagViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bagTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *youSaveLabel;
@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;
@property (strong, nonatomic) NSDictionary *paypal;

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
        
        NSDecimalNumber* number = [NSDecimalNumber decimalNumberWithString:totalString];
        self.subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: %@", [nf stringFromNumber:number]];
        self.bagTitle.text = [NSString stringWithFormat:@"Bag (%lu)", (unsigned long)[self getCountofBagItems]];

        [[self tableView] reloadData];
        
    } failure:^(NSError *error) {
        
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
    if (cell == nil) {
        cell = [[BTRBagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShoppingBagCellIdentifier"];
    }
    
    BagItem *bagItem = [[BagItem alloc] init];
    
    if (indexPath.row < [self.bagItemsArray count]) {
        
        NSString *uniqueSku = [[[self bagItemsArray] objectAtIndex:indexPath.row] sku];
        [cell.itemImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:uniqueSku]
                           placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
        
        Item *item = [self getItemforSku:[[self.bagItemsArray objectAtIndex:[indexPath row]] sku]];
        bagItem = [self.bagItemsArray objectAtIndex:[indexPath row]];
        
        cell = [self configureCell:cell forBagItem:bagItem andItem:item];
    }
    
    NSString *sku = [bagItem sku];
    NSString *eventId = [bagItem eventId];
    NSString *variant = [bagItem variant];
    
    [cell setDidTapRereserveItemButtonBlock:^(id sender) {
        
        [self rereserveItemServerCallforSku:sku andVariant:variant andEventId:eventId success:^(NSString *responseString) {
            
            [[self tableView] reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    }];

    
    return cell;
}



- (Item *)getItemforSku:(NSString *)skuNumber {
    for (Item *item in [self itemsArray]) {
        if ([[item sku] isEqualToString:skuNumber]) {
            return item;
        }
    }
    return nil;
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
        [cell.rereserveItemButton setHidden:TRUE];
        
    } else if (seconds <= 0 && minutes <= 0) {
        cell.remainingTimeLabel.text = [NSString stringWithFormat:@"Time out!"];
        [cell.rereserveItemButton setHidden:FALSE];
    }
    
    return cell;
}

 

#pragma mark - Bag RESTful Calls


- (void)rereserveItemServerCallforSku:(NSString *)skuString andVariant:(NSString *)variantString andEventId:(NSString *)eventIdString
                              success:(void (^)(id  responseObject)) success
                              failure:(void (^)(NSError *error)) failure
{
    [[self bagItemsArray] removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    [manager POST:[NSString stringWithFormat:@"%@/%@/%@/%@", [BTRBagFetcher URLforRereserveBag], skuString, variantString, eventIdString]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             
             NSArray *bagJsonReservedArray = entitiesPropertyList[@"bag"][@"reserved"];
             NSArray *bagJsonExpiredArray = entitiesPropertyList[@"bag"][@"expired"];
             NSDate *serverTime = [NSDate date];
             
             if ([entitiesPropertyList valueForKeyPath:@"time"] && [entitiesPropertyList valueForKeyPath:@"time"] != [NSNull null]) {
                 serverTime = [NSDate dateWithTimeIntervalSince1970:[[entitiesPropertyList valueForKeyPath:@"time"] integerValue]];
             }
             
             NSNumber *total = entitiesPropertyList[@"total"];
             NSString *totalString = [NSString stringWithFormat:@"%@",total];
             
             [BagItem loadBagItemsfromAppServerArray:bagJsonReservedArray
                                  withServerDateTime:serverTime
                                    forBagItemsArray:[self bagItemsArray]
                                           isExpired:@"false"];
             
             [BagItem loadBagItemsfromAppServerArray:bagJsonExpiredArray
                                  withServerDateTime:serverTime
                                    forBagItemsArray:[self bagItemsArray]
                                           isExpired:@"true"];
             
             NSArray *productJsonArray = entitiesPropertyList[@"products"];
             self.itemsArray = [Item loadItemsfromAppServerArray:productJsonArray forItemsArray:[self itemsArray]];
             
             BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
             [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
             
             success(totalString);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
             
         }];

    
}



- (void)getCartServerCallforSessionId:(NSString *)sessionId
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
    [manager GET:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBag]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             
             NSArray *bagJsonReservedArray = entitiesPropertyList[@"bag"][@"reserved"];
             NSArray *bagJsonExpiredArray = entitiesPropertyList[@"bag"][@"expired"];
             NSDate *serverTime = [NSDate date];

            if ([entitiesPropertyList valueForKeyPath:@"time"] && [entitiesPropertyList valueForKeyPath:@"time"] != [NSNull null]) {
                 serverTime = [NSDate dateWithTimeIntervalSince1970:[[entitiesPropertyList valueForKeyPath:@"time"] integerValue]];
             }

             NSNumber *total = entitiesPropertyList[@"total"];
             NSString *totalString = [NSString stringWithFormat:@"%@",total];
             
             [BagItem loadBagItemsfromAppServerArray:bagJsonReservedArray
                                                       withServerDateTime:serverTime
                                                         forBagItemsArray:[self bagItemsArray]
                                                                isExpired:@"false"];
             
             [BagItem loadBagItemsfromAppServerArray:bagJsonExpiredArray
                                  withServerDateTime:serverTime
                                    forBagItemsArray:[self bagItemsArray]
                                           isExpired:@"true"];
             
             NSArray *productJsonArray = entitiesPropertyList[@"products"];
             self.itemsArray = [Item loadItemsfromAppServerArray:productJsonArray forItemsArray:[self itemsArray]];
             
             BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
             [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
             
             success(totalString);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}


- (void)getCheckoutInfoforSessionId:(NSString *)sessionId
                              success:(void (^)(id  responseObject)) success
                              failure:(void (^)(NSError *error)) failure
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
             failure(error);
         }];
}

#pragma mark paypal checkout

- (IBAction)paypalCheckoutTapped:(id)sender {
    [self getPaypalInfo];
}


- (void)getPaypalInfo {
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRPaypalFetcher URLforStartPaypal]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                             options:0
                                                                               error:NULL];
        
        if (entitiesPropertyList) {
            self.paypal = entitiesPropertyList;
            [self performSegueWithIdentifier:@"BTRPaypalCheckoutSegueIdentifier" sender:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([[segue identifier] isEqualToString:@"BTREditBagSegueIdentifier"]) {
        
        BTREditShoppingBagVC *editVC = [segue destinationViewController];
        editVC.bagCountString = [NSString stringWithFormat:@"%lu", (long)[self getCountofBagItems]];
        editVC.bagItemsArray = [self bagItemsArray];
        editVC.itemsArray = [self itemsArray];
    
    } else if ([[segue identifier] isEqualToString:@"BTRCheckoutSegueIdentifier"]) {
        
        BTRCheckoutViewController *checkoutVC = [segue destinationViewController];
        checkoutVC.order = [self order];
        
    } else if ([[segue identifier]isEqualToString:@"BTRPaypalCheckoutSegueIdentifier"]) {
        BTRPaypalCheckoutViewController* paypalVC = [segue destinationViewController];
        paypalVC.paypal = self.paypal;
    }
    
}


- (IBAction)tappedCheckout:(UIButton *)sender {
    
    if ([self.bagItemsArray count] == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"There are no item in bag" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [self getCheckoutInfoforSessionId:[sessionSettings sessionId] success:^(NSDictionary *paymentsDictionary) {
        
        BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
        [sharedPaymentTypes clearData];
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
        
    } failure:^(NSError *error) {
        
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

























