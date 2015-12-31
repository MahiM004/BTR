//
//  BTRProductShowcaseVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductShowcaseVC.h"
#import "BTRProductDetailEmbededVC/BTRProductDetailEmbededVC.h"
#import "BTRProductShowcaseCollectionCell.h"
#import "BTRSearchViewController.h"
#import "BTRShoppingBagViewController.h"
#import "Item+AppServer.h"
#import "BagItem+AppServer.h"
#import "BTRItemFetcher.h"
#import "BTRBagFetcher.h"
#import "BTRConnectionHelper.h"
#import "BTRAnimationHandler.h"
#import "UIImageView+AFNetworkingFadeIn.h"
#import "BTRLoader.h"
#import "BTRMenuTableViewCell.h"
#import "LMDropdownView.h"
#import "MarqueeLabel.h"
#import "BTRSettingManager.h"

#define SIZE_NOT_SELECTED_STRING @"Select Size"

#define SIZE_MENU     1
#define SORT_MENU     2

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface BTRProductShowcaseVC ()
{
    /// this are for the user if he/she select the add to bag with out selecting any size
    BTRProductShowcaseCollectionCell * selectedCell;
    Item *selectedItem;
    NSArray *selectSizeArr;
    NSArray *selectedSizeCodedArray;
    UICollectionView *selectedCV;
    NSIndexPath *selectIndex;
    BOOL sizeTappedWithOutAdd;
}
// Properties
@property (strong,nonatomic) NSTimer *timer;

// Pagination
@property int currentPage;
@property BOOL isLoadingNextPage;
@property BOOL lastPageDidLoad;

// scrollview
@property (nonatomic, assign) CGFloat lastContentOffset;

// Heights
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerViewHeight;

// UI Views
@property (strong, nonatomic) NSIndexPath *selectedIndexPath; // used to segue to PDP
@property (strong, nonatomic) NSString *selectedBrandString; // used to segue to PDP

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *timerView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MarqueeLabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventEndTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (weak, nonatomic) IBOutlet UILabel *filterByLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortByLabel;
@property (strong, nonatomic) NSMutableArray *originalItemArray;
@property (copy, nonatomic) NSDictionary *selectedVariantInventories; // an Array of variantInventory Dictionaries
@property (copy, nonatomic) NSDictionary *selectedAttributes; // an Array of variantInventory Dictionaries

@property (strong, nonatomic) NSMutableArray *chosenSizesArray;
@property (assign, nonatomic) NSUInteger selectedCellIndexRow;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;

// sort and filter
@property (weak, nonatomic) IBOutlet UIView *sortAndFilterView;

@property (strong, nonatomic) NSArray* collectionViewResourceArray;
@property (strong, nonatomic) NSArray* sortedItemsArray;

@property (strong, nonatomic) NSArray* allSizes;
@property (strong, nonatomic) NSArray* allCodedSizes;
@property (strong, nonatomic) NSArray* sortArray;

// textFields
@property (weak, nonatomic) IBOutlet UITextField *filterSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *sortTextField;

// Menu
@property UITableView *menuTableView;
@property LMDropdownView *menu;
@property (nonatomic) NSUInteger menuType;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

// operation
@property operation lastOperation;
@property NSInvocation *savedInvocation;
@property NSString *selectedSize;

@end

@implementation BTRProductShowcaseVC

- (NSArray *)collectionViewResourceArray {
    if ([self.sortTextField.text isEqualToString:@"Suggested"] && [self.filterSizeTextField.text isEqualToString:@"Size"])
        return self.originalItemArray;
    return self.sortedItemsArray;
}

- (NSMutableArray *)bagItemsArray {
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}

- (NSMutableArray *)chosenSizesArray {
    if (!_chosenSizesArray) _chosenSizesArray = [[NSMutableArray alloc] init];
    return _chosenSizesArray;
}

- (NSMutableArray *)originalItemArray {
    if (!_originalItemArray) _originalItemArray = [[NSMutableArray alloc] init];
    return _originalItemArray;
}

