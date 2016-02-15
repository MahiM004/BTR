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
#import "MasterPassInfo+Appserver.h"
#import "BTRMasterPassFetcher.h"
#import "BTROrderFetcher.h"
#import "BTRItemFetcher.h"
#import "BTRPaymentTypesHandler.h"
#import "BTRPaypalFetcher.h"
#import "BTRConnectionHelper.h"
#import "UIImageView+AFNetworking.h"
#import "ConfirmationInfo+AppServer.h"
#import "BTRConfirmationViewController.h"
#import "BTRLoader.h"
#import "BTRProductDetailEmbededVC.h"

@interface BTRShoppingBagViewController () {
    Item * selectedItemToPDP;
    NSString * selectedItemEventID;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bagTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *youSaveLabel;
@property (weak, nonatomic) IBOutlet UIView *applePayButtonView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@property (strong, nonatomic) UIButton *applePayButton;
@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;
@property (strong, nonatomic) NSDictionary *paypal;
@property (strong, nonatomic) MasterPassInfo *masterpass;
@property (strong, nonatomic) NSDictionary *masterPassCallBackInfo;
@property (strong, nonatomic) NSDictionary *paypalCallBackInfo;
@property (strong, nonatomic) BagItem *removeItem;
@property (strong, nonatomic) ApplePayManager* applePayManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *masterPassCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appleButtonWidth;

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
    [BTRGAHelper logScreenWithName:@"/bag/show"];
    [super viewWillAppear:YES];
    [self loadBagInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupApplePayButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BTRRefreshManager sharedInstance]setTopViewController:self];
    
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
    __weak typeof(cell) weakcell = cell;
    if (cell == nil)
        cell = [[BTRBagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShoppingBagCellIdentifier"];
    
    BagItem *bagItem = [[BagItem alloc] init];
    if (indexPath.row < [self.bagItemsArray count]) {
        NSString *uniqueSku = [[[self bagItemsArray] objectAtIndex:indexPath.row] sku];
        [cell.itemImageView setContentMode:UIViewContentModeScaleAspectFit];
        Item *item = [self getItemforSku:[[self.bagItemsArray objectAtIndex:[indexPath row]] sku]];
        [cell.itemImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSkuWithDomain:[item imagesDomain] withSku:uniqueSku] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
        
//        [cell.itemImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:uniqueSku] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
        
        bagItem = [self.bagItemsArray objectAtIndex:[indexPath row]];
        cell = [self configureCell:cell forBagItem:bagItem andItem:item];
        [cell setDidTapGoToPDPButtonBlock:^(id sender) {
            selectedItemToPDP = item;
            [self performSegueWithIdentifier:@"segueBagToPDP" sender:selectedItemToPDP];
        }];
    }
    NSString *sku = [bagItem sku];
    NSString *eventId = [bagItem eventId];
    selectedItemEventID = eventId;
    NSString *variant = [bagItem variant];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"$"];
    
    
    cell.stepper.tag = indexPath.row;
    cell.stepper.value = bagItem.quantity.floatValue;
    cell.stepper.countLabel.text = bagItem.quantity;
    cell.stepper.incrementCallback =  ^(PKYStepper *stepper, float count) {
        stepper.value = stepper.value - 1;
        [UIImageView beginAnimations:@"addintOne" context:NULL];
        [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:weakcell.itemImageView cache:YES];
        [UIImageView setAnimationDuration:0.5];
        [UIImageView commitAnimations];
        [BTRLoader showLoaderWithViewDisabled:self.view withLoader:YES withTag:222];
        [self performSelector:@selector(addOneQuantityForItem:) withObject:bagItem afterDelay:0.5];
    };
    cell.stepper.decrementCallback = ^(PKYStepper *stepper, float count) {
        stepper.value = stepper.value + 1;
        if ([weakcell.stepper.countLabel.text isEqualToString:@"1"]) {
            [self removeBagItem:bagItem];
        } else {
            [UIImageView beginAnimations:@"removeOne" context:NULL];
            [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:weakcell.itemImageView cache:YES];
            [UIImageView setAnimationDuration:0.5];
            [UIImageView commitAnimations];
            [BTRLoader showLoaderWithViewDisabled:self.view withLoader:YES withTag:444];
            [self performSelector:@selector(removeOneQuantityForItem:) withObject:bagItem afterDelay:0.5];
        }
    };
    [cell setDidTapRereserveItemButtonBlock:^(id sender) {
        [self rereserveItemServerCallforSku:sku andVariant:variant andEventId:eventId success:^(NSString *responseString) {
            NSDecimalNumber* number = [NSDecimalNumber decimalNumberWithString:responseString];
            self.subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: %@", [nf stringFromNumber:number]];
            [[self tableView] reloadData];
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [cell setDidTapRemoveItemButtonBlock:^(UIView *sender) {
        [self removeBagItem:bagItem];
    }];
    
    return cell;
}

- (Item *)getItemforSku:(NSString *)skuNumber {
    for (Item *item in [self itemsArray])
        if ([[item sku] isEqualToString:skuNumber])
            return item;
    return nil;
}

- (BTRBagTableViewCell *)configureCell:(BTRBagTableViewCell *)cell forBagItem:(BagItem *)bagItem andItem:(Item *)item {
    cell.brandLabel.text = [item brand];
    NSString* priceString = [BTRViewUtility priceStringfromNumber:[bagItem pricing]];
    if ([[bagItem additionalShipping]boolValue]) {
        priceString = [priceString stringByAppendingString:@" + Additional Shipping"];
        NSRange range = [priceString rangeOfString:@" + Additional Shipping"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:priceString];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0f] range:range];
        cell.priceLabel.attributedText = attributedString;
    } else
        cell.priceLabel.text = priceString;
    cell.itemLabel.text = [item shortItemDescription];
    cell.sizeLabel.text = [NSString stringWithFormat:@"Size: %@", [bagItem  variantDesc]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

#pragma mark - Bag RESTful Calls

- (void)rereserveItemServerCallforSku:(NSString *)skuString andVariant:(NSString *)variantString andEventId:(NSString *)eventIdString
                              success:(void (^)(id  responseObject)) success
                              failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@", [BTRBagFetcher URLforRereserveBag], skuString, variantString, eventIdString];
    [BTRConnectionHelper postDataToURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {

        NSArray *bagJsonReservedArray = response[@"bag"][@"reserved"];
        NSArray *bagJsonExpiredArray = response[@"bag"][@"expired"];
        NSDate *serverTime = [NSDate date];
        
        if ([response valueForKeyPath:@"time"] && [response valueForKeyPath:@"time"] != [NSNull null]) {
            serverTime = [NSDate dateWithTimeIntervalSince1970:[[response valueForKeyPath:@"time"] integerValue]];
        }
        
        NSNumber *total = response[@"total"];
        NSString *totalString = [NSString stringWithFormat:@"%@",total];
        
        [BagItem loadBagItemsfromAppServerArray:bagJsonReservedArray
                             withServerDateTime:serverTime
                               forBagItemsArray:[self bagItemsArray]
                                      isExpired:@"false"];
        
        [BagItem loadBagItemsfromAppServerArray:bagJsonExpiredArray
                             withServerDateTime:serverTime
                               forBagItemsArray:[self bagItemsArray]
                                      isExpired:@"true"];
        
        NSArray *productJsonArray = response[@"products"];
        self.itemsArray = [Item loadItemsfromAppServerArray:productJsonArray forItemsArray:[self itemsArray] withJsonString:nil];
        
        BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
        [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];

        success(totalString);

    } faild:^(NSError *error) {
        
    }];
}

- (void)getCartServerCallWithSuccess:(void (^)(id  responseObject)) success
                              failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSString* url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforRereserveBag]];
    [BTRConnectionHelper postDataToURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(response);
        [BTRLoader hideLoaderFromView:self.view];

    } faild:^(NSError *error) {
        [BTRLoader hideLoaderFromView:self.view];
        if (failure)
            failure(error);
    }];
}

