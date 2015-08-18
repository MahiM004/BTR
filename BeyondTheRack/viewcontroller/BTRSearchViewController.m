//
//  BTRSearchViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchViewController.h"
#import "BTRProductShowcaseCollectionCell.h"
#import "BTRRefineResultsViewController.h"
#import "BTRProductDetailViewController.h"
#import "Item+AppServer.h"
#import "BTRItemFetcher.h"
#import "BTRFacetsHandler.h"
#import "BTRFacetData.h"
#import "BTRSuggestionFetcher.h"


@interface BTRSearchViewController () <BTRRefineResultsViewController>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (strong, nonatomic) Item *selectedItem;
@property (strong, nonatomic) NSDictionary *responseDictionaryFromFacets;
@property (strong, nonatomic) NSMutableArray *originalItemArray;
@property (strong, nonatomic) NSMutableArray* suggestionArray;
@property CGFloat maxSearchTableSize;

@end



@implementation BTRSearchViewController


- (NSMutableArray *)originalItemArray {
    
    if (!_originalItemArray) _originalItemArray = [[NSMutableArray alloc] init];
    return _originalItemArray;
}

- (NSMutableArray *)itemsArray{

    if (!_itemsArray) _itemsArray = [[NSMutableArray alloc] init];
    return _itemsArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    self.bagButton.badgeValue = [sharedShoppingBag totalBagCountString];
    
    [self assignFilterIcon];

}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
  
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];

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

    [self.searchBar setImage:image2 forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    [self.searchBar setImage:image2 forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    self.suggestionArray = [[NSMutableArray alloc]init];
    self.suggestionTableView.hidden = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (![self.itemsArray count])
        [self.searchBar becomeFirstResponder];
}


- (void)assignFilterIcon {

    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    if ([sharedFacetHandler hasChosenAtLeastOneFacet])
        self.filterIconImageView.image = [UIImage imageNamed:@"filtericonYellow.png"];
    else
        self.filterIconImageView.image = [UIImage imageNamed:@"filtericon.png"];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:YES];
    [self.searchBar resignFirstResponder];
    [self.collectionView becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can recreated.
}


#pragma mark SearchBar Delegates


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.suggestionTableView setHidden:YES];
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 2) {
        [self searchFor:searchText];
    }
    if (searchText > 0) {
        [self.searchBar setShowsCancelButton:YES animated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    
    if (![[sharedFacetHandler searchString] isEqualToString:[self.searchBar text]]) {
        [sharedFacetData clearAllData];
        [sharedFacetHandler resetFacets];
        sharedFacetHandler.searchString = [self.searchBar text];
    }
    
    [self assignFilterIcon];

    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                         success:^(NSMutableArray *responseArray) {
                             [self.originalItemArray addObjectsFromArray:responseArray];
                             
                         } failure:^(NSError *error) {
                         
                         }];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.collectionView becomeFirstResponder];
    [self.collectionView reloadData];
    [self.suggestionTableView setHidden:YES];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}



#pragma mark - UICollectionView Datasource

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width / 2 - 1, (collectionView.frame.size.height * 2) / 3);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if ([self.itemsArray  count] > 0) {
        
        self.filterIconImageView.hidden = NO;
        self.filterButton.enabled = YES;
    
    } else {
        
        self.filterIconImageView.hidden = YES;
        self.filterButton.enabled = NO;
        
    }
    
    return [self.itemsArray count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProductShowcaseCollectionCellIdentifier";
    BTRProductShowcaseCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Item *productItem = [self.itemsArray objectAtIndex:indexPath.row];

    if ([productItem sku]) {
        
        cell = [self configureViewForShowcaseCollectionCell:cell withItem:productItem];
        
    } else {
        
        self.itemsArray = [self originalItemArray];
    }

    return cell;
}