- (NSArray *)sortArray {
    if (!_sortArray) _sortArray = [[NSArray alloc]initWithObjects:@"Suggested",@"Discount Increasing",@"Discount Decreasing",@"Price Increasing",@"Price Decreasing",@"Type", nil];
    return _sortArray;
}

- (NSArray *)sortModes {
    return @[kSUGGESTED,kDISCOUNTASCENDING,kDISCOUNTDESCENDING,kPRICEASCENDING,kPRICEDESCENDING,kSKUASCENDING];
}

//- (NSArray *)sizeArray {
//    if (!_sizeArray)  {
//        NSMutableArray* allSizes = [[NSMutableArray alloc]init];
//        for (Item* item in self.originalItemArray) {
//            if ([item.variantInventory isKindOfClass:[NSDictionary class]]){
//                for (NSString *key in [item.variantInventory keyEnumerator])
//                    if (![allSizes containsObject:[[key componentsSeparatedByString:@"#"]firstObject]])
//                        [allSizes addObject:[[key componentsSeparatedByString:@"#"]firstObject]];
//            }
//        }
//        allSizes = [NSMutableArray arrayWithArray:[allSizes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
//        }]];
//        if ([allSizes containsObject:@"One Size"])
//            [allSizes removeObject:@"One Size"];
//        
//        [allSizes insertObject:@"Size" atIndex:0];
//        _sizeArray = [allSizes mutableCopy];
//    }
//    return _sizeArray;
//}

- (void)fillSizesArrays {
    NSMutableArray* allSizes = [[NSMutableArray alloc]init];
    NSMutableArray* allCodedSizes = [[NSMutableArray alloc]init];
    for (Item* item in self.originalItemArray) {
        if ([item.variantInventory isKindOfClass:[NSDictionary class]]){
            for (NSString *key in [item.variantInventory keyEnumerator])
                if (![allSizes containsObject:[[key componentsSeparatedByString:@"#"]objectAtIndex:0]]) {
                    [allSizes addObject:[[key componentsSeparatedByString:@"#"]objectAtIndex:0]];
                    [allCodedSizes addObject:[[key componentsSeparatedByString:@"#"]objectAtIndex:1]];
                }
        }
    }
//    allSizes = [NSMutableArray arrayWithArray:[allSizes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
//    }]];
    
    [allSizes insertObject:@"Size" atIndex:0];
    [allCodedSizes insertObject:@"Size" atIndex:0];
    self.allSizes = [allSizes mutableCopy];
    self.allCodedSizes = [allCodedSizes mutableCopy];
}

- (BOOL)isItemSoldOutWithVariant:(NSArray *)variantArray {
    for (int i = 0; i < [variantArray count]; i++)
        if ([[variantArray objectAtIndex:i]intValue] > 0)
            return NO;
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.02 animations:^{
        [self.collectionView performBatchUpdates:nil completion:nil];
    }];
    if ([[BTRSessionSettings sessionSettings]isUserLoggedIn])
        [self getCartCountServerCallWithSuccess:^(id responseObject) {
            BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
            self.bagButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[sharedShoppingBag bagCount]];
        } failure:^(NSError *error) {
            
        }];
   }

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin:)
                                                 name:kUSERDIDLOGIN
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUSERDIDLOGIN object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [BTRLoader showLoaderInView:self.view];
    [self setSelectedCellIndexRow:NSUIntegerMax];

    [self.eventTitleLabel setText:[self eventTitleString]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeDate) userInfo:nil repeats:YES];
    self.headerView.backgroundColor = self.sortAndFilterView.backgroundColor = self.timerView.backgroundColor = [BTRViewUtility BTRBlack];
    self.view.backgroundColor = [BTRViewUtility BTRBlack];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self loadFirstPageOfItems];
    [self setupMenu];
}

