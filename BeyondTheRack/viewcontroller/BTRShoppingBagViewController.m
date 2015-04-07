//
//  BTRShoppingBagViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-24.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRShoppingBagViewController.h"
#import "BTRApprovePurchaseViewController.h"

#import "BagItem+AppServer.h"
#import "BTRBagFetcher.h"

@interface BTRShoppingBagViewController ()


@property (strong, nonatomic) NSString *sessionId;
@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


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
    
    
    /*
    [self getCartServerCallforSessionId:[self sessionId] success:^(NSString *succString) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];*/

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self bagItemsArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingBagCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShoppingBagCellIdentifier"];
    }
    
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 150)];
    imv.image=[UIImage imageNamed:@"itemInBag.png"];
    [cell.contentView addSubview:imv];
    
    return cell;
}

- (IBAction)tappedCheckout:(UIButton *)sender {
    
    
    


}



- (IBAction)tappedClose:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)unwindToShoppingBagScene:(UIStoryboardSegue *)unwindSegue
{
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/






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
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *sessionIdString = [self sessionId];
    [manager.requestSerializer setValue:sessionIdString forHTTPHeaderField:@"SESSION"];
    
 
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBag]]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              
              NSLog(@"redded: %@", entitiesPropertyList);
              
              success(@"TRUE");
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              NSLog(@"errtr: %@", error);
              failure(operation, error);
              
          }];
}








@end

