- (void)getCheckoutInfoSuccess:(void (^)(id  responseObject)) success
                              failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforCheckoutInfo]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
        success(response);
    } faild:^(NSError *error) {
        
    }];
}

- (void)loadBagInfo {
    [BTRLoader showLoaderInView:self.view];
    [self getCartServerCallWithSuccess:^(NSDictionary *response) {
        [self reloadInfoWithResponse:response];
        [BTRLoader hideLoaderFromView:self.view];
    } failure:^(NSError *error) {
        
    }];
}

- (void)addOneQuantityForItem:(BagItem *)bagItem {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]];
    NSDictionary *params = (@{
                              @"event_id": [bagItem eventId],
                              @"sku": [bagItem sku],
                              @"variant": [bagItem variant],
                              });
    [BTRConnectionHelper postDataToURL:url withParameters:(NSDictionary *)params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [BTRLoader removeLoaderFromViewDisabled:self.view withTag:222];
        [self reloadInfoWithResponse:response];
//        [self performSelector:@selector(reloadInfoWithResponse:) withObject:response afterDelay:0.5];
    }faild:^(NSError *error) {
        [BTRLoader removeLoaderFromViewDisabled:self.view withTag:222];
    }];
}

- (void)removeOneQuantityForItem:(BagItem *)bagItem {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforRemovefromBag]];
    NSDictionary *params = (@{
                              @"event_id": [bagItem eventId],
                              @"sku": [bagItem sku],
                              @"variant": [bagItem variant],
                              });
    [BTRConnectionHelper postDataToURL:url withParameters:(NSDictionary *)params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [BTRLoader removeLoaderFromViewDisabled:self.view withTag:444];
        [self performSelector:@selector(reloadInfoWithResponse:) withObject:response afterDelay:0.5];
    }faild:^(NSError *error) {
        [BTRLoader removeLoaderFromViewDisabled:self.view withTag:444];
    }];
}