- (void)loadFirstPageOfItems {
    self.currentPage = 1;
    self.lastPageDidLoad = NO;
    self.isLoadingNextPage = YES;
    [self.originalItemArray removeAllObjects];
    [self.chosenSizesArray removeAllObjects];
    
    unsigned long indexOfSize = [self.allSizes indexOfObject:self.filterSizeTextField.text];
    NSString *filter;
    if (indexOfSize == NSNotFound)
        filter = self.filterSizeTextField.text;
    else if (self.allCodedSizes)
        filter = [self.allCodedSizes objectAtIndex:indexOfSize];
    else
        filter = @"Size";
    
    [self fetchItemsforEventSku:[self eventSku] forPagenum:self.currentPage andSortMode:[[self sortModes]objectAtIndex:[self.sortArray indexOfObject:self.sortTextField.text]] andFilterSize:filter
                        success:^(NSMutableArray *responseObject) {
                            self.isLoadingNextPage = NO;
                            [self.originalItemArray addObjectsFromArray:responseObject];
                            for (int i = 0; i < [self.originalItemArray count]; i++)
                                [self.chosenSizesArray addObject:[NSNumber numberWithInt:-1]];
                            if (self.allSizes == nil) {
                                [self fillSizesArrays];
                            }
                            [self.collectionView reloadData];
                        } failure:^(NSError *error) {
                            self.isLoadingNextPage = NO;
                        }];
}

- (void)callForNextPage {
    self.isLoadingNextPage = YES;
    self.currentPage++;
    [self fetchItemsforEventSku:[self eventSku] forPagenum:self.currentPage andSortMode:[[self sortModes]objectAtIndex:[self.sortArray indexOfObject:self.sortTextField.text]] andFilterSize:self.filterSizeTextField.text success:^(NSMutableArray *responseObject) {
                            if (responseObject.count == 0) {
                                self.lastPageDidLoad = YES;
                                return;
                            }
                            [self.originalItemArray addObjectsFromArray:responseObject];
                            NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
                            for (int i = 0; i < [responseObject count]; i++) {
                                [indexPaths addObject:[NSIndexPath indexPathForItem:[self.originalItemArray count] - [responseObject count] + i inSection:0]];
                                [self.chosenSizesArray addObject:[NSNumber numberWithInt:-1]];
                            }
                            [self.collectionView insertItemsAtIndexPaths:indexPaths];
                            [BTRLoader hideLoaderFromView:self.view];
                            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + 50)];
                            self.isLoadingNextPage = NO;
                        } failure:^(NSError *error) {
                            self.isLoadingNextPage = NO;
                    }];
}

#pragma mark - Load Event Products RESTful

- (void)fetchItemsforEventSku:(NSString *)eventSku forPagenum:(int)pageNum andSortMode:(sortMode)selectedSortMode andFilterSize:(NSString *)filterSize
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    NSString *url;
    BOOL sessionNeeded;
    if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforAllItemsWithEventSku:eventSku inPageNumber:pageNum withSortingMode:selectedSortMode andSizeFilter:filterSize]];
        sessionNeeded = YES;
    } else {
        NSString *country = [[[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERLOCATION]lowercaseString];
        url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforAllItemsWithEventSku:eventSku inPageNumber:pageNum withSortingMode:selectedSortMode andSizeFilter:filterSize forCountry:country]];
        sessionNeeded = NO;
    }
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:sessionNeeded contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSMutableArray *newItems = [[NSMutableArray alloc]init];
        newItems = [Item loadItemsfromAppServerArray:(NSArray *)response withEventId:[self eventSku] forItemsArray:newItems];
        success(newItems);
        [BTRLoader hideLoaderFromView:self.view];
    } faild:^(NSError *error) {
        [BTRLoader hideLoaderFromView:self.view];
    }];
}

