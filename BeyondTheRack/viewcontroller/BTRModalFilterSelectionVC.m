//
//  BTRModalFilterSelectionVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRModalFilterSelectionVC.h"

#import "Item+AppServer.h"
#import "BTRItemFetcher.h"



@interface BTRModalFilterSelectionVC ()

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation BTRModalFilterSelectionVC


- (NSMutableArray *)itemsArray {
    
    if (!_itemsArray) _itemsArray = [[NSMutableArray alloc] init];
    return _itemsArray;
}

- (NSMutableArray *)selectedOptionsArray {
    
    if (!_selectedOptionsArray) _selectedOptionsArray = [[NSMutableArray alloc] init];
    return _selectedOptionsArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupDocument];
    self.titleLabel.text = [NSString stringWithFormat:@"Select %@", [self headerTitle]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [[self optionsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModalFilterSelectionCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.optionsArray objectAtIndex:indexPath.row];
    
    if ([self isOptionSelected:[self.optionsArray objectAtIndex:indexPath.row]] >= 0){
        
        cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {

        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}



- (int)isOptionSelected:(NSString *)optionString
{
    if ([self.selectedOptionsArray count] == 0)
        return -1;
    
    for(NSString *item in  self.selectedOptionsArray) {
        
        if([optionString isEqualToString:item]) {
            
            return 1;
            break;
        }
    }
    
    return -1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
        [self.selectedOptionsArray addObject:[[cell textLabel] text]];
        
    } else {
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;

        [self.selectedOptionsArray removeObject:[[cell textLabel] text]];
    }
}



#pragma mark - Load Results RESTful


- (void)setupDocument {
    
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}

- (void)fetchItemsIntoDocument:(UIManagedDocument *)document forSearchQuery:(NSString *)searchQuery
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{

    [[self itemsArray] removeAllObjects];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:[BTRUtility contentTypeForSearchQuery]]; // TODO: change text/html to application/json AFTER backend supports it in production
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery andPageNumber:0]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                              options:0
                                                                                error:NULL];
         
         self.freshFacetsDictionary = [BTRUtility getFacetsDictionaryFromResponse:entitiesPropertyList];
         NSMutableArray * arrayToPass = [BTRUtility getItemDataArrayFromResponse:entitiesPropertyList];
         
         if (![[NSString stringWithFormat:@"%@",arrayToPass] isEqualToString:@"0"]) {
             
             if ([arrayToPass count]) {
                 
                 [self.itemsArray addObjectsFromArray:[Item loadItemsFromAppServerArray:arrayToPass intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext]];
                 [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
             }
         }
         
         success(arrayToPass);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}



#pragma mark - Navigation


- (IBAction)clearTapped:(UIButton *)sender {
    
    /*
     
     clear filter selections and dismiss vc
    
     */
    
    [self.selectedOptionsArray removeAllObjects];
    [self performSegueWithIdentifier:@"UnwindToBTRSearchFilterSegueIdentifier" sender:self];

}

- (IBAction)selectTapped:(UIButton *)sender {
    
    /*
     
     perform the search REST query with chosen facets and pass back the new filters and the query result
    
     */
    
    [self.itemsArray removeAllObjects];
    [self fetchItemsIntoDocument:[self beyondTheRackDocument] forSearchQuery:@"ted" success:^(NSMutableArray *itemsArray) {
    
        
        if ([self.modalDelegate respondsToSelector:@selector(modalFilterSelectionVCDidEnd:withTitle:)]) {
            [self.modalDelegate modalFilterSelectionVCDidEnd:[self selectedOptionsArray] withTitle:[self headerTitle]];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}





@end












