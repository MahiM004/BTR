//
//  BTRTrackOrdersVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-26.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRTrackOrdersVC.h"
#import "BTROrderHistoryFetcher.h"
#import "OrderHistoryBag+AppServer.h"
#import "OrderHistoryItem+AppServer.h"
#import "BTRTrackOrdersItemCell.h"
#import "BTRItemFetcher.h"
#import "UIImageView+AFNetworking.h"

@interface BTRTrackOrdersVC ()

@property (strong, nonatomic) NSArray *monthsArray;

@end


@implementation BTRTrackOrdersVC

- (NSMutableArray *)headersArray {
    if (!_headersArray) _headersArray = [[NSMutableArray alloc] init];
    return _headersArray;
}


- (NSMutableDictionary *)itemsDictionary {
    if (!_itemsDictionary) _itemsDictionary = [[NSMutableDictionary alloc] init];
    return _itemsDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BTRRefreshManager sharedInstance]setTopViewController:self];
    NSArray * sorted = [self.headersArray sortedArrayUsingComparator:^NSComparisonResult(OrderHistoryBag *obj1, OrderHistoryBag *obj2) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *obj1date = [formatter dateFromString:obj1.orderDateString];
        NSDate *obj2date = [formatter dateFromString:obj2.orderDateString];
        return [obj2date compare:obj1date];
    }];
    self.headersArray = [[NSMutableArray alloc]initWithArray:sorted];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *orderId = [[self.headersArray objectAtIndex:section]orderId];
    NSArray *tempArray = [[self itemsDictionary] objectForKey:orderId];
    return [tempArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.headersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OrderItemCellIdentifier";
    BTRTrackOrdersItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[BTRTrackOrdersItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSString *orderId = [[self.headersArray objectAtIndex:indexPath.section]orderId];
    NSArray *tempArray = [[self itemsDictionary] objectForKey:orderId];
    OrderHistoryItem *orderItem = [tempArray objectAtIndex:[indexPath row]];
    [cell.productImageView setImageWithURL:[BTRItemFetcher
                                            URLforItemImageForSku:[orderItem skuNumber]]
                          placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    
    cell = [self configureCell:cell forOrderItem:orderItem];
    return cell;
}

- (BTRTrackOrdersItemCell *)configureCell:(BTRTrackOrdersItemCell *)cell forOrderItem:(OrderHistoryItem *)orderItem {
    [[cell descriptionLabel] setText:[orderItem shortDescription]];
    [[cell sizeLabel] setText:[orderItem variant]];
    [[cell priceLabel] setText:[NSString stringWithFormat:@"$%.2f",[[orderItem price] floatValue]]];
    [[cell skuLabel] setText:[orderItem skuNumber]];
    [[cell statusLabel] setText:[orderItem status]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    OrderHistoryBag *orderBag = [[self headersArray] objectAtIndex:section];
    if (orderBag) {
        view = [self configureFirstRowHeaderforView:view withTableView:tableView forOrderBag:orderBag];
        view = [self configureSecondRowHeaderforView:view withTableView:tableView forOrderBag:orderBag];
    }
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.60]];
    return view;
}

- (UIView *)configureFirstRowHeaderforView:(UIView *)view withTableView:(UITableView *)tableView forOrderBag:(OrderHistoryBag *)orderBag {
    CGFloat mainWdith = tableView.frame.size.width/4;
    CGFloat labelHeight = 18;
    CGFloat xPadding = 0;

    CGFloat firstRowYPostion = 20;
    CGFloat firstRowXPosition = tableView.frame.size.width/15;
    
    NSString *titleStringFont = @"AvenirNextCondensed-Medium";
    NSString *valueStringFont = @"AvenirNextCondensed-Regular";
    
    NSString *orderNoString = @"ORDER NO";
    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderNoString], labelHeight)];
    [orderNoLabel setFont:[UIFont fontWithName:titleStringFont size:14]];
    [orderNoLabel setText:orderNoString];
    [view addSubview:orderNoLabel];
    [orderNoLabel sizeToFit];
  
    NSString *orderDateString = @"ORDER DATE";
    xPadding = mainWdith - [self getExpectedWidthforString:orderDateString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderDateString] + xPadding;
    UILabel *orderDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderDateString], labelHeight)];
    [orderDateLabel setFont:[UIFont fontWithName:titleStringFont size:14]];
    [orderDateLabel setText:orderDateString];
    [view addSubview:orderDateLabel];
    [orderDateLabel sizeToFit];
    
    NSString *orderSubTotalString = @"SUB TOTAL";
    xPadding = mainWdith - [self getExpectedWidthforString:orderSubTotalString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderSubTotalString] + xPadding;
    UILabel *subtotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderSubTotalString], labelHeight)];
    [subtotalLabel setFont:[UIFont fontWithName:titleStringFont size:14]];
    [subtotalLabel setText:orderSubTotalString];
    [view addSubview:subtotalLabel];
    [subtotalLabel sizeToFit];
    
    NSString *taxString = @"TAXES";
    xPadding = mainWdith - [self getExpectedWidthforString:taxString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:taxString] + xPadding;
    UILabel *taxesLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:taxString], labelHeight)];
    [taxesLabel setFont:[UIFont fontWithName:titleStringFont size:14]];
    [taxesLabel setText:taxString];
    [view addSubview:taxesLabel];
    [taxesLabel sizeToFit];
    
    firstRowYPostion = 40;
    firstRowXPosition = tableView.frame.size.width/15;
    
    UILabel *orderNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderNoString], labelHeight)];
    [orderNoValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [orderNoValueLabel setText:[orderBag orderId]];
    [view addSubview:orderNoValueLabel];
    [orderNoValueLabel sizeToFit];
    
    xPadding = mainWdith - [self getExpectedWidthforString:orderDateString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderDateString] + xPadding;
    UILabel *orderDateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderDateString], labelHeight)];
    [orderDateValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    NSString *monthDayString = [BTRViewUtility formatDateStringToStringforMonthDayDisplay:[orderBag orderDateString]];
    [orderDateValueLabel setText:[NSString stringWithFormat:@"%@,", monthDayString]];
    [view addSubview:orderDateValueLabel];
    [orderDateValueLabel sizeToFit];

    UILabel *orderYearValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion + 20, [self getExpectedWidthforString:orderDateString], labelHeight)];
    [orderYearValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    NSString *yearString = [BTRViewUtility formatDateStringToStringforYearDisplay:[orderBag orderDateString]];
    [orderYearValueLabel setText:yearString];
    [view addSubview:orderYearValueLabel];
    [orderYearValueLabel sizeToFit];
    
    xPadding = mainWdith - [self getExpectedWidthforString:orderSubTotalString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderSubTotalString] + xPadding;
    UILabel *subtotalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderSubTotalString], labelHeight)];
    [subtotalValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [subtotalValueLabel setText:[BTRViewUtility priceStringfromString:[orderBag subtotal]]];
    [view addSubview:subtotalValueLabel];
    [subtotalValueLabel sizeToFit];
    
    xPadding = mainWdith - [self getExpectedWidthforString:taxString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:taxString] + xPadding;
    UILabel *taxesValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:taxString], labelHeight)];
    [taxesValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [taxesValueLabel setText:[BTRViewUtility priceStringfromString:[orderBag taxes]]];
    [view addSubview:taxesValueLabel];
    [taxesValueLabel sizeToFit];
   
    return view;
}