- (void)removeBagItem:(BagItem *)bagItem {
    [self setRemoveItem:bagItem];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove item?" message:[NSString stringWithFormat:@"Are you sure you want to remove item \"%@\" from your bag?",[self getItemforSku:bagItem.sku].shortItemDescription] delegate:self cancelButtonTitle:@"No, keep it" otherButtonTitles:@"Yes, remove it", nil];
    alert.tag = 100;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self.removeItem setQuantity:@"0"];
            [self updateShoppingBag];
        }
    }
    if (alertView.tag == 200) {
        [self tappedCheckout:nil];
    }
}

- (void)updateShoppingBag {
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"$"];
    
    NSString* url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforSetBag]];
    NSMutableArray *params =[[NSMutableArray alloc] init];
    for (BagItem *bagItem in [self bagItemsArray]) {
        time_t unixTime = (time_t) [[bagItem createDateTime] timeIntervalSince1970];
        NSString *cart_time = [NSString stringWithFormat:@"%@", @(unixTime)];
        
        NSDictionary *bagItemDictionary = (@{
                                             @"event_id": [bagItem eventId],
                                             @"sku": [bagItem sku],
                                             @"variant": [bagItem variant],
                                             @"cart_time": cart_time,
                                             @"quantity": [bagItem quantity]
                                             });
        
        [params addObject:bagItemDictionary];
    }
    
    [[self bagItemsArray] removeAllObjects];
    [BTRConnectionHelper postDataToURL:url withParameters:(NSDictionary *)params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [self reloadInfoWithResponse:response];
    } faild:^(NSError *error) {
        
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BTREditBagSegueIdentifier"]) {
        BTREditShoppingBagVC *editVC = [segue destinationViewController];
        editVC.bagCountString = [NSString stringWithFormat:@"%lu", (long)[self getCountofBagItems]];
        editVC.bagItemsArray = [self bagItemsArray];
        editVC.itemsArray = [self itemsArray];
    } else if ([[segue identifier] isEqualToString:@"BTRCheckoutSegueIdentifier"] || [[segue identifier] isEqualToString:@"BTRCheckoutSegueiPadIdentifier"]) {
        BTRCheckoutViewController *checkoutVC = [segue destinationViewController];
        checkoutVC.order = [self order];
        checkoutVC.masterCallBackInfo = self.masterPassCallBackInfo;
        checkoutVC.paypalCallBackInfo = self.paypalCallBackInfo;
    } else if ([[segue identifier]isEqualToString:@"BTRPaypalCheckoutSegueIdentifier"] || [[segue identifier]isEqualToString:@"BTRPaypalCheckoutSegueiPadIdentifier"]) {

    } else if ([[segue identifier]isEqualToString:@"segueBagToPDP"]) {
        BTRProductDetailEmbededVC * productEmbededVC = [segue destinationViewController];
        productEmbededVC.getOriginalVCString = BAG_SCENE;
        productEmbededVC.getItem = selectedItemToPDP;
        productEmbededVC.getEventID = selectedItemEventID;
    }
}

