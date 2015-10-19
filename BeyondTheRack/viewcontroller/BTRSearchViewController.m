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
#import "BTRConnectionHelper.h"
#import "BagItem+AppServer.h"
#import "BTRBagFetcher.h"
#import "BTRShoppingBagViewController.h"
#import "BTRAnimationHandler.h"
#import "UIImageView+AFNetworking.h"
#import "BTRLoader.h"

#define SIZE_NOT_SELECTED_STRING @"Select Size"

@interface BTRSearchViewController () <BTRRefineResultsViewController>
@property (weak, nonatomic) IBOutlet UILabel *noResulteLabel;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (strong, nonatomic) Item *selectedItem;
@property (strong, nonatomic) NSDictionary *responseDictionaryFromFacets;
@property (strong, nonatomic) NSMutableArray* suggestionArray;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSMutableArray *chosenSizesArray;
@property (assign, nonatomic) NSUInteger selectedCellIndexRow;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;

@property int currentPage;
@property BOOL isLoadingNextPage;
@property BOOL lastPageDidLoad;

@property CGFloat maxSearchTableSize;

@end

@implementation BTRSearchViewController

- (NSMutableArray *)itemsArray {
    if (!_itemsArray) _itemsArray = [[NSMutableArray alloc] init];
    return _itemsArray;
}

- (NSMutableArray *)bagItemsArray {
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}

- (NSMutableArray *)chosenSizesArray {
    if (!_chosenSizesArray) _chosenSizesArray = [[NSMutableArray alloc] init];
    return _chosenSizesArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.02 animations:^{
        [self.collectionView performBatchUpdates:nil completion:nil];
    }];
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
    
    self.currentPage = 0;
    self.isLoadingNextPage = NO;
    self.lastPageDidLoad = NO;
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
    _noResulteLabel.alpha = 0;
    _noResulteLabel.hidden = YES;
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.suggestionArray removeAllObjects];
        [self.suggestionTableView setHidden:YES];
    }
    if (searchText.length > 2) {
        [self searchFor:searchText];
    }
    
    if (searchText > 0)
        [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.itemsArray removeAllObjects];
    [self.collectionView reloadData];
    [self setIsLoadingNextPage:YES];
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    if (![[sharedFacetHandler searchString] isEqualToString:[self.searchBar text]]) {
        sharedFacetHandler.searchString = [self.searchBar text];
    }
    
    NSString *facetString = [sharedFacetHandler getFacetStringForRESTfulRequest];
    NSString *sortString = [sharedFacetHandler getSortStringForRESTfulRequest];
    
    [self setCurrentPage:0];
    [self assignFilterIcon];
    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString] withSortingQuery:sortString andFacetQuery:facetString forPage:0
                         success:^(NSMutableArray *responseArray) {
                             [self setItemsArray:responseArray];
                             [self.collectionView becomeFirstResponder];
                             [self.collectionView reloadData];
                             for (int i = 0; i < [self.itemsArray count]; i++)
                                 [self.chosenSizesArray addObject:[NSNumber numberWithInt:-1]];
                             [self setIsLoadingNextPage:NO];
                         } failure:^(NSError *error) {
                         
                         }];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.suggestionTableView setHidden:YES];
}

