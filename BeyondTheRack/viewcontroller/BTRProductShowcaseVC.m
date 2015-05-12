//
//  BTRProductShowcaseVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductShowcaseVC.h"
#import "BTRProductShowcaseCollectionCell.h"
#import "BTRProductDetailViewController.h"
#import "BTRSearchViewController.h"

#import "Item+AppServer.h"
#import "BTRItemFetcher.h"

@interface BTRProductShowcaseVC ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;

@property (strong, nonatomic) NSString *selectedProductSkuString;
@property (strong, nonatomic) NSString *selectedBrandString;
@property (strong, nonatomic) Item *selectedItem;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *itemArray;

@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *sizeCodesArray;
@property (strong, nonatomic) NSMutableArray *sizeQuantityArray;

@property (nonatomic) NSUInteger selectedSizeIndex;

@end



@implementation BTRProductShowcaseVC


- (NSMutableArray *)sizesArray {
    
    if (!_sizesArray) _sizesArray = [[NSMutableArray alloc] init];
    return _sizesArray;
}


- (NSMutableArray *)sizeCodesArray {
    
    if (!_sizeCodesArray) _sizeCodesArray = [[NSMutableArray alloc] init];
    return _sizeCodesArray;
}


- (NSMutableArray *)sizeQuantityArray {
    
    if (!_sizeQuantityArray) _sizeQuantityArray = [[NSMutableArray alloc]  init];
    return _sizeQuantityArray;
}


- (NSMutableArray *)itemArray {
    
    if (!_itemArray) _itemArray = [[NSMutableArray alloc] init];
    return _itemArray;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    self.bagButton.badgeValue = [sharedShoppingBag totalBagCountString];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.eventTitleLabel setText:[self eventTitleString]];
    
    self.headerView.backgroundColor = [BTRViewUtility BTRBlack];
    self.view.backgroundColor = [BTRViewUtility BTRBlack];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self setupDocument];
    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument]
                     forEventSku:[self eventSku]
                         success:^(NSDictionary *responseDictionary) {
                             
                             [self.collectionView reloadData];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             
                         }];
}




#pragma mark - Load Event Products RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}

- (void)fetchItemsIntoDocument:(UIManagedDocument *)document forEventSku:(NSString *)eventSku
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforAllItemsWithEventSku:eventSku]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSArray *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                              options:0
                                                                                error:NULL];
         
         [self.itemArray addObjectsFromArray:[Item loadItemsfromAppServerArray:entitiesPropertyList intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext withEventId:[self eventSku]]];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
         
         success([self itemArray]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}


#pragma mark -  Handle JSON with Arbitrary Keys (variant_inventory and attributes)



- (enum btrSizeMode) extractSizesFromVarianInventoryDictionary: (NSDictionary *)variantInventoryDictionary {
    
    NSString *keyString = @"";
    NSArray *allKeys = [variantInventoryDictionary allKeys];
    
    if ([allKeys count] == 0) {
        
        return btrSizeModeNoInfo;
    }
    
    if ([allKeys count] > 0) {
        
        keyString = [allKeys objectAtIndex:0];
        
        if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@"One Size"])
            return btrSizeModeSingleSizeShow;
        
        else if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] &&
                 [allKeys count] == 1 )  /*  To deal with the follwoing faulty data entry: { "#Z" = 79; "L#L" = 4; "M#M" = 8; }; */
        /*  if #Z and anything else ignore #Z" */
            return btrSizeModeSingleSizeNoShow;
    }
    
    [variantInventoryDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *keyString = key;
        
        if ( ![[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] ) {
            
            [[self sizesArray] addObject:[keyString componentsSeparatedByString:@"#"][0]];
            [[self sizeCodesArray] addObject:[keyString componentsSeparatedByString:@"#"][1]];
            [[self sizeQuantityArray] addObject:variantInventoryDictionary[key]];
        }
        
    }];
    
    return btrSizeModeMultipleSizes;
}