- (BTRProductShowcaseCollectionCell *)configureViewForShowcaseCollectionCell:(BTRProductShowcaseCollectionCell *)cell withItem:(Item *)productItem {
    
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku]] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    
    [cell.productTitleLabel setText:[productItem shortItemDescription]];
    [cell.brandLabel setText:[productItem brand]];
    [cell.btrPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
    [cell.originalPrice setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
    
    return cell;
    
}


#pragma mark - Load Results RESTful

- (void)fetchItemsforSearchQuery:(NSString *)searchQuery
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure
{
    [self.itemsArray removeAllObjects];
    [self.collectionView reloadData];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:[BTRItemFetcher contentTypeForSearchQuery]];     
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withSortString:@"" andPageNumber:0]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
 
         BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
         [sharedFacetsHandler setSearchString:[self.searchBar text]];
         [sharedFacetsHandler setFacetsFromResponseDictionary:entitiesPropertyList];
         
         NSMutableArray * arrayToPass = [sharedFacetsHandler getItemDataArrayFromResponse:entitiesPropertyList];
         
         if (![[NSString stringWithFormat:@"%@",arrayToPass] isEqualToString:@"0"]) {
             
             if ([arrayToPass count] != 0) {
                 self.itemsArray = [Item loadItemsfromAppSearchServerArray:arrayToPass forItemsArray:[self itemsArray]];
             }
         }
         
         [self.collectionView reloadData];
         
         success([self itemsArray]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(error);
     }];
    
}



#pragma mark - Navigation


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    Item *productItem = [self.itemsArray objectAtIndex:indexPath.row];
    [self setSelectedItem:productItem];
    [self performSegueWithIdentifier:@"ProductDetailSegueFromSearchIdentifier" sender:self];
}


- (IBAction)tappedShoppingBag:(UIButton *)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)backButtonTapped:(UIButton *)sender {

    [self dismissViewControllerAnimated:NO completion:NULL];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BTRSearchFilterSegue"]) {
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UIGraphicsBeginImageContextWithOptions(screenSize, NO, [UIScreen mainScreen].scale);
        CGRect rec = CGRectMake(0, 0, screenSize.width, screenSize.height);
        [self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
        UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        BTRRefineResultsViewController *refineVC = [segue destinationViewController];
        refineVC.backgroundImage = screenShotImage;
        refineVC.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"ProductDetailSegueFromSearchIdentifier"]) {
        BTRProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.originVCString = SEARCH_SCENE;
        productDetailVC.productItem = [self selectedItem];
    }
}


- (IBAction)unwindFromRefineResultsApplied:(UIStoryboardSegue *)unwindSegue {
    
    [self.itemsArray removeAllObjects];
    [self.collectionView reloadData];
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    NSMutableArray * arrayToPass = [sharedFacetHandler getItemDataArrayFromResponse:[self responseDictionaryFromFacets]];
    
    if (![[NSString stringWithFormat:@"%@",arrayToPass] isEqualToString:@"0"]) {
        if ([arrayToPass count] != 0) {
            self.itemsArray = [Item loadItemsfromAppSearchServerArray:arrayToPass forItemsArray:[self itemsArray]];
        }
    }

    [self.collectionView reloadData];
}


- (IBAction)unwindFromRefineResultsCleared:(UIStoryboardSegue *)unwindSegue {

    [self.itemsArray removeAllObjects];
    [self.itemsArray addObjectsFromArray:[self originalItemArray]];
    [self.collectionView reloadData];
}

- (IBAction)unwindFromProductDetailToSearchScene:(UIStoryboardSegue *)unwindSegue {
    
}


#pragma mark - BTRRefineResultsViewController Delegate

- (void)refineSceneWillDisappearWithResponseDictionary:(NSDictionary *)responseDictionary {
    self.responseDictionaryFromFacets = responseDictionary;
}


#pragma mark - SuggestionTableView Delegates and DataSource


// DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.suggestionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.suggestionArray objectAtIndex:indexPath.row];
    return cell;
}

// Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar setText:[self.suggestionArray objectAtIndex:indexPath.row]];
    [self searchBar:self.searchBar textDidChange:[self.suggestionArray objectAtIndex:indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}

#pragma mark getting suggestions

- (void)searchFor:(NSString *)word {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@",[BTRSuggestionFetcher URLforSugesstionWithQuery:word]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.suggestionArray removeAllObjects];
    
        [self.suggestionArray addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]];
        if (self.suggestionArray.count > 0) {
            
            [self.suggestionTableView setHidden:NO];
            [self.suggestionTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end







