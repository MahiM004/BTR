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

#import "BTRShoppingBagViewController.h"

#import "Item+AppServer.h"
#import "BagItem+AppServer.h"
#import "BTRItemFetcher.h"
#import "BTRBagFetcher.h"

#define SIZE_NOT_SELECTED_STRING @"Select Size"

@interface BTRProductShowcaseVC ()

@property (strong, nonatomic) NSIndexPath *selectedIndexPath; // used to segue to PDP
@property (strong, nonatomic) NSString *selectedBrandString; // used to segue to PDP

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;

@property (strong, nonatomic) NSMutableArray *itemArray;
@property (copy, nonatomic) NSMutableArray *variantInventoriesArray; // an Array of variantInventory Dictionaries
@property (copy, nonatomic) NSMutableArray *attributesArray; // an Array of variantInventory Dictionaries
@property (strong, nonatomic) NSMutableArray *chosenSizesArray;
@property (assign, nonatomic) NSUInteger selectedCellIndexRow;

@property (strong, nonatomic) NSMutableArray *bagItemsArray;

@end


@implementation BTRProductShowcaseVC


- (NSMutableArray *)bagItemsArray {
    
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}


- (NSMutableArray *)chosenSizesArray {
    
    if (!_chosenSizesArray) _chosenSizesArray = [[NSMutableArray alloc] init];
    return _chosenSizesArray;
}



- (NSMutableArray *)attributesArray {
    
    if (!_attributesArray) _attributesArray = [[NSMutableArray alloc] init];
    return _attributesArray;
}


- (NSMutableArray *)variantInventoriesArray {
    
    if (!_variantInventoriesArray) _variantInventoriesArray = [[NSMutableArray alloc] init];
    return _variantInventoriesArray;
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
    
    [self setSelectedCellIndexRow:NSUIntegerMax];

    
    [self.eventTitleLabel setText:[self eventTitleString]];
    
    self.headerView.backgroundColor = [BTRViewUtility BTRBlack];
    self.view.backgroundColor = [BTRViewUtility BTRBlack];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchItemsforEventSku:[self eventSku]
                         success:^(NSDictionary *responseDictionary) {
                   
                             [self.collectionView reloadData];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             
                         }];
}




#pragma mark - Load Event Products RESTful



- (void)fetchItemsforEventSku:(NSString *)eventSku
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
         
         for (NSDictionary *itemDic in entitiesPropertyList) {
             [self.variantInventoriesArray addObject:itemDic[@"variant_inventory"]];
             [self.attributesArray addObject:itemDic[@"attributes"]];
         }
         
         self.itemArray = [Item loadItemsfromAppServerArray:entitiesPropertyList withEventId:[self eventSku] forItemsArray:[self itemArray]];
         
         for (int i = 0; i < [self.itemArray count]; i++)
             [self.chosenSizesArray addObject:[NSNumber numberWithInt:-1]];
         
         success([self itemArray]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}




- (void)cartIncrementServerCallforSessionId:(NSString *)sessionId
                             addProductItem:(Item *)productItem
                                withVariant:(NSString *)variant
                                    success:(void (^)(id  responseObject)) success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    NSDictionary *params = (@{
                              @"event_id": [productItem eventId],
                              @"sku": [productItem sku],
                              @"variant": variant
                              });
    
    [manager POST:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              NSArray *bagJsonArray = entitiesPropertyList[@"bag"][@"reserved"];
              NSDate *serverTime = [NSDate date];
              
              [[self bagItemsArray] removeAllObjects];
              self.bagItemsArray = [BagItem loadBagItemsfromAppServerArray:bagJsonArray withServerDateTime:serverTime forBagItemsArray:[self bagItemsArray]];
              
              BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
              [sharedShoppingBag setBagItems:(NSArray *)[self bagItemsArray]];
              
              success(@"TRUE");
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              failure(operation, error);
              
          }];
}


#pragma mark - UICollectionView Datasource



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.itemArray count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRProductShowcaseCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductShowcaseCollectionCellIdentifier" forIndexPath:indexPath];
    
    BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:[self.variantInventoriesArray objectAtIndex:indexPath.row]
                                                 toSizesArray:[cell sizesArray]
                                             toSizeCodesArray:[cell sizeCodesArray]
                                          toSizeQuantityArray:[cell sizeQuantityArray]];

    Item *productItem = [self.itemArray objectAtIndex:indexPath.row];
    
    cell = [self configureViewForShowcaseCollectionCell:cell withItem:productItem andBTRSizeMode:sizeMode forIndexPath:indexPath];

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
    
    
    __block NSString *sizeLabelText = [cell.selectSizeButton.titleLabel text];
    __block NSString *selectedSizeString = @"";
    if ( [[[self chosenSizesArray] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:-1]] ) {
        selectedSizeString = @"Z";
    } else {
        selectedSizeString = [[cell sizeCodesArray] objectAtIndex:[[[self chosenSizesArray] objectAtIndex:[indexPath row]] integerValue]];
    }
    
    [cell setDidTapAddtoBagButtonBlock:^(id sender) {
    
        if ([sizeLabelText isEqualToString:SIZE_NOT_SELECTED_STRING]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Size" message:@"Please select a size!" delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            
            BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
            [self cartIncrementServerCallforSessionId:[sessionSettings sessionId] addProductItem:productItem withVariant:selectedSizeString  success:^(NSString *successString) {
                
                if ([successString isEqualToString:@"TRUE"]) {
                    
                    UIStoryboard *storyboard = self.storyboard;
                    BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }];
    
    return cell;
}


- (void)customActionPressed:(id)sender{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSelectSizeVC *viewController = (BTRSelectSizeVC *)[storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
    
    [self presentViewController:viewController animated:YES completion:nil];
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
            
        } else {
            
            cell.selectSizeButton.titleLabel.text = [NSString stringWithFormat:@"Size: %@", [[cell sizesArray] objectAtIndex:[[[self chosenSizesArray] objectAtIndex:[indexPath row]] integerValue]]];
        }
    }
    
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku]] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    
    [cell.productTitleLabel setText:[productItem shortItemDescription]];
    [cell.brandLabel setText:[productItem brand]];
    [cell.btrPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
    [cell.originalPrice setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
    
    return cell;
}


#pragma mark - Navigation


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    Item *productItem = [self.itemArray objectAtIndex:indexPath.row];
    [self setSelectedIndexPath:indexPath];
    [self setSelectedBrandString:[productItem brand]];
    [self performSegueWithIdentifier:@"ProductDetailSegueIdentifier" sender:self];
}


- (IBAction)bagButtonTapped:(UIButton *)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"ProductDetailSegueIdentifier"]) {
        
        BTRProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.originVCString = EVENT_SCENE;
        productDetailVC.productItem = [self.itemArray objectAtIndex:[self.selectedIndexPath row]];
        productDetailVC.eventId = [self eventSku];
        productDetailVC.variantInventoryDictionary = [self.variantInventoriesArray objectAtIndex:[self.selectedIndexPath row]];
        productDetailVC.attributesDictionary = [self.attributesArray objectAtIndex:[self.selectedIndexPath row]];
    }
}


- (IBAction)unwindFromProductDetailToShowcase:(UIStoryboardSegue *)unwindSegue
{

}





#pragma mark - BTRSelectSizeVC Delegate



- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    
    self.chosenSizesArray[self.selectedCellIndexRow] = [NSNumber numberWithInt:(int)selectedIndex];

    [self.collectionView reloadData];
}


@end















