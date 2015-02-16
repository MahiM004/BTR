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
#import "BTRFacetsHandler.h"

#import "BTRSearchFilterTVC.h"



@interface BTRModalFilterSelectionVC () {
    int selectedIndex;
}

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
    
    selectedIndex = -1;
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
    
    if ([self isMultiSelect]) {
    
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            
            cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self.selectedOptionsArray addObject:[[cell textLabel] text]];
            
        } else {
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [self.selectedOptionsArray removeObject:[[cell textLabel] text]];
        }
        
    } else if (![self isMultiSelect]) {
        
        selectedIndex = (int)indexPath.row;
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            
            cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        [self.selectedOptionsArray removeLastObject];
        [self.selectedOptionsArray addObject:cell.textLabel.text];
        [self.tableView reloadData];
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
              withFacetsString:(NSString *)facetsString
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{

    [[self itemsArray] removeAllObjects];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:[BTRItemFetcher contentTypeForSearchQuery]]; // TODO: change text/html to application/json AFTER backend supports it in production
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withFacetString:facetsString andPageNumber:0]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                              options:0
                                                                                error:NULL];
         
         success(responseDictionary);
         
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
    
    
 
    // construct and take affect from  pass new response
    
    
    [self.itemsArray removeAllObjects];
    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument]
                  forSearchQuery:[self searchString]
                withFacetsString:[self facetsQueryString]
                         success:^(NSDictionary *responseDictionary) {
    
        // pass the repsonseDictionary as well
        if ([self.modalDelegate respondsToSelector:@selector(modalFilterSelectionVCDidEnd:withTitle:)]) {
            [self.modalDelegate modalFilterSelectionVCDidEnd:[self selectedOptionsArray] withTitle:[self headerTitle]];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (NSString *)facetsQueryString {
    
    NSMutableArray *facetOptionsArray = [[NSMutableArray alloc] init];
    
    if ([self.headerTitle isEqualToString:PRICE_TITLE])
      facetOptionsArray= [BTRFacetsHandler getFacetOptionsFromDisplaySelectedPrices:[self selectedOptionsArray] fromSelectedCategories:[self.chosenFacetsArray objectAtIndex:1] fromSelectedBrand:[self.chosenFacetsArray objectAtIndex:2] fromSelectedColors:[self.chosenFacetsArray objectAtIndex:3] fromSelectedSizes:[self.chosenFacetsArray objectAtIndex:4]];
    
    if ([self.headerTitle isEqualToString:CATEGORY_TITLE])
        facetOptionsArray= [BTRFacetsHandler getFacetOptionsFromDisplaySelectedPrices:[self.chosenFacetsArray objectAtIndex:0] fromSelectedCategories:[self selectedOptionsArray] fromSelectedBrand:[self.chosenFacetsArray objectAtIndex:2] fromSelectedColors:[self.chosenFacetsArray objectAtIndex:3] fromSelectedSizes:[self.chosenFacetsArray objectAtIndex:4]];

    if ([self.headerTitle isEqualToString:BRAND_TITLE])
        facetOptionsArray= [BTRFacetsHandler getFacetOptionsFromDisplaySelectedPrices:[self.chosenFacetsArray objectAtIndex:0] fromSelectedCategories:[self.chosenFacetsArray objectAtIndex:1] fromSelectedBrand:[self selectedOptionsArray] fromSelectedColors:[self.chosenFacetsArray objectAtIndex:3] fromSelectedSizes:[self.chosenFacetsArray objectAtIndex:4]];

    if ([self.headerTitle isEqualToString:COLOR_TITLE])
        facetOptionsArray= [BTRFacetsHandler getFacetOptionsFromDisplaySelectedPrices:[self.chosenFacetsArray objectAtIndex:0] fromSelectedCategories:[self.chosenFacetsArray objectAtIndex:1] fromSelectedBrand:[self.chosenFacetsArray objectAtIndex:2] fromSelectedColors:[self selectedOptionsArray] fromSelectedSizes:[self.chosenFacetsArray objectAtIndex:4]];

    if ([self.headerTitle isEqualToString:SIZE_TITLE])
        facetOptionsArray= [BTRFacetsHandler getFacetOptionsFromDisplaySelectedPrices:[self.chosenFacetsArray objectAtIndex:0] fromSelectedCategories:[self.chosenFacetsArray objectAtIndex:1] fromSelectedBrand:[self.chosenFacetsArray objectAtIndex:2] fromSelectedColors:[self.chosenFacetsArray objectAtIndex:3] fromSelectedSizes:[self selectedOptionsArray]];

    return [BTRFacetsHandler getFacetStringForRESTWithChosenFacetsArray:facetOptionsArray withSortOption:0];
}



@end












