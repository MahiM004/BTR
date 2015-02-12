//
//  BTRSearchViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchViewController.h"
#import "BTRItemShowcaseTableViewCell.h"
#import "BTRRefineResultsViewController.h"


#import "Item+AppServer.h"
#import "BTRItemFetcher.h"



@interface BTRSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) NSDictionary *facetsDictionary;
@property (strong, nonatomic) NSString *searchString;
@property (nonatomic) BOOL oddNumberOfResults;

@end


@implementation BTRSearchViewController

@synthesize searchBar;
@synthesize oddNumberOfResults;

- (NSDictionary *)facetsDictionary {
    
    if (!_facetsDictionary) _facetsDictionary = [[NSDictionary alloc] init];
    return _facetsDictionary;
}


- (NSMutableArray *)itemArray{

    if (!_itemArray) _itemArray = [[NSMutableArray alloc] init];
    return _itemArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupDocument];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    
    [self.view addGestureRecognizer:tap];
    
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];

    /*
     * Getting rid of the magnifying glass in the text area
     */
    //[searchBar setImage:[UIImage new] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //[[UISearchBar appearance] setPositionAdjustment:UIOffsetMake(-10, 0) forSearchBarIcon:UISearchBarIconSearch];
    
    /*
     * Changing the background color of the SearchBar Text area
     */
    CGSize size = CGSizeMake(30, 30);
    // create context with transparent background
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,30,30)
                                cornerRadius:5.0] addClip];
    [[UIColor colorWithRed:112.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:0.4] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];

    
    
    CGSize size2 = CGSizeMake(1, 1);
    // create context with transparent background
    UIGraphicsBeginImageContextWithOptions(size2, NO, 1);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,1,1)
                                cornerRadius:5.0] addClip];
    [[UIColor colorWithRed:112.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:0.4] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //UIImage *imgClear = [UIImage imageNamed:@"clear"];
    //[self.searchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [self.searchBar setImage:image2 forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    [self.searchBar setImage:image2 forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
}

- (void)clearResults {
    
    self.searchString = @"";
    oddNumberOfResults = NO;
    [self.itemArray removeAllObjects];
}

- (void)dismissKeyboard {

    [searchBar resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (![self.itemArray count])
        [self.searchBar becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)viewWillDisappear:(BOOL)animated {

    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can recreated.
}


#pragma mark Content Filtering

/*
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    [self.filteredItemArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    _filteredItemArray = [NSMutableArray arrayWithArray:[itemArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
*/


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.searchString = [self.searchBar text];
    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument] forSearchQuery:[self searchString]];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    
    
    //[self searchBar:searchBar activate:YES];