- (IBAction)tappedCheckout:(UIButton *)sender {
    [self getCheckoutInfoSuccess:^(NSDictionary *response) {
        [self gotoCheckoutPageWithPaymentInfo:response];
    } failure:^(NSError *error) {
        
    }];
}

- (void)gotoCheckoutPageWithPaymentInfo:(NSDictionary *)checkoutInfo {
    NSDictionary *paymentsDictionary = checkoutInfo[@"paymentMethods"];
    [self setOrder:[Order orderWithAppServerInfo:checkoutInfo]];
    if ([self.order.items count] == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"There are no item in bag" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }
    BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
    [sharedPaymentTypes clearData];
    NSArray *allKeysArray = paymentsDictionary.allKeys;
    
    for (NSString *key in allKeysArray)
        [[sharedPaymentTypes paymentTypesArray] addObject:key];
    NSDictionary *creditCardsDic = paymentsDictionary[@"creditcard"][@"type"];
    NSArray *allCreditCardKeysArray = creditCardsDic.allKeys;
    
    for (NSString *key in allCreditCardKeysArray) {
        [[sharedPaymentTypes creditCardTypeArray] addObject:key];
        NSString *tempString = [creditCardsDic valueForKey:key];
        [[sharedPaymentTypes creditCardDisplayNameArray] addObject:tempString];
    }
    if ([[sharedPaymentTypes paymentTypesArray] containsObject:@"paypal"])
        [[sharedPaymentTypes creditCardDisplayNameArray] addObject:@"Paypal"];
    NSString * identifierSB;
    if ([BTRViewUtility isIPAD]) {
        identifierSB = @"BTRCheckoutSegueiPadIdentifier";
    } else {
        identifierSB = @"BTRCheckoutSegueIdentifier";
    }
    [self performSegueWithIdentifier:identifierSB sender:self];
}

- (BOOL)haveTimedOutItem {
    BOOL timeOuted = NO;
    for (int i = 0; i < [self.bagItemsArray count] ; i++) {
        BagItem* currentItem = [self.bagItemsArray objectAtIndex:i];
        NSInteger ti = ((NSInteger)[currentItem.dueDateTime timeIntervalSinceNow]);
        if (ti <= 0)
            timeOuted = YES;
    }
    return timeOuted;
}

#pragma mark firstCheckout

- (IBAction)buyWithApplePay:(UIButton *)sender {
    if ([self.bagItemsArray count] == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"There are no item in bag" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }

    self.applePayManager = [[ApplePayManager alloc]init];
    self.applePayManager.delegate = self;
    [self.applePayManager requestForTokenWithSuccess:^(id responseObject) {
        NSString *token = [responseObject valueForKey:@"token"];
        [self getCheckoutInfoSuccess:^(id responseObject) {
            self.order = [Order extractOrderfromJSONDictionary:responseObject forOrder:self.order isValidating:NO];
            BOOL needValidate = NO;
            if (self.order.allTotalPrice.doubleValue == 0 && [self.order.shippingAddress.postalCode length] > 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Good news!" message:@"You have enough credits to pay for your order.\nPlease complete your order on the checkout page without Apple Pay." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag = 200;
                [alert show];
                return;
                // validation required
            } else if (self.order.allTotalPrice.doubleValue == 0){
                self.order.allTotalPrice = @"0.99";
            }
            if ([self.order.isFreeshipAddress boolValue]) {
                self.order.shippingAddress = self.order.promoShippingAddress;
                needValidate = YES;
            } else if ([self.order.isPickup boolValue] || [self.order.vipPickup boolValue]) {
                if ([self.order.shippingAddress.name length] > 0 && [self.order.shippingAddress.phoneNumber length] >0) {
                    self.order.shippingAddress.addressLine1 = self.order.pickupAddress.addressLine1;
                    self.order.shippingAddress.addressLine2 = self.order.pickupAddress.addressLine2;
                    self.order.shippingAddress.postalCode = self.order.pickupAddress.postalCode;
                    self.order.shippingAddress.city = self.order.pickupAddress.city;
                    self.order.shippingAddress.province = self.order.pickupAddress.province;
                    self.order.shippingAddress.country = self.order.pickupAddress.country;
                    needValidate = YES;
                }else {
                    self.order.isPickup = @"0";
                    self.order.vipPickup = @"0";
                }
            }
            if (needValidate) {
                [self validateAddressViaAPIAndInCompletion:^{
                    [self.applePayManager initWithClientWithToken:token andOrderInfromation:[self.order copy] checkoutMode:checkoutOne];
                    [self.applePayManager showPaymentViewFromViewController:self];
                }];
            } else {
                [self.applePayManager initWithClientWithToken:token andOrderInfromation:[self.order copy] checkoutMode:checkoutOne];
                [self.applePayManager showPaymentViewFromViewController:self];
            }
            
        } failure:^(NSError *error) {
        }];
    } failure:^(NSError *error) {
    }];
}