#pragma mark - UICollectionView Datasource

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([BTRViewUtility isIPAD]) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            return CGSizeMake(screenBounds.size.width / 4 - 1,400);
        } else
            return CGSizeMake(screenBounds.size.width / 3 - 1, 500);
    } else
        return CGSizeMake(collectionView.frame.size.width / 2 - 1, (collectionView.frame.size.height * 4) / 5);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    [self.collectionView.collectionViewLayout invalidateLayout];
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
    BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:productItem.variantInventory
                                                                        toSizesArray:[cell sizesArray]
                                                                    toSizeCodesArray:[cell sizeCodesArray]
                                                                 toSizeQuantityArray:[cell sizeQuantityArray]];
    if ([productItem sku])
        cell = [self configureViewForShowcaseCollectionCell:cell withItem:productItem andBTRSizeMode:sizeMode forIndexPath:indexPath];
    
    BOOL allReserved = [productItem.allReserved boolValue];
    BOOL soldOut = [self isItemSoldOutWithVariant:[cell sizeQuantityArray]];
    if (allReserved || soldOut) {
        [self disableCell:cell];
        if (soldOut) {
            [cell.productStatusMessageLabel setText:@"SOLD OUT"];
            [cell.productStatusMessageLabel setTextColor:[UIColor redColor]];
        }
        else if (allReserved) {
            [cell.productStatusMessageLabel setText:@"Reserved By Others\n\nCheck back in\n20 minutes"];
            [cell.productStatusMessageLabel setTextColor:[UIColor blackColor]];
        }
    } else ;
        [self enableCell:cell];

    
    NSMutableArray *tempSizesArray = [cell sizesArray];
    NSMutableArray *tempQuantityArray = [cell sizeQuantityArray];
    
    [cell setDidTapSelectSizeButtonBlock:^(id sender) {
        UIStoryboard *storyboard = self.storyboard;
        BTRSelectSizeVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        viewController.sizesArray = tempSizesArray;
        viewController.sizeQuantityArray = tempQuantityArray;
        viewController.delegate = self;
        
        self.selectedCellIndexRow = indexPath.row;
        [self presentViewController:viewController animated:YES completion:nil];
    }];
    
    __weak typeof(cell) weakCell = cell;
    __block NSString *sizeLabelText = [cell.selectSizeButton.titleLabel text];
    __block NSString *selectedSizeString = @"";
    if ( [[[self chosenSizesArray] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:-1]] )
        selectedSizeString = @"Z";
    else
        selectedSizeString = [[cell sizeCodesArray] objectAtIndex:[[[self chosenSizesArray] objectAtIndex:[indexPath row]] integerValue]];
    
    [cell setDidTapAddtoBagButtonBlock:^(id sender) {
        
        if ([sizeLabelText isEqualToString:SIZE_NOT_SELECTED_STRING]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Size" message:@"Please select a size!" delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            // animation
            UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:indexPath];
            CGPoint correctedOffset = CGPointMake(cell.frame.origin.x - cv.contentOffset.x,cell.frame.origin.y - cv.contentOffset.y);
            CGPoint cellOrigin = [attr frame].origin;
            cellOrigin = CGPointMake(cellOrigin.x + attr.frame.size.width / 2, cellOrigin.y + attr.frame.size.height / 2);
            CGRect frame = CGRectMake(0.0,0.0,weakCell.frame.size.width,weakCell.frame.size.height);
            frame.origin = [weakCell convertPoint:correctedOffset toView:self.view];
            CGRect rect = CGRectMake(cellOrigin.x, frame.origin.y + self.headerView.frame.size.height , weakCell.productImageView.frame.size.width, weakCell.productImageView.frame.size.height);
            
            UIImageView *startView = [[UIImageView alloc] initWithImage:weakCell.productImageView.image];
            [startView setFrame:rect];
            startView.layer.cornerRadius=5;
            startView.layer.borderColor=[[UIColor blackColor]CGColor];
            startView.layer.borderWidth=1;
            [self.view addSubview:startView];
            
            CGPoint endPoint = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - 30, self.view.frame.origin.y + 40);
            [BTRAnimationHandler moveAndshrinkView:startView toPoint:endPoint withDuration:0.65];
            // end of animation
            [self cartIncrementServerCallToAddProductItem:productItem withVariant:selectedSizeString  success:^(NSString *successString) {
                if ([successString isEqualToString:@"TRUE"])
                    [self performSelector:@selector(moveToCheckout) withObject:nil afterDelay:1];
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }];
    
    return cell;
}

- (BTRProductShowcaseCollectionCell *)configureViewForShowcaseCollectionCell:(BTRProductShowcaseCollectionCell *)cell withItem:(Item *)productItem {
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    [cell.productTitleLabel setText:[productItem shortItemDescription]];
    [cell.brandLabel setText:[productItem brand]];
    [cell.btrPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
    [cell.originalPrice setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
    return cell;
}


#pragma mark - Load Results RESTful

- (void)fetchItemsforSearchQuery:(NSString *)searchQuery withSortingQuery:(NSString *)sortingQuery andFacetQuery:(NSString *)facetQuery forPage:(int)pageNum
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    [self setIsLoadingNextPage:YES];
    NSString* url = [NSString stringWithFormat:@"%@",[BTRItemFetcher URLforSearchQuery:searchQuery withSortString:sortingQuery withFacetString:facetQuery andPageNumber:pageNum]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
        [sharedFacetsHandler setSearchString:[self.searchBar text]];
        [sharedFacetsHandler setFacetsFromResponseDictionary:response];
        NSMutableArray * arrayToPass = [sharedFacetsHandler getItemDataArrayFromResponse:response];
        NSMutableArray* newItems = [[NSMutableArray alloc]init];
        if (![[NSString stringWithFormat:@"%@",arrayToPass] isEqualToString:@"0"])
            if ([arrayToPass count] != 0)
                newItems = [Item loadItemsfromAppServerArray:arrayToPass forItemsArray:newItems];
        
        success(newItems);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Navigation

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    Item *productItem = [self.itemsArray objectAtIndex:indexPath.row];
    [self setSelectedItem:productItem];
    if ([BTRViewUtility isIPAD] == YES ) {
        [self performSegueWithIdentifier:@"ProductDetailiPadSegueFromSearchIdentifier" sender:self];
    } else {
        [self performSegueWithIdentifier:@"ProductDetailSegueFromSearchIdentifier" sender:self];
    }
}

- (IBAction)tappedShoppingBag:(UIButton *)sender {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)backButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:NULL];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
    if ([[segue identifier] isEqualToString:@"ProductDetailSegueFromSearchIdentifier"] || [[segue identifier]isEqualToString:@"ProductDetailiPadSegueFromSearchIdentifier"]) {
        BTRProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.originVCString = SEARCH_SCENE;
        productDetailVC.productItem = [self selectedItem];
    }
}