//}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if ([self.itemArray  count] > 0) {
        
        self.filterIconImageView.hidden = NO;
        self.filterButton.enabled = YES;

        
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^ {

                             [self.searchBar setFrame:CGRectMake(34,1,200,44)];
                             
                         }completion:^(BOOL finished) {
                             
                         }];
    } else {
   
        self.filterIconImageView.hidden = YES;
        self.filterButton.enabled = NO;
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^ {

                             [self.searchBar setFrame:CGRectMake(40,1,234,44)];
                             
                         }completion:^(BOOL finished) {
                             
                         }];
    }
    
    NSInteger tableSize = (NSInteger)((int)[self.itemArray count]/ (int)2);
    
    
    if ([self.itemArray count] % 2 && [self.itemArray count] > 0)
    {
      
        oddNumberOfResults = YES;
        return tableSize + 1;
    }
    
    return tableSize;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCellIdentifier";
    BTRItemShowcaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ( cell == nil ) {
        
        cell = [[BTRItemShowcaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Item *letftItem = [self.itemArray objectAtIndex:2*(indexPath.row)];
    
    if ([letftItem sku]) {
        
        cell = [self configureLeftViewForCell:cell withItem:letftItem];
    
    } else {
        
        [self fetchItemsIntoDocument:[self beyondTheRackDocument] forSearchQuery:[self.searchBar text]];

    }

    if (!(oddNumberOfResults && indexPath.row == [self.tableView numberOfRowsInSection:0] - 1)) {
        
        Item *rightItem = [self.itemArray objectAtIndex:2*(indexPath.row) + 1];
        
        if ([rightItem sku]) {
        
            cell.rightImageView.hidden = FALSE;
            cell.rightDetailView.hidden = FALSE;
            cell = [self configureRightViewForCell:cell withItem:rightItem];
    
        } else {
            
            [self fetchItemsIntoDocument:[self beyondTheRackDocument] forSearchQuery:[self.searchBar text]];
        }
        
    } else if (oddNumberOfResults && indexPath.row == [self.tableView numberOfRowsInSection:0] - 1) {
        
        cell.rightImageView.hidden = TRUE;
        cell.rightDetailView.hidden = TRUE;
    }
    
    return cell;
}


- (BTRItemShowcaseTableViewCell *)configureLeftViewForCell:(BTRItemShowcaseTableViewCell *)cell withItem:(Item *)letftItem {
    
    [cell.leftImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[letftItem sku]] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    [cell.leftBrand setText:[letftItem brand]];
    [cell.leftDescription setText:[letftItem shortItemDescription]];
    [cell.leftPrice setText:[NSString stringWithFormat:@"$%@",[letftItem priceCAD]]];
    
    [cell.leftCrossedOffPrice setAttributedText:[BTRUtility crossedOffTextFrom:[NSString stringWithFormat:@"$%@",[letftItem retailCAD]]]];
    
    return cell;
}

- (BTRItemShowcaseTableViewCell *)configureRightViewForCell:(BTRItemShowcaseTableViewCell *)cell withItem:(Item *)rightItem {
    
    [cell.rightImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[rightItem sku]] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    [cell.rightBrand setText:[rightItem brand]];
    [cell.rightDescription setText:[rightItem shortItemDescription]];
    [cell.rightPrice setText:[NSString stringWithFormat:@"$%@",[rightItem priceCAD]]];
    
    [cell.rightCrossedOffPrice setAttributedText:[BTRUtility crossedOffTextFrom:[NSString stringWithFormat:@"$%@",[rightItem retailCAD]]]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self performSegueWithIdentifier:@"ItemDetailSegue" sender:tableView];
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cell Tapped" message:[NSString stringWithFormat:@"Cell %ld tapped", (long)indexPath.row] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [alert show];*/
}


#pragma mark - Load Results RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}

- (void)fetchItemsIntoDocument:(UIManagedDocument *)document forSearchQuery:(NSString *)searchQuery
{
    [self clearResults];
    [self.tableView reloadData];

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
 
         self.facetsDictionary = [BTRUtility extractFacetsFromResponse:entitiesPropertyList];
         NSMutableArray * arrayToPass = [BTRUtility extractItemDataFromResponse:entitiesPropertyList];
         
         if (![[NSString stringWithFormat:@"%@",arrayToPass] isEqualToString:@"0"]) {
             
             if ([arrayToPass count]) {
                 
                 [self.itemArray addObjectsFromArray:[Item loadItemsFromAppServerArray:arrayToPass intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext]];
                 [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
             }
         }
         
         
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
     }];
    
}



#pragma mark - Navigation

- (IBAction)tappedShoppingBag:(UIButton *)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"BTRSearchFilterSegue"])
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UIGraphicsBeginImageContextWithOptions(screenSize, NO, [UIScreen mainScreen].scale);
        CGRect rec = CGRectMake(0, 0, screenSize.width, screenSize.height);
        [self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
        UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        BTRRefineResultsViewController *refineVC = [segue destinationViewController];

        refineVC.backgroundImage = screenShotImage;
        refineVC.facetsDictionary = [self facetsDictionary];
        refineVC.searchString = [self searchString];
        
    }
    

}

@end







