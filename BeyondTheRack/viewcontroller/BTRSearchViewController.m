//
//  BTRSearchViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchViewController.h"
#import "BTRItemShowcaseTableViewCell.h"

#import "Item+AppServer.h"
#import "BTRItemFetcher.h"

@interface BTRSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *filteredItemArray;
@property (strong, nonatomic) NSMutableArray *itemArray;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end


@implementation BTRSearchViewController

@synthesize searchBar;

- (NSMutableArray *)itemArray{
    if (!_itemArray)
        _itemArray = [[NSMutableArray alloc] init];
    
    
    return _itemArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupDocument];
    
    self.view.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];

    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];

    /*
     * Getting rid of the magnifying glass in the text area
     */
    [searchBar setImage:[UIImage new] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setPositionAdjustment:UIOffsetMake(-10, 0) forSearchBarIcon:UISearchBarIconSearch];
    
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
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    
    // use some multithreading here
    [self.itemArray removeAllObjects];
    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument] forSearchQuery:[self.searchBar text]];
    
    
    //NSArray *results = self.itemArray;// = [SomeService doSearch:searchBar.text];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
   
    /*
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    [self.filteredItemArray removeAllObjects];
    [self.filteredItemArray addObjectsFromArray:results];*/
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    
    
    //[self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemArray count];//(NSInteger)([self.itemArray count]/2 +1);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SearchResultCellIdentifier";

    BTRItemShowcaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
    
    if ( cell == nil )
    {
        cell = [[BTRItemShowcaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];

    
   // [cell.leftImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[(Item *)[self.itemArray objectAtIndex:indexPath.row] sku]] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];


    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 240)];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTRItemFetcher URLforItemImageForSku:[(Item *)[self.itemArray objectAtIndex:indexPath.row] sku]]];
    
    __weak UIImageView *weakImageView = imageView;
    [imageView setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"neulogo.png"]
     
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  
                                  UIImageView *strongImageView = weakImageView; // make local strong reference to protect against race conditions
                                  if (!strongImageView) return;
                                  
                                  weakImageView.alpha = 0.3;
                                  weakImageView.image = image;
                                  
                                  [UIView animateWithDuration:0.5
                                                   animations:^{
                                                       weakImageView.alpha = 1;
                                                   }
                                   
                                                   completion:nil];
                                  
                              } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                  
                                //  weakImageView.image = [UIImage imageNamed:@"neulogo.png"];
                                  
                              }];
    
    [cell.leftView addSubview:imageView];
    //cell.leftImageView = imageView;
    
    
    
    
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSArray * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
         
         self.itemArray = [Item loadItemsFromAppServerArray:entitiesPropertyList intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext];
         
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
         
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


/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end





/*
 NSString *imageName = [NSString stringWithFormat:@"profilePicture%@.PNG", [friendRelation friendProfileId]];
 UIImage *img = [SVJMyUtility imageWithFilename:imageName];
 
 if (img == nil)
 {
 */

/*
 NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTRItemFetcher URLforItemWithSku:[(Item *)[self.itemArray objectAtIndex:indexPath.row] sku]]];
 AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
 requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
 [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 cell.leftImageView.image = responseObject;
 //[SVJMyUtility saveImage:responseObject withFilename:imageName];
 
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 }];
 [requestOperation start];
 */
/*
 }
 else {
 cell.profileImage.image = img;
 }
 
 cell.leftImageView = [SVJMyUtility roundTheCornersForImageView:cell.profileImage withCornerRadius:8.0];
 */

















