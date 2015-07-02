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
  
    return 160.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    NSInteger labelWidth = tableView.frame.size.width/4;
    NSInteger labelHeight = 18;
    NSInteger xPadding = tableView.frame.size.width/15;
    
    NSInteger firstRowYPostion = 15;
    NSInteger firstRowXPosition = 18;
    
    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, labelWidth, labelHeight)];
    [orderNoLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15]];
    [orderNoLabel setText:@"ORDER NO"];
    [view addSubview:orderNoLabel];
    [orderNoLabel sizeToFit];
    
    firstRowXPosition += orderNoLabel.frame.size.width + xPadding;
    UILabel *orderDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, labelWidth, labelHeight)];
    [orderDateLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15]];
    [orderDateLabel setText:@"ORDER DATE"];
    [view addSubview:orderDateLabel];
    [orderDateLabel sizeToFit];

    firstRowXPosition += orderDateLabel.frame.size.width + xPadding;
    UILabel *subtotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, labelWidth, labelHeight)];
    [subtotalLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15]];
    [subtotalLabel setText:@"SUB TOTAL"];
    [view addSubview:subtotalLabel];
    [subtotalLabel sizeToFit];

    firstRowXPosition +=subtotalLabel.frame.size.width + xPadding;
    UILabel *taxesLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowXPosition, firstRowYPostion, labelWidth, labelHeight)];
    [taxesLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15]];
    [taxesLabel setText:@"TAXES"];
    [view addSubview:taxesLabel];
    [taxesLabel sizeToFit];

    
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.40]];
    return view;
}



@end



















