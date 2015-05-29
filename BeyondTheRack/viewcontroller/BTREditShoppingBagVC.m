//
//  BTREditShoppingBagVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREditShoppingBagVC.h"
#import "BTRBagTableViewCell.h"

#import "BTRItemFetcher.h"
#import "BTRBagFetcher.h"

#import "Item+AppServer.h"
#import "BagItem+AppServer.h"

@interface BTREditShoppingBagVC ()

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bagTitleLabel;

@end

@implementation BTREditShoppingBagVC

- (NSMutableArray *)bagItemsArray {
    
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [self setupDocument];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"$"];
    
    self.bagTitleLabel.text = [NSString stringWithFormat:@"Edit Bag (%lu)", (unsigned long)[self getCountofBagItems]];
    
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


- (IBAction)doneEditingTapped:(UIButton *)sender {

    
    __weak typeof(self) weakSelf = self;
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self setShoppingBagforSessionId:[sessionSettings sessionId] success:^(NSString *succString) {
        
        
        if ([succString isEqualToString:@"TRUE"]) {
         
            [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
    
    NSString *uniqueSku = [[[self bagItemsArray] objectAtIndex:indexPath.row] sku];
    
    Item *item = [Item getItemforSku:uniqueSku fromManagedObjectContext:[self managedObjectContext]];
    
    [cell.itemImageView setImageWithURL:[BTRItemFetcher
                                         URLforItemImageForSku:uniqueSku]
                       placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    
    cell = [self configureCell:cell forBagItem:[self.bagItemsArray objectAtIndex:indexPath.row] andItem:item];
    
    cell.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        
        [[self.bagItemsArray objectAtIndex:indexPath.row] setQuantity:[NSString stringWithFormat:@"%@", @(count)]];
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    
    return cell;
}


- (BTRBagTableViewCell *)configureCell:(BTRBagTableViewCell *)cell forBagItem:(BagItem *)bagItem andItem:(Item *)item {
    
    cell.brandLabel.text = [item brand];
    cell.priceLabel.text =  [BTRViewUtility priceStringfromNumber:[item salePrice]];
    cell.itemLabel.text = [item shortItemDescription];
    cell.sizeLabel.text = [NSString stringWithFormat:@"Size: %@", [bagItem  variant]];
    [cell.stepper setValue:[[bagItem quantity] floatValue]];
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


- (void)setShoppingBagforSessionId:(NSString *)sessionId
                           success:(void (^)(id  responseObject)) success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableArray *params =[[NSMutableArray alloc] init];
    
    for (BagItem *bagItem in [self bagItemsArray])
    {
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
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager POST:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforSetBag]]
       parameters:(NSDictionary *)params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              
              NSArray *bagJsonArray = entitiesPropertyList[@"bag"][@"reserved"];
              NSDate *serverTime = [NSDate date];
              
              [self.bagItemsArray removeAllObjects];
              [self.bagItemsArray addObjectsFromArray:[BagItem loadBagItemsfromAppServerArray:bagJsonArray withServerDateTime:serverTime intoManagedObjectContext:self.managedObjectContext]];
              [self.beyondTheRackDocument saveToURL:self.beyondTheRackDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
 
              BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
              [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
        
              success(@"TRUE");
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              failure(operation, error);
              
          }];
}


@end