#pragma mark - UICollectionView Datasource



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.itemArray count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRProductShowcaseCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductShowcaseCollectionCellIdentifier" forIndexPath:indexPath];
    Item *productItem = [self.itemArray objectAtIndex:indexPath.row];

    cell = [self configureViewForShowcaseCollectionCell:cell withItem:productItem];
    
    //enum btrSizeMode sizeMode = [self extractSizesFromVarianInventoryDictionary:entitiesPropertyList[@"variant_inventory"]];

    
    /*
    [cell.addToBagButton addTarget:self
                            action:@selector(customActionPressed:)
                  forControlEvents:UIControlEventTouchDown];
    */
    
    [cell.sizeSelector addTarget:self
                          action:@selector(customActionPressed:)
                forControlEvents:UIControlEventTouchDown];
    
    [cell setDidTapAddtoBagButtonBlock:^(id sender) {
        
        UIStoryboard *storyboard = self.storyboard;
        BTRSelectSizeVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
 
        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        viewController.sizesArray = [self sizesArray];
        viewController.sizeQuantityArray = [self sizeQuantityArray];
        viewController.delegate = self;
        
        [self presentViewController:viewController animated:YES completion:nil];
     }];
    
    //cell.value.valueChangedCallback = ^(BTRSelectSizeVC *selectSizeVC, NSString *value) {
        
       // [[self.bagItemsArray objectAtIndex:indexPath.row] setQuantity:[NSString stringWithFormat:@"%@", @(count)]];
       // stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    //};
    
    return cell;
}


- (void)customActionPressed:(id)sender{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSelectSizeVC *viewController = (BTRSelectSizeVC *)[storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
    
    [self presentViewController:viewController animated:NO completion:nil];
}





- (BTRProductShowcaseCollectionCell *)configureViewForShowcaseCollectionCell:(BTRProductShowcaseCollectionCell *)cell withItem:(Item *)productItem {

    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku]] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    
    [cell.productTitleLabel setText:[productItem shortItemDescription]];
    [cell.brandLabel setText:[productItem brand]];
    [cell.btrPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
    [cell.originalPrice setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
    
    return cell;
}



/*
 - (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }
*/



#pragma mark - Navigation


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    Item *productItem = [self.itemArray objectAtIndex:indexPath.row];
    [self setSelectedItem:productItem];
    [self setSelectedProductSkuString:[productItem sku]];
    [self setSelectedBrandString:[productItem brand]];
    [self performSegueWithIdentifier:@"ProductDetailSegueIdentifier" sender:self];
}


- (IBAction)bagButtonTapped:(UIButton *)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)searchIconTapped:(UIButton *)sender {
    
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSearchViewController *viewController = (BTRSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchNavigationControllerIdentifier"];
    [self presentViewController:viewController animated:NO completion:nil];
    */
}


// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([[segue identifier] isEqualToString:@"ProductDetailSegueIdentifier"])
    {
        BTRProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.originVCString = EVENT_SCENE;
        productDetailVC.productItem = [self selectedItem];
        productDetailVC.eventId = [self eventSku];
    }
    
    
}


- (IBAction)selectSizeTapped:(UIButton *)sender {

}



/*
- (IBAction)addToBagTapped:(UIButton *)sender {
    
    if ([[self variant] isEqualToString:SIZE_NOT_SELECTED_STRING]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Size"
                                                        message:@"Please select a size!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
        [self cartIncrementServerCallforSessionId:[sessionSettings sessionId] success:^(NSString *successString) {
 
            if ([successString isEqualToString:@"TRUE"]) {
                UIStoryboard *storyboard = self.storyboard;
                BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
                [vc.bagItemsArray addObjectsFromArray:[self bagItemsArray]];
                [self presentViewController:vc animated:YES completion:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}
*/




- (IBAction)unwindFromProductDetailToShowcase:(UIStoryboardSegue *)unwindSegue
{

}





#pragma mark - BTRSelectSizeVC Delegate



- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    
    self.selectedSizeIndex = selectedIndex;
    
    int size_label;
    
    /*
     save the cell index.
     
     save the selectedIndex and the selectedSizeString on the cell
     */
    
    //update cell
    //self.sizeLabel.text = [[self sizesArray] objectAtIndex:selectedIndex];
}


@end















