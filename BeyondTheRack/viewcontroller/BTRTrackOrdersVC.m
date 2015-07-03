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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}




#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 161;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    
    NSArray *allKeysArray = self.itemsDictionary.allKeys;
    
    NSInteger tempIndex = 0;
    
    if ([allKeysArray count] != 0) {
        
        for (NSString *key in allKeysArray) {
            
            NSArray *tempArray = [[self itemsDictionary] objectForKey:key];
            
            if (section == tempIndex)
                return [tempArray count];
            
            tempIndex++;
        }
    }
    
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"OrderItemCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return 150.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];

    view = [self configureFirstRowHeaderforView:view withTableView:tableView forSection:section];
    view = [self configureSecondRowHeaderforView:view withTableView:tableView forSection:section];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.60]];

    return view;
}


- (UIView *)configureFirstRowHeaderforView:(UIView *)view withTableView:(UITableView *)tableView forSection:(NSInteger)section {
 
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
    [orderNoValueLabel setText:[[[self headersArray] objectAtIndex:section] orderId]];
    [view addSubview:orderNoValueLabel];
    [orderNoValueLabel sizeToFit];
    
    xPadding = mainWdith - [self getExpectedWidthforString:orderDateString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderDateString] + xPadding;
    UILabel *orderDateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderDateString], labelHeight)];
    [orderDateValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [orderDateValueLabel setText:[self getMonthDayStringfromDateString:[[[self headersArray] objectAtIndex:section] orderDate]]];
    [view addSubview:orderDateValueLabel];
    [orderDateValueLabel sizeToFit];

    UILabel *orderYearValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion + 20, [self getExpectedWidthforString:orderDateString], labelHeight)];
    [orderYearValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [orderYearValueLabel setText:[self getYearStringfromDateString:[[[self headersArray] objectAtIndex:section] orderDate]]];
    [view addSubview:orderYearValueLabel];
    [orderYearValueLabel sizeToFit];
    
    xPadding = mainWdith - [self getExpectedWidthforString:orderSubTotalString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderSubTotalString] + xPadding;
    UILabel *subtotalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderSubTotalString], labelHeight)];
    [subtotalValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [subtotalValueLabel setText:[BTRViewUtility priceStringfromString:[[[self headersArray] objectAtIndex:section] subtotal]]];
    [view addSubview:subtotalValueLabel];
    [subtotalValueLabel sizeToFit];
    
    xPadding = mainWdith - [self getExpectedWidthforString:taxString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:taxString] + xPadding;
    UILabel *taxesValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:taxString], labelHeight)];
    [taxesValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [taxesValueLabel setText:[BTRViewUtility priceStringfromString:[[[self headersArray] objectAtIndex:section] taxes]]];
    [view addSubview:taxesValueLabel];
    [taxesValueLabel sizeToFit];
   
    return view;
}


- (NSString *)getMonthDayStringfromDateString:(NSDate *)myDate {

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *monthsArray = [dateFormatter monthSymbols];
    
    NSString *stringDate = [NSString stringWithFormat:@"%@ %ld,", [monthsArray objectAtIndex:month], (long)day];
    
    return stringDate;
}


- (NSString *)getYearStringfromDateString:(NSDate *)myDate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *stringDate = [NSString stringWithFormat:@"%ld", (long)[components year]];
    
    return stringDate;
}

- (CGFloat)getExpectedWidthforString:(NSString *)stringValue {
    
    UILabel *templateLabel = [[UILabel alloc] init];
    [templateLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:14]];
    [templateLabel sizeToFit];
    CGSize textSize = [[templateLabel text] sizeWithAttributes:@{NSFontAttributeName:[templateLabel font]}];
    
    return textSize.width;
}

- (UIView *)configureSecondRowHeaderforView:(UIView *)view withTableView:(UITableView *)tableView forSection:(NSInteger)section {
    
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
    [shippingValueLabel setText:[BTRViewUtility priceStringfromString:[[[self headersArray] objectAtIndex:section] shipping]]];
    [view addSubview:shippingValueLabel];
    [shippingValueLabel sizeToFit];
    
    secondRowXPosition += [self getExpectedWidthforString:creditsString] + xPadding;
    UILabel *creditsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:creditsString], labelHeight)];
    [creditsValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [creditsValueLabel setText:[BTRViewUtility priceStringfromString:[[[self headersArray] objectAtIndex:section] credits]]];
    [view addSubview:creditsValueLabel];
    [creditsValueLabel sizeToFit];
    
    secondRowXPosition += [self getExpectedWidthforString:totalString] + xPadding;
    UILabel *totalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:totalString], labelHeight)];
    [totalValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [totalValueLabel setText:[BTRViewUtility priceStringfromString:[[[self headersArray] objectAtIndex:section] total]]];
    [view addSubview:totalValueLabel];
    [totalValueLabel sizeToFit];
    
    return view;
}







@end



















