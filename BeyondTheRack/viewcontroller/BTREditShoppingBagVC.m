//
//  BTREditShoppingBagVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREditShoppingBagVC.h"
#import "BTRBagTableViewCell.h"
#import "BTRConnectionHelper.h"
#import "UIImageView+AFNetworking.h"
#import "BTRItemFetcher.h"
#import "BTRBagFetcher.h"
#import "Item+AppServer.h"
#import "BagItem+AppServer.h"

@interface BTREditShoppingBagVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bagTitleLabel;
@property (strong , nonatomic) NSArray *originalBagItemsArray;

@end

@implementation BTREditShoppingBagVC

- (NSMutableArray *)itemsArray {
    if (!_itemsArray) _itemsArray = [[NSMutableArray alloc] init];
    return _itemsArray;
}

- (NSMutableArray *)bagItemsArray {
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"$"];
    
    self.bagTitleLabel.text = [NSString stringWithFormat:@"Edit Bag (%@)", [self bagCountString]];

    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(timerFired:)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.originalBagItemsArray = [self.bagItemsArray mutableCopy];
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

- (IBAction)doneEditingTapped:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    
    [self setShoppingBagWithSuccess:^(NSString *succString) {
        if ([succString isEqualToString:@"TRUE"])
            [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view Data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self bagItemsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTRBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingBagCellIdentifier" forIndexPath:indexPath];
    if (cell == nil)
        cell = [[BTRBagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShoppingBagCellIdentifier"];
    
    NSString *uniqueSku = [[[self bagItemsArray] objectAtIndex:indexPath.row] sku];

    BagItem *bagItem = [[BagItem alloc] init];
    [cell.itemImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:uniqueSku]
                       placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    [cell.itemImageView setContentMode:UIViewContentModeScaleAspectFit];
    Item *item = [self getItemforSku:[[self.bagItemsArray objectAtIndex:[indexPath row]] sku]];
    bagItem = [self.bagItemsArray objectAtIndex:[indexPath row]];
    
    cell = [self configureCell:cell forBagItem:bagItem andItem:item];
    cell.stepper.tag = indexPath.row;
    cell.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        [[self.bagItemsArray objectAtIndex:stepper.tag] setQuantity:[NSString stringWithFormat:@"%@", @(count)]];
        NSInteger editedObjIndex = [self.originalBagItemsArray indexOfObject:[self.bagItemsArray objectAtIndex:stepper.tag]];
        if (editedObjIndex >= 0 && editedObjIndex != NSNotFound) {
            [[self.originalBagItemsArray objectAtIndex:editedObjIndex] setQuantity:[NSString stringWithFormat:@"%@", @(count)]];
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
        }
    };
    [cell.removeButton setTag:indexPath.row];
    [cell.removeButton addTarget:self action:@selector(removeProductItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)removeProductItem:(UIButton *)sender {
    BTRBagTableViewCell *cell = (BTRBagTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [cell.stepper setTag:sender.tag];
    [cell.stepper setValue:0];
    [self.bagItemsArray removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
    [self.bagTitleLabel setText:[NSString stringWithFormat:@"Edit Bag (%lu)", (unsigned long)[self.bagItemsArray count]]];
}

- (Item *)getItemforSku:(NSString *)skuNumber {
    for (Item *item in [self itemsArray])
        if ([[item sku] isEqualToString:skuNumber])
            return item;
    return nil;
}

- (BTRBagTableViewCell *)configureCell:(BTRBagTableViewCell *)cell forBagItem:(BagItem *)bagItem andItem:(Item *)item {
    cell.brandLabel.text = [item brand];
    cell.priceLabel.text =  [BTRViewUtility priceStringfromNumber:[bagItem pricing]];
    cell.itemLabel.text = [item shortItemDescription];
    cell.sizeLabel.text = [NSString stringWithFormat:@"Size: %@", [bagItem  variant]];
    [cell.stepper setValue:[[bagItem quantity] floatValue]];
    cell.dueDateTime = [bagItem dueDateTime];
    
    NSInteger ti = ((NSInteger)[cell.dueDateTime timeIntervalSinceNow]);
    int seconds = ti % 60;
    int minutes = (ti / 60) % 60;
    
    if (seconds > 0 || minutes > 0)
        cell.remainingTimeLabel.text = [NSString stringWithFormat:@"Remaining time: %02i:%02i", minutes, seconds];
    else if (seconds <= 0 && minutes <= 0)
        cell.remainingTimeLabel.text = [NSString stringWithFormat:@"Time out!"];

    return cell;
}

#pragma mark - Bag RESTful Calls

- (void)setShoppingBagWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforSetBag]];
    NSMutableArray *params =[[NSMutableArray alloc] init];
    for (BagItem *bagItem in [self originalBagItemsArray]) {
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
        
        NSArray *bagJsonReservedArray = response[@"bag"][@"reserved"];
        NSArray *bagJsonExpiredArray = response[@"bag"][@"expired"];
        NSDate *serverTime = [NSDate date];
        
        [BagItem loadBagItemsfromAppServerArray:bagJsonReservedArray
                             withServerDateTime:serverTime
                               forBagItemsArray:[self bagItemsArray]
                                      isExpired:@"false"];
        
        [BagItem loadBagItemsfromAppServerArray:bagJsonExpiredArray
                             withServerDateTime:serverTime
                               forBagItemsArray:[self bagItemsArray]
                                      isExpired:@"true"];
        
        BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
        [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
        
        [[self bagTitleLabel] setText:[NSString stringWithFormat:@"(%lu)", (unsigned long)[self getCountofBagItems]]];
        
        NSArray* responseResult = [[response valueForKey:@"response"]valueForKey:@"response"];
        for (int i = 0 ; i < [responseResult count]; i++) {
            if ([[responseResult objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = [responseResult objectAtIndex:i];
                if (![[result valueForKey:@"success"]boolValue]) {
                    [[[UIAlertView alloc]initWithTitle:@"Error" message:[result valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                }
            }
        }
        
        success(@"TRUE");
    } faild:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end