- (void)cartIncrementServerCallToAddProductItem:(Item *)productItem
                                withVariant:(NSString *)variant
                                    success:(void (^)(id  responseObject)) success
                                    failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSDictionary *params = (@{
                              @"event_id": [productItem eventId],
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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView performBatchUpdates:nil completion:nil];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    [self.collectionView.collectionViewLayout invalidateLayout];
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.originalItemArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Item *productItem = [self.originalItemArray objectAtIndex:indexPath.row];
    BTRProductShowcaseCollectionCell *cell = nil;
    
    if (productItem.isMockItem)
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"MockProductShowcaseCollectionCellIdentifier" forIndexPath:indexPath];
    else
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductShowcaseCollectionCellIdentifier" forIndexPath:indexPath];
    
    BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:productItem.variantInventory
                                                                        toSizesArray:[cell sizesArray]
                                                                    toSizeCodesArray:[cell sizeCodesArray]
                                                                 toSizeQuantityArray:[cell sizeQuantityArray]];
    
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
    } else
        [self enableCell:cell];
    
    NSMutableArray *tempSizesArray = [cell sizesArray];
    NSMutableArray *tempQuantityArray = [cell sizeQuantityArray];
    NSMutableArray *tempSizeCodedArray = [cell sizeCodesArray];
    __weak typeof(cell) weakCell = cell;
    [cell setDidTapSelectSizeButtonBlock:^(id sender) {
        [self openSelectSize:weakCell sizeArray:tempSizesArray codedSizeArray:tempSizeCodedArray quantityArray:tempQuantityArray index:indexPath withItem:productItem];
    }];
    
    __block NSString *sizeLabelText = [cell.selectSizeButton.titleLabel text];
    __block NSString *selectedSizeString = @"";
    if ( [[[self chosenSizesArray] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:-1]] )
        selectedSizeString = @"Z";
    else
        selectedSizeString = [[cell sizeCodesArray] objectAtIndex:[[[self chosenSizesArray] objectAtIndex:[indexPath row]] integerValue]];
    
    
    [cell setDidTapAddtoBagButtonBlock:^(id sender) {
        if ([sizeLabelText isEqualToString:SIZE_NOT_SELECTED_STRING]) {
            selectedCell = weakCell;
            selectedCV = cv;
            sizeTappedWithOutAdd = YES;
            [self openSelectSize:weakCell sizeArray:tempSizesArray codedSizeArray:tempSizeCodedArray quantityArray:tempQuantityArray index:indexPath withItem:productItem];
        } else {
            sizeTappedWithOutAdd = NO;
            [self addToBag:weakCell collection:cv item:productItem selectedSize:selectedSizeString index:indexPath];
        }
    }];
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