- (void)validateAddressViaAPIAndInCompletion:(void(^)())completionBlock; {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:[self dictionaryFromAddress:self.order.shippingAddress] forKey:@"shipping"];
    [orderInfo setObject:[self dictionaryFromAddress:self.order.billingAddress] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.order.billingSameAsShipping boolValue]] forKey:@"billto_shipto"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.order.isGift boolValue]] forKey:@"is_gift"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.order.vipPickup boolValue]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.order.isPickup boolValue]] forKey:@"is_pickup"];
    [params setObject:orderInfo forKey:@"orderInfo"];
    [params setObject:@[] forKey:@"vanity_codes"];
    
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforAddressValidation]];
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        self.order = [Order extractOrderfromJSONDictionary:response forOrder:self.order isValidating:YES];
        if (completionBlock)
            completionBlock(nil);
    } faild:^(NSError *error) {
    }];
}

- (NSDictionary *)dictionaryFromAddress:(Address *)address {
    NSDictionary *info = (@{@"name": address.name,
                            @"address1": address.addressLine1,
                            @"address2": address.addressLine2,
                            @"country": address.country,
                            @"postal": address.postalCode,
                            @"state": address.province,
                            @"city": address.city,
                            @"phone": address.phoneNumber });
    return info;
}


- (IBAction)setupApplePay:(UIButton *)sender {
    [self.applePayManager setupApplePay];
}

- (IBAction)paypalCheckout:(UIButton *)sender {
    if ([self.bagItemsArray count] == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"There are no item in bag" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }
    
    [self getPaypalInfo];
}

- (IBAction)masterPassCheckout:(id)sender {
    if ([self.bagItemsArray count] == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"There are no items in your bag" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }
    
    [self getMasterPassInfo];
}

- (void)getPaypalInfo {
    NSString *startURL = [NSString stringWithFormat:@"%@", [BTRPaypalFetcher URLforStartPaypal]];
    NSString *infoURL = [NSString stringWithFormat:@"%@", [BTRPaypalFetcher URLforPaypalInfo]];
    [BTRConnectionHelper getDataFromURL:startURL withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
        if ([[response valueForKey:@"mode"]isEqualToString:@"billingAgreement"] || [[response valueForKey:@"mode"]isEqualToString:@"sessionToken"]) {
            [BTRConnectionHelper getDataFromURL:infoURL withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
                [self setPaypalCallBackInfo:response];
                [self gotoCheckoutPageWithPaymentInfo:response];
            } faild:^(NSError *error) {
                
            }];
        } else {
            BTRPaypalCheckoutViewController *paypalVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"PaypalCheckoutViewController"];
            [paypalVC setPayPalURL:[response valueForKey:@"paypalUrl"]];
            [paypalVC setDelegate:self];
            [self presentViewController:paypalVC animated:YES completion:nil];
        }
    } faild:^(NSError *error) {
        
    }];
}

- (void)getMasterPassInfo {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRMasterPassFetcher URLforStartMasterPass]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
        if (response) {
            MasterPassInfo* master = [MasterPassInfo masterPassInfoWithAppServerInfo:response];
            BTRMasterPassViewController *masterpassVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterPassViewController"];
            [masterpassVC setInfo:master];
            [masterpassVC setDelegate:self];
            [self presentViewController:masterpassVC animated:YES completion:nil];
        }
    } faild:^(NSError *error) {
        
    }];
}

