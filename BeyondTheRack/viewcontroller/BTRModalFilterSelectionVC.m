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

@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *selectedOptionsArray;

@end

@implementation BTRModalFilterSelectionVC



- (NSMutableArray *)optionsArray {
    
    if (!_optionsArray) _optionsArray = [[NSMutableArray alloc] init];
    return _optionsArray;
}



- (NSMutableArray *)selectedOptionsArray {
    
    if (!_selectedOptionsArray) _selectedOptionsArray = [[NSMutableArray alloc] init];
    return _selectedOptionsArray;
}



- (void)initOptionsArray {

    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if ([self.headerTitle isEqualToString:PRICE_TITLE])
        [self.optionsArray setArray:[sharedFacetHandler getPriceFiltersForDisplay]];
    
    if ([self.headerTitle isEqualToString:CATEGORY_TITLE])
        [self.optionsArray setArray:[sharedFacetHandler getCategoryFiltersForDisplay]];
    
    if ([self.headerTitle isEqualToString:BRAND_TITLE])
        [self.optionsArray setArray:[sharedFacetHandler getBrandFiltersForDisplay]];
    
    if ([self.headerTitle isEqualToString:COLOR_TITLE])
        [self.optionsArray setArray:[sharedFacetHandler getColorFiltersForDisplay]];
    
    if ([self.headerTitle isEqualToString:SIZE_TITLE])
        [self.optionsArray setArray:[sharedFacetHandler getSizeFiltersForDisplay]];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self initOptionsArray];
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:[BTRItemFetcher contentTypeForSearchQuery]];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withFacetString:facetsString andPageNumber:0]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                              options:0
                                                                                error:NULL];
         
         BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
         [sharedFacetsHandler updateFacetsFromResponseDictionary:entitiesPropertyList];
         
         
         NSLog(@"second update: %@", [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withFacetString:facetsString andPageNumber:0]]);
         success(entitiesPropertyList);
         
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
    [self performSegueWithIdentifier:@"unwindToBTRSearchFilterTVC" sender:self];

}

- (IBAction)selectTapped:(UIButton *)sender {
    
    /*
     
     perform the search REST query with chosen facets and pass back the new filters and the query result
    
     */
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument]
                  forSearchQuery:[sharedFacetHandler searchString]
                withFacetsString:[self facetsQueryString]
                         success:^(NSDictionary *responseDictionary) {
                             
                             [self dismissViewControllerAnimated:YES completion:NULL];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             
                         }];
}


- (NSString *)facetsQueryString {
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if ([self.headerTitle isEqualToString:PRICE_TITLE])
        [sharedFacetHandler setPriceSelectionWithPriceString:[self.selectedOptionsArray objectAtIndex:0]];
        
    if ([self.headerTitle isEqualToString:CATEGORY_TITLE])
        [sharedFacetHandler setCategorySelectionWithCategoryString:[self.selectedOptionsArray objectAtIndex:0]];

    if ([self.headerTitle isEqualToString:BRAND_TITLE])
        [sharedFacetHandler setSelectedBrandsWithArray:[self selectedOptionsArray]];
    
    if ([self.headerTitle isEqualToString:COLOR_TITLE])
        [sharedFacetHandler setSelectedColorsWithArray:[self selectedOptionsArray]];

    if ([self.headerTitle isEqualToString:SIZE_TITLE])
        [sharedFacetHandler setSelectedSizesWithArray:[self selectedOptionsArray]];
    
    return [sharedFacetHandler getFacetStringForRESTfulRequest];
}


@end