- (void)moveToCheckout {
    UIStoryboard *storyboard = self.storyboard;
    BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)customActionPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSelectSizeVC *viewController = (BTRSelectSizeVC *)[storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)addToBag:(BTRProductShowcaseCollectionCell*)cell
                                                   collection:(UICollectionView*)cv
                                                     item:(Item*)item
                                             selectedSize:(NSString*)selelectedSize
                                                     index:(NSIndexPath*)indexPath {

    if (![[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        NSMethodSignature *signature  = [self methodSignatureForSelector:_cmd];
        self.savedInvocation = [NSInvocation invocationWithMethodSignature:signature];
        self.savedInvocation.target = self;
        self.savedInvocation.selector = _cmd;
        [self.savedInvocation setArgument:&cell atIndex:2];
        [self.savedInvocation setArgument:&cv atIndex:3];
        [self.savedInvocation setArgument:&item atIndex:4];
        [self.savedInvocation setArgument:&selelectedSize atIndex:5];
        [self.savedInvocation setArgument:&indexPath atIndex:6];
        [self setLastOperation:addToBag];
        [self showLogin];
        return;
    }

    UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:indexPath];
    CGPoint correctedOffset = CGPointMake(cell.frame.origin.x - cv.contentOffset.x,cell.frame.origin.y - cv.contentOffset.y);
    
    CGPoint cellOrigin = [attr frame].origin;
    cellOrigin = CGPointMake(cellOrigin.x + attr.frame.size.width / 2, cellOrigin.y + attr.frame.size.height / 2);
    
    CGRect frame = CGRectMake(0.0,0.0,cell.frame.size.width,cell.frame.size.height);
    
    frame.origin = [cell convertPoint:correctedOffset toView:self.view];
    CGRect rect = CGRectMake(cellOrigin.x, frame.origin.y + self.headerView.frame.size.height , cell.productImageView.frame.size.width, cell.productImageView.frame.size.height);
    
    // calling add to bag
    [self cartIncrementServerCallToAddProductItem:item withVariant:selelectedSize  success:^(NSString *successString) {
        if ([successString isEqualToString:@"TRUE"]) {
            [self performSelector:@selector(moveToCheckout) withObject:nil afterDelay:1];
            UIImageView *startView = [[UIImageView alloc] initWithImage:cell.productImageView.image];
            [startView setFrame:rect];
            startView.layer.cornerRadius=5;
            startView.layer.borderColor=[[UIColor blackColor]CGColor];
            startView.layer.borderWidth=1;
            [self.view addSubview:startView];
            
            CGPoint endPoint = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - 30, self.view.frame.origin.y + 40);
            [BTRAnimationHandler moveAndshrinkView:startView toPoint:endPoint withDuration:0.65];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)openSelectSize:(BTRProductShowcaseCollectionCell*)cell
             sizeArray:(NSMutableArray*)sizeArray
        codedSizeArray:(NSMutableArray *)codedSizeArray
         quantityArray:(NSMutableArray*)quantityArray
                 index:(NSIndexPath*)indexPath
              withItem:(Item*)item {
    
    selectedItem = item;
    selectIndex = indexPath;
    selectedSizeCodedArray = codedSizeArray;
    UIStoryboard *storyboard = self.storyboard;
    BTRSelectSizeVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    viewController.sizesArray = sizeArray;
    viewController.sizeQuantityArray = quantityArray;
    viewController.delegate = self;
    selectSizeArr = [NSArray arrayWithArray:sizeArray];
    self.selectedCellIndexRow = indexPath.row;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BTRProductShowcaseCollectionCell *)configureViewForShowcaseCollectionCell:(BTRProductShowcaseCollectionCell *)cell
                                                                    withItem:(Item *)productItem andBTRSizeMode:(BTRSizeMode)sizeMode
                                                                forIndexPath:(NSIndexPath *)indexPath {
    if (sizeMode == BTRSizeModeSingleSizeNoShow || sizeMode == BTRSizeModeSingleSizeShow) {
        [[cell.selectSizeButton titleLabel] setText:@"One Size"];
        [cell.selectSizeButton setAlpha:0.4];
        [cell.selectSizeButton setEnabled:false];
        [cell.selectSizeButton setHidden:YES];
    } else {
        if ( [[[self chosenSizesArray] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:-1]] ) {
            cell.selectSizeButton.titleLabel.text = @"Select Size";
            [cell.selectSizeButton setAlpha:1.0];
            [cell.selectSizeButton setEnabled:true];
            [cell.selectSizeButton setHidden:NO];
        } else {
            cell.selectSizeButton.titleLabel.text = [NSString stringWithFormat:@"Size: %@", [[cell sizesArray] objectAtIndex:[[[self chosenSizesArray] objectAtIndex:[indexPath row]] integerValue]]];
        }
    }
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku]]  placeholderImage:nil fadeInWithDuration:0.5];
    [cell.productImageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.productTitleLabel setText:[productItem shortItemDescription]];
    [cell.brandLabel setText:[productItem brand]];
    [cell.btrPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
    [cell.originalPrice setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
    return cell;
}

#pragma mark - Navigation

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    Item *productItem = [self.originalItemArray objectAtIndex:indexPath.row];
    if (productItem.isMockItem)
        return;
    [self setSelectedIndexPath:indexPath];
    [self setSelectedBrandString:[productItem brand]];
    [self setSelectedAttributes:productItem.attributeDictionary];
    [self setSelectedVariantInventories:productItem.variantInventory];
    [self performSegueWithIdentifier:@"productEmbededSegue" sender:self];
}

- (IBAction)bagButtonTapped:(UIButton *)sender {
        if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
            UIStoryboard *storyboard = self.storyboard;
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [self setLastOperation:gotoBag];
            [self showLogin];
        }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"productEmbededSegue"]) {
        BTRProductDetailEmbededVC * productEmbededVC = [segue destinationViewController];
        productEmbededVC.getOriginalVCString = EVENT_SCENE;
        productEmbededVC.getItem = [self.originalItemArray objectAtIndex:[self.selectedIndexPath row]];
        productEmbededVC.getEventID = [self eventSku];
        productEmbededVC.getVariantInventoryDic = self.selectedVariantInventories;
        productEmbededVC.getAttribDic = self.selectedAttributes;
        
        BTRProductShowcaseCollectionCell* cell = (BTRProductShowcaseCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        if ([self isItemSoldOutWithVariant:[cell sizeQuantityArray]])
            productEmbededVC.disableAddToCart = YES;
    }
}

