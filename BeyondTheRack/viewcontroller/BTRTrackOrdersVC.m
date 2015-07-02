//
//  BTRTrackOrdersVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-26.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRTrackOrdersVC.h"
#import "BTROrderHistoryFetcher.h"

@interface BTRTrackOrdersVC ()

@end

@implementation BTRTrackOrdersVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self fetchOrderHistoryforSessionId:[sessionSettings sessionId] success:^(NSString *successString) {
        
        [[self tableView] reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}



#pragma mark - Track Orders RESTful


- (void)fetchOrderHistoryforSessionId:(NSString *)sessionId
                          success:(void (^)(id  responseObject)) success
                          failure:(void (^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTROrderHistoryFetcher URLforOrderHistory]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                               options:0
                                                                                 error:NULL];
         if (entitiesPropertyList) {
             
             NSLog(@"---000- : %@", entitiesPropertyList);
             success(@"TRUE");
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}



#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 161;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    
    view = [self configureFirstRowHeaderforView:view andTableView:tableView];
    
    view = [self configureSecondRowHeaderforView:view andTableView:tableView];

    
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.60]];
    return view;
}


- (UIView *)configureFirstRowHeaderforView:(UIView *)view andTableView:(UITableView *)tableView {
 
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
    [orderNoValueLabel setText:orderNoString];
    [view addSubview:orderNoValueLabel];
    [orderNoValueLabel sizeToFit];
    
    xPadding = mainWdith - [self getExpectedWidthforString:orderDateString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderDateString] + xPadding;
    UILabel *orderDateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderDateString] , labelHeight)];
    [orderDateValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [orderDateValueLabel setText:orderDateString];
    [view addSubview:orderDateValueLabel];
    [orderDateValueLabel sizeToFit];

    xPadding = mainWdith - [self getExpectedWidthforString:orderSubTotalString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:orderSubTotalString] + xPadding;
    UILabel *subtotalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:orderSubTotalString] , labelHeight)];
    [subtotalValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [subtotalValueLabel setText:orderSubTotalString];
    [view addSubview:subtotalValueLabel];
    [subtotalValueLabel sizeToFit];

    xPadding = mainWdith - [self getExpectedWidthforString:taxString];
    firstRowXPosition = firstRowXPosition + [self getExpectedWidthforString:taxString] + xPadding;
    UILabel *taxesValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, [self getExpectedWidthforString:taxString], labelHeight)];
    [taxesValueLabel setFont:[UIFont fontWithName:valueStringFont size:14]];
    [taxesValueLabel setText:taxString];
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

- (UIView *)configureSecondRowHeaderforView:(UIView *)view andTableView:(UITableView *)tableView {
    
    CGFloat mainWdith = tableView.frame.size.width/4;
    CGFloat labelHeight = 18;
    CGFloat xPadding = 0;
    
    NSString *titleStringFont = @"AvenirNextCondensed-Medium";
    NSString *valueStringFont = @"AvenirNextCondensed-Regular";
    
    NSInteger seondRowYPostion = 90;
    NSInteger secondRowXPosition = tableView.frame.size.width/15;

    NSString *shippingString = @"SHIPPING";
    UILabel *shippingLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:shippingString], labelHeight)];
    [shippingLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:14]];
    [shippingLabel setText:@"SHIPPING"];
    [view addSubview:shippingLabel];
    [shippingLabel sizeToFit];

    NSString *creditsString = @"CREDITS";
    xPadding = mainWdith - [self getExpectedWidthforString:creditsString];
    secondRowXPosition += [self getExpectedWidthforString:creditsString] + xPadding;
    UILabel *creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:creditsString], labelHeight)];
    [creditsLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:14]];
    [creditsLabel setText:@"CREDITS"];
    [view addSubview:creditsLabel];
    [creditsLabel sizeToFit];
    
    NSString *totalString = @"TOTAL";
    xPadding = mainWdith - [self getExpectedWidthforString:creditsString];
    secondRowXPosition += [self getExpectedWidthforString:creditsString] + xPadding;
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:totalString], labelHeight)];
    [totalLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:14]];
    [totalLabel setText:totalString];
    [view addSubview:totalLabel];
    [totalLabel sizeToFit];
    
    seondRowYPostion = 110;
    secondRowXPosition = tableView.frame.size.width/15;

    UILabel *shippingValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:shippingString], labelHeight)];
    [shippingValueLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14]];
    [shippingValueLabel setText:shippingString];
    [view addSubview:shippingValueLabel];
    [shippingValueLabel sizeToFit];
    
    secondRowXPosition += [self getExpectedWidthforString:creditsString] + xPadding;
    UILabel *creditsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:creditsString], labelHeight)];
    [creditsValueLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14]];
    [creditsValueLabel setText:creditsString];
    [view addSubview:creditsValueLabel];
    [creditsValueLabel sizeToFit];
    
    secondRowXPosition += [self getExpectedWidthforString:totalString] + xPadding;
    UILabel *totalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowXPosition, seondRowYPostion, [self getExpectedWidthforString:totalString], labelHeight)];
    [totalValueLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14]];
    [totalValueLabel setText:totalString];
    [view addSubview:totalValueLabel];
    [totalValueLabel sizeToFit];
    
    return view;
}


@end



