- (IBAction)unwindFromRefineResultsApplied:(UIStoryboardSegue *)unwindSegue {
    [self.itemsArray removeAllObjects];
    [self.chosenSizesArray removeAllObjects];
    [self.collectionView reloadData];
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    NSMutableArray * arrayToPass = [sharedFacetHandler getItemDataArrayFromResponse:[self responseDictionaryFromFacets]];
    if (![[NSString stringWithFormat:@"%@",arrayToPass] isEqualToString:@"0"])
        if ([arrayToPass count] != 0) {
            self.itemsArray = [Item loadItemsfromAppServerArray:arrayToPass forItemsArray:[self itemsArray]];
            for (int i =  0; i < self.itemsArray.count ; i++)
                [self.chosenSizesArray addObject:[NSNumber numberWithInt:-1]];
        }
    [self.collectionView reloadData];
}

- (IBAction)unwindFromRefineResultsCleared:(UIStoryboardSegue *)unwindSegue {
    [self.itemsArray removeAllObjects];
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
    [self searchBarSearchButtonClicked:self.searchBar];
//    [self searchBar:self.searchBar textDidChange:[self.suggestionArray objectAtIndex:indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark getting suggestions

- (void)searchFor:(NSString *)word {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRSuggestionFetcher URLforSugesstionWithQuery:word]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:NO contentType:kContentTypeHTMLOrText success:^(NSDictionary * response) {
        NSArray * receivedData = [[NSArray alloc]initWithArray:(NSArray *)response];
        if (receivedData.count > 0) {
            _noResulteLabel.alpha = 0;
            _noResulteLabel.hidden = YES;
            [self.suggestionArray removeAllObjects];
            [self.suggestionTableView setHidden:NO];
            [self.suggestionArray addObjectsFromArray:receivedData];
            [self.suggestionTableView reloadData];
            [self.suggestionTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.suggestionTableView setHidden:YES];
            _noResulteLabel.alpha = 1;
            _noResulteLabel.hidden = NO;
        }
    } faild:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (BTRProductShowcaseCollectionCell *)configureViewForShowcaseCollectionCell:(BTRProductShowcaseCollectionCell *)cell
                                                                    withItem:(Item *)productItem andBTRSizeMode:(BTRSizeMode)sizeMode
                                                                forIndexPath:(NSIndexPath *)indexPath {
    if (sizeMode == BTRSizeModeSingleSizeNoShow || sizeMode == BTRSizeModeSingleSizeShow) {
        [[cell.selectSizeButton titleLabel] setText:@"One Size"];
        [cell.selectSizeButton setAlpha:0.4];
        [cell.selectSizeButton setEnabled:false];
    } else {
        if ( [[[self chosenSizesArray] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:-1]] ) {
            cell.selectSizeButton.titleLabel.text = @"Select Size";
            [cell.selectSizeButton setAlpha:1.0];
            [cell.selectSizeButton setEnabled:true];
        } else {
            cell.selectSizeButton.titleLabel.text = [NSString stringWithFormat:@"Size: %@", [[cell sizesArray] objectAtIndex:[[[self chosenSizesArray] objectAtIndex:[indexPath row]] integerValue]]];
        }
    }
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    [cell.productImageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.productTitleLabel setText:[productItem shortItemDescription]];
    [cell.brandLabel setText:[productItem brand]];
    [cell.btrPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
    [cell.originalPrice setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
    return cell;
}

- (void)disableCell:(BTRProductShowcaseCollectionCell *)cell {
    [cell.productImageView setAlpha:0.5];
    [cell.addToBagButton setAlpha:0.5];
    [cell.selectSizeButton setAlpha:0.5];
    [cell.addToBagButton setEnabled:NO];
    [cell.selectSizeButton setEnabled:NO];
    [cell.allReservedImageView setHidden:NO];
    [cell.productStatusMessageLabel setHidden:NO];
}

- (void)enableCell:(BTRProductShowcaseCollectionCell *)cell {
    [cell.productImageView setAlpha:1.0];
    [cell.addToBagButton setAlpha:1.0];
    [cell.addToBagButton setEnabled:YES];
    [cell.allReservedImageView setHidden:YES];
    [cell.productStatusMessageLabel setHidden:YES];
}

#pragma mark cart functions

- (void)cartIncrementServerCallToAddProductItem:(Item *)productItem
                                    withVariant:(NSString *)variant
                                        success:(void (^)(id  responseObject)) success
                                        failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSDictionary *params = (@{
                              @"sku": [productItem sku],
                              @"variant": variant
                              });
    
    [BTRConnectionHelper postDataToURL:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]] withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (![[response valueForKey:@"success"]boolValue]) {
            if ([response valueForKey:@"error_message"]) {
                [[[UIAlertView alloc]initWithTitle:@"Error" message:[response valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            }
            return;
        }
        NSArray *bagJsonReservedArray = response[@"bag"][@"reserved"];
        NSArray *bagJsonExpiredArray = response[@"bag"][@"expired"];
        NSDate *serverTime = [NSDate date];
        
        self.bagItemsArray = [BagItem loadBagItemsfromAppServerArray:bagJsonReservedArray
                                                  withServerDateTime:serverTime
                                                    forBagItemsArray:[self bagItemsArray]
                                                           isExpired:@"false"];
        [self.bagItemsArray addObjectsFromArray:[BagItem loadBagItemsfromAppServerArray:bagJsonExpiredArray
                                                                     withServerDateTime:serverTime
                                                                       forBagItemsArray:[self bagItemsArray]
                                                                              isExpired:@"true"]];
        BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
        [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
        success(@"TRUE");
    } faild:^(NSError *error) {
        
    }];
}


#pragma mark utility functions

- (BOOL)isItemSoldOutWithVariant:(NSArray *)variantArray {
    for (int i = 0; i < [variantArray count]; i++)
        if ([[variantArray objectAtIndex:i]intValue] > 0)
            return NO;
    return YES;
}

- (void)moveToCheckout {
    UIStoryboard *storyboard = self.storyboard;
    BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark size selecting delegate

- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    self.chosenSizesArray[self.selectedCellIndexRow] = [NSNumber numberWithInt:(int)selectedIndex];
    [self.collectionView reloadData];
}

#pragma mark ScrollView Delegate

-(void)scrollViewDidScroll: (UIScrollView*)scrollView {
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    if (scrollOffset + scrollViewHeight > scrollContentSizeHeight - 2 * self.collectionView.frame.size.height) {
        if (!self.isLoadingNextPage && !self.lastPageDidLoad) {
            [BTRLoader showLoaderInView:self.view];
            [self callForNextPage];
        }
    }
}

- (void)callForNextPage {
    self.isLoadingNextPage = YES;
    self.currentPage++;
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    NSString *facetString = [sharedFacetHandler getFacetStringForRESTfulRequest];
    NSString *sortString = [sharedFacetHandler getSortStringForRESTfulRequest];
    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString] withSortingQuery:sortString andFacetQuery:facetString forPage:self.currentPage success:^(NSArray* responseObject) {
        if (responseObject.count == 0) {
            self.lastPageDidLoad = YES;
            return;
        }
        [self.itemsArray addObjectsFromArray:responseObject];
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        for (int i = 0; i < [responseObject count]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:[self.itemsArray count] - [responseObject count] + i inSection:0]];
            [self.chosenSizesArray addObject:[NSNumber numberWithInt:-1]];
        }
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        [BTRLoader hideLoaderFromView:self.view];
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + 50)];
        self.isLoadingNextPage = NO;
    } failure:^(NSError *error) {
        [BTRLoader hideLoaderFromView:self.view];
        self.isLoadingNextPage = NO;
    }];
}

@end