- (IBAction)unwindFromProductDetailToShowcase:(UIStoryboardSegue *)unwindSegue {

}

#pragma mark - Filter & Suggestion

- (IBAction)sizeSelectionTapped:(UIButton *)sender {
    if (self.menu.isOpen)
        [self.menu hide];
    else
        [self loadMenuForype:SIZE_MENU];
}

- (IBAction)sortSelectionTapped:(id)sender {
    if (self.menu.isOpen)
        [self.menu hide];
    else
        [self loadMenuForype:SORT_MENU];
}
/*
//- (void)sortItems {
//    NSSortDescriptor *sortDescriptor;
//    switch ([self.sortArray indexOfObject:self.sortTextField.text]) {
//        case 0:
//            self.sortedItemsArray = self.originalItemArray;
//            return;
//        case 1:
//            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"discount" ascending:YES];
//            break;
//        case 2:
//            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"discount" ascending:NO];
//            break;
//        case 3:
//            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"salePrice" ascending:YES];
//            break;
//        case 4:
//            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"salePrice" ascending:NO];
//            break;
//        case 5:
//            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sku" ascending:YES];
//            break;
//        default:
//            break;
//    }
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    self.sortedItemsArray = [self.originalItemArray sortedArrayUsingDescriptors:sortDescriptors];
//}
//
//- (void)filterItems {
//    NSInteger selectedIndex = [self.sizeArray indexOfObject:self.filterSizeTextField.text];
//    if (selectedIndex == 0)
//        return;
//    NSMutableArray* tempArray = [self.sortedItemsArray mutableCopy];
//    for (Item* item in self.sortedItemsArray) {
//        if ([item.variantInventory isKindOfClass:[NSDictionary class]]){
//            BOOL found = NO;
//            for (NSString *key in [item.variantInventory keyEnumerator])
//                if ([key hasPrefix:[NSString stringWithFormat:@"%@#",[self.sizeArray objectAtIndex:selectedIndex]]])
//                    found = YES;
//            if (!found)
//                [tempArray removeObject:item];
//        }
//        
//    }
//    self.sortedItemsArray = tempArray;
//}
*/
#pragma mark - BTRSelectSizeVC Delegate

- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    self.chosenSizesArray[self.selectedCellIndexRow] = [NSNumber numberWithInt:(int)selectedIndex];
    [self.collectionView reloadData];
    if (sizeTappedWithOutAdd == YES) {
        self.selectedSize = [selectedSizeCodedArray objectAtIndex:selectedIndex]; //[NSString stringWithFormat:@"%@",selectSizeArr[selectedIndex]];
        self.selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self addToBag:selectedCell collection:selectedCV item:selectedItem selectedSize:self.selectedSize index:self.selectedIndexPath];
        sizeTappedWithOutAdd = NO;
    }
}

#pragma mark back

- (IBAction)backBouttonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Scrollview Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.menu.isOpen)
        return;
    
    if  ([self scrollDirectionOfScrollView:scrollView] == ScrollDirectionDown) {
        if (scrollView.contentOffset.y > 240) {
            self.sortViewHeight.constant = 0;
            self.timerViewHeight.constant = 0;
        }
    } else
        if (scrollView.contentOffset.y < 200) {
            self.timerViewHeight.constant = 20;
            self.sortViewHeight.constant = 40;
        }
    [self.view needsUpdateConstraints];
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (ScrollDirection)scrollDirectionOfScrollView:(UIScrollView *)scrollView {
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    
    self.lastContentOffset = scrollView.contentOffset.x;
    return scrollDirection;
}

#pragma mark MENU

- (void)setupMenu {
    self.menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height / 4, 160, 200) style:UITableViewStylePlain];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    [self.menuTableView registerNib:[UINib nibWithNibName:@"BTRMenuTableViewCell" bundle:nil] forCellReuseIdentifier:kMenuCellReuseIdentifier];
    self.menu = [LMDropdownView dropdownView];
}