- (void)reloadInfoWithResponse:(NSDictionary *)response {
    NSString *errorMessage = [response valueForKey:@"error_message"];
    if (errorMessage.length > 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:[response valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }
    [self.emptyLabel setHidden:YES];
    [[self bagItemsArray] removeAllObjects];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"$"];
    
    NSArray *bagJsonReservedArray = response[@"bag"][@"reserved"];
    NSArray *bagJsonExpiredArray = response[@"bag"][@"expired"];
    NSDate *serverTime = [NSDate date];
    
    if ([response valueForKeyPath:@"time"] && [response valueForKeyPath:@"time"] != [NSNull null])
        serverTime = [NSDate dateWithTimeIntervalSince1970:[[response valueForKeyPath:@"time"] integerValue]];
    
    NSNumber *total = response[@"total"];
    NSString *totalString = [NSString stringWithFormat:@"%@",total];
    
    if (!self.order)
        self.order = [[Order alloc]init];

    [self.order setOrderTotalPrice:totalString];
    [self.order setSubTotalPrice:@"0.0"];
    [self.order setShippingPrice:@"0.0"];
    [self.order setBagTotalPrice:@"0.0"];
    [self.order setCountry:[[response valueForKey:@"country"]uppercaseString]];
    [self.order setCurrency:[NSString stringWithFormat:@"%@D",self.order.country]];
    
    [BagItem loadBagItemsfromAppServerArray:bagJsonReservedArray
                         withServerDateTime:serverTime
                           forBagItemsArray:[self bagItemsArray]
                                  isExpired:@"false"];
    
    [BagItem loadBagItemsfromAppServerArray:bagJsonExpiredArray
                         withServerDateTime:serverTime
                           forBagItemsArray:[self bagItemsArray]
                                  isExpired:@"true"];
    
    NSArray *productJsonArray = response[@"products"];
    self.itemsArray = [Item loadItemsfromAppServerArray:productJsonArray forItemsArray:[self itemsArray] withJsonString:nil];
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
    
    NSDecimalNumber* number = [NSDecimalNumber decimalNumberWithString:totalString];
    self.subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: %@", [nf stringFromNumber:number]];
    self.bagTitle.text = [NSString stringWithFormat:@"Bag (%lu)", (unsigned long)[self getCountofBagItems]];
    [[self tableView] reloadData];
    
    if ([self.bagItemsArray count] == 0) {
        [self.emptyLabel setHidden:NO];
        self.emptyLabel.text = [response valueForKey:@"message"];
    }
}

- (void)masterPassInfoDidReceived:(NSDictionary *)info {
    [self setMasterPassCallBackInfo:info];
    [self gotoCheckoutPageWithPaymentInfo:info];
}

- (void)payPalInfoDidReceived:(NSDictionary *)info {
    [self setPaypalCallBackInfo:info];
    [self gotoCheckoutPageWithPaymentInfo:info];
}

- (void)applePayReceiptInfoDidReceivedSuccessful:(NSDictionary *)receiptInfo {
    [BTRLoader hideLoaderFromView:self.view];
    ConfirmationInfo *confirmationInfo = [[ConfirmationInfo alloc]init];
    confirmationInfo = [ConfirmationInfo extractConfirmationInfoFromConfirmationInfo:receiptInfo forConformationInfo:confirmationInfo];
    BTRConfirmationViewController *confirmationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmationViewController"];
    confirmationVC.info = confirmationInfo;
    [self presentViewController:confirmationVC animated:YES completion:nil];
}

- (void)applePayInfoFailedWithError:(NSError *)error {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Apple pay process does not work" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    [BTRLoader hideLoaderFromView:self.view];
}

- (void)applePayProcessDidStart {
    [BTRLoader showLoaderInView:self.view];
}

- (void)setupApplePayButton {
    if (self.applePayManager == nil)
        self.applePayManager = [[ApplePayManager alloc]init];
    if ([self.applePayManager isApplePayAvailable]) {
        if ([self.applePayManager isApplePaySetup]) {
            self.applePayButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
            [self.applePayButton addTarget:self action:@selector(buyWithApplePay:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            self.applePayButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleBlack];
            [self.applePayButton addTarget:self action:@selector(setupApplePay:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.applePayButton.frame = self.applePayButtonView.bounds;
        [self.applePayButtonView addSubview:self.applePayButton];
        self.applePayButtonView.hidden = NO;
    } else {
        self.applePayButtonView.hidden = YES;
        self.appleButtonWidth.constant = 0;
        self.masterPassCenter.constant = 0;
    }
}


#pragma mark Closing

- (IBAction)tappedClose:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)unwindToShoppingBagScene:(UIStoryboardSegue *)unwindSegue {
    
}

- (IBAction)unwindToShoppingBagScenefromDoneEditing:(UIStoryboardSegue *)unwindSegue {
    
}

@end


