- (CGFloat)getExpectedWidthforString:(NSString *)stringValue {
    UILabel *templateLabel = [[UILabel alloc] init];
    [templateLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:14]];
    [templateLabel sizeToFit];
    CGSize textSize = [[templateLabel text] sizeWithAttributes:@{NSFontAttributeName:[templateLabel font]}];
    
    return textSize.width;
}


- (UIView *)configureSecondRowHeaderforView:(UIView *)view withTableView:(UITableView *)tableView forOrderBag:(OrderHistoryBag *)orderBag {
    CGFloat mainWdith = tableView.frame.size.width/4;
    CGFloat labelHeight = 18;
    CGFloat xPadding = 0;
    
    NSString *titleStringFont = @"AvenirNextCondensed-Medium";
    NSString *valueStringFont = @"AvenirNextCondensed-Regular";
    
    NSInteger seondRowYPostion = 90;
    NSInteger secondRowXPosition = tableView.frame.size.width/15;

    NSString *shippingString = @"SHIPPING";
    UILabel *shippingLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:shippingString], labelHeight)];
    [shippingLabel setFont:[UIFont fontWithName:titleStringFont size:14]];
    [shippingLabel setText:@"SHIPPING"];
    [view addSubview:shippingLabel];
    [shippingLabel sizeToFit];

    NSString *creditsString = @"CREDITS";
    xPadding = mainWdith - [self getExpectedWidthforString:creditsString];
    secondRowXPosition += [self getExpectedWidthforString:creditsString] + xPadding;
    UILabel *creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:creditsString], labelHeight)];
    [creditsLabel setFont:[UIFont fontWithName:titleStringFont size:14]];
    [creditsLabel setText:@"CREDITS"];
    [view addSubview:creditsLabel];
    [creditsLabel sizeToFit];
    
    NSString *totalString = @"TOTAL";
    xPadding = mainWdith - [self getExpectedWidthforString:creditsString];
    secondRowXPosition += [self getExpectedWidthforString:creditsString] + xPadding;
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:totalString], labelHeight)];
    [totalLabel setFont:[UIFont fontWithName:titleStringFont size:14]];
    [totalLabel setText:totalString];
    [view addSubview:totalLabel];
    [totalLabel sizeToFit];
    
    seondRowYPostion = 110;
    secondRowXPosition = tableView.frame.size.width/15;

    UILabel *shippingValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:shippingString], labelHeight)];
    [shippingValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [shippingValueLabel setText:[BTRViewUtility priceStringfromString:[orderBag shipping]]];
    [view addSubview:shippingValueLabel];
    [shippingValueLabel sizeToFit];
    
    secondRowXPosition += [self getExpectedWidthforString:creditsString] + xPadding;
    UILabel *creditsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:creditsString], labelHeight)];
    [creditsValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [creditsValueLabel setText:[BTRViewUtility priceStringfromString:[orderBag credits]]];
    [view addSubview:creditsValueLabel];
    [creditsValueLabel sizeToFit];
    
    secondRowXPosition += [self getExpectedWidthforString:totalString] + xPadding;
    UILabel *totalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:totalString], labelHeight)];
    [totalValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [totalValueLabel setText:[BTRViewUtility priceStringfromString:[orderBag total]]];
    [view addSubview:totalValueLabel];
    [totalValueLabel sizeToFit];
    
    return view;
}

- (IBAction)backbuttonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end



