- (void)loadMenuForype:(NSUInteger)type {
    [self setMenuType:type];
    [self.menuTableView reloadData];
    if (type == SIZE_MENU) {
        [self.menuTableView setFrame:CGRectMake(self.filterByLabel.bounds.origin.x, self.filterByLabel.bounds.origin.y , self.filterByLabel.bounds.size.width + self.filterSizeTextField.bounds.size.width, 280)];
        [self.menu showInView:self.tableViewContainer withContentView:self.menuTableView atOrigin:self.filterByLabel.frame.origin];
    }
    if (type == SORT_MENU) {
        CGRect frame;
        CGPoint point;
        if ([BTRViewUtility isIPAD]) {
            frame = CGRectMake(self.sortByLabel.bounds.origin.x, self.sortByLabel.bounds.origin.y ,self.sortTextField.bounds.size.width , 280);
            point = self.sortTextField.frame.origin;
        } else {
            frame = CGRectMake(self.sortByLabel.bounds.origin.x, self.sortByLabel.bounds.origin.y , self.sortByLabel.bounds.size.width + self.sortTextField.bounds.size.width , 280);
            point = self.sortByLabel.frame.origin;
        }
        [self.menuTableView setFrame:frame];
        [self.menu showInView:self.tableViewContainer withContentView:self.menuTableView atOrigin:point];
    }
}

#pragma mark TABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.menuType == SIZE_MENU)
        return [self.allSizes count];
    if (self.menuType == SORT_MENU)
        return [self.sortArray count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTRMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCellReuseIdentifier];
    if (self.menuType == SORT_MENU)
        [cell.titleLabel setText:[self.sortArray objectAtIndex:indexPath.row]];
    if (self.menuType == SIZE_MENU)
        [cell.titleLabel setText:[self.allSizes objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.menu hide];
    if ([self menuType] == SORT_MENU) {
        if ([self.sortTextField.text isEqualToString:[self.sortArray objectAtIndex:indexPath.row]])
            return;
        [self.sortTextField setText:[self.sortArray objectAtIndex:indexPath.row]];
    }

    if ([self menuType] == SIZE_MENU) {
        if ([self.filterSizeTextField.text isEqualToString:[self.allSizes objectAtIndex:indexPath.row]])
            return;
        [self.filterSizeTextField setText:[self.allSizes objectAtIndex:indexPath.row]];
    }
    [self loadFirstPageOfItems];
}

#pragma mark change date

- (void)changeDate{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [sysCalendar components: (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear )
                                                  fromDate:[NSDate date]
                                                    toDate:self.eventEndDate
                                                   options:0];
    if (components.hour < 0 || components.minute < 0 || components.second < 0) {
        self.eventEndTimeLabel.text = [NSString stringWithFormat:@"Expired"];
        self.eventEndTimeLabel.textColor = [UIColor redColor];
        [self.timer invalidate];
    } else {
        self.eventEndTimeLabel.text = [NSString stringWithFormat:@"Event Ends In %li days %02ld:%02ld:%02ld",(long)components.day,(long)components.hour,(long)components.minute,(long)components.second];
        self.eventEndTimeLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark saved action

- (void)showLogin {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRLoginNavigation"];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidLogin:(NSNotification *) notification {
    if (self.lastOperation == addToBag)
        [self.savedInvocation invoke];
    if  (self.lastOperation == gotoBag)
        [self bagButtonTapped:nil];
    self.lastOperation = 0;
}

#pragma mark cart info

- (void)getCartCountServerCallWithSuccess:(void (^)(id  responseObject)) success
                                  failure:(void (^)(NSError *error)) failure {
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBagCount]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSString *bagCount = [NSString stringWithFormat:@"%@",response[@"count"]];
        BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
        sharedShoppingBag.bagCount = [bagCount integerValue];
        success(bagCount);
    } faild:^(NSError *error) {
        NSLog(@"errtr: %@", error);
        failure(error);
    }];
}

#pragma mark shake

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ( event.subtype == UIEventSubtypeMotionShake ) {
        BTRAppDelegate *appdel = (BTRAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appdel backToInitialViewControllerFrom:self];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

@end















