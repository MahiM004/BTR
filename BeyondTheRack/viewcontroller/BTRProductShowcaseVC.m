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

#define SIZE_PICKER     1
#define SORT_PICKER      2

@interface BTRProductShowcaseVC ()

@property (strong, nonatomic) NSIndexPath *selectedIndexPath; // used to segue to PDP
@property (strong, nonatomic) NSString *selectedBrandString; // used to segue to PDP
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (strong, nonatomic) NSMutableArray *originalItemArray;
@property (copy, nonatomic) NSMutableArray *variantInventoriesArray; // an Array of variantInventory Dictionaries
@property (copy, nonatomic) NSMutableArray *attributesArray; // an Array of variantInventory Dictionaries

@property (strong, nonatomic) NSMutableArray *chosenSizesArray;
@property (assign, nonatomic) NSUInteger selectedCellIndexRow;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;


// sort and filter
@property (strong, nonatomic) NSArray* collectionViewResourceArray;
@property (strong, nonatomic) NSArray* sortedItemsArray;

@property (strong, nonatomic) NSArray* sizeArray;
@property (strong, nonatomic) NSArray* sortArray;

// textFields

@property (weak, nonatomic) IBOutlet UITextField *filterSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *sortTextField;


// picker

@property (nonatomic) NSUInteger pickerType;

@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end


@implementation BTRProductShowcaseVC


- (NSArray *)collectionViewResourceArray {
    if ([self.sortTextField.text isEqualToString:@"Suggested"])
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



- (NSMutableArray *)attributesArray {
    
    if (!_attributesArray) _attributesArray = [[NSMutableArray alloc] init];
    return _attributesArray;
}


- (NSMutableArray *)variantInventoriesArray {
    
    if (!_variantInventoriesArray) _variantInventoriesArray = [[NSMutableArray alloc] init];
    return _variantInventoriesArray;
}


- (NSMutableArray *)originalItemArray {
    if (!_originalItemArray) _originalItemArray = [[NSMutableArray alloc] init];
    return _originalItemArray;
}

- (NSArray *)sortArray {
    if (!_sortArray) _sortArray = [[NSArray alloc]initWithObjects:@"Suggested",@"Discount Increasing",@"Discount Decreasing",@"Price Increasing",@"Price Decreasing",@"Type", nil];
    return _sortArray;
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
                             
                         } failure:^(NSError *error) {
                             
                         }];
}




#pragma mark - Load Event Products RESTful



- (void)fetchItemsforEventSku:(NSString *)eventSku
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure
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
         
         self.originalItemArray = [Item loadItemsfromAppServerArray:entitiesPropertyList withEventId:[self eventSku] forItemsArray:[self originalItemArray]];
         
         for (int i = 0; i < [self.originalItemArray count]; i++)
             [self.chosenSizesArray addObject:[NSNumber numberWithInt:-1]];
         
         success([self originalItemArray]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(error);
     }];
    
}




- (void)cartIncrementServerCallforSessionId:(NSString *)sessionId
                             addProductItem:(Item *)productItem
                                withVariant:(NSString *)variant
                                    success:(void (^)(id  responseObject)) success
                                    failure:(void (^)(NSError *error)) failure
{
    [[self bagItemsArray] removeAllObjects];

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
              
              NSArray *bagJsonReservedArray = entitiesPropertyList[@"bag"][@"reserved"];
              NSArray *bagJsonExpiredArray = entitiesPropertyList[@"bag"][@"expired"];
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
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              failure(error);
              
          }];
}


#pragma mark - UICollectionView Datasource

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width / 2 - 1, 410);
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.collectionViewResourceArray count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRProductShowcaseCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductShowcaseCollectionCellIdentifier" forIndexPath:indexPath];
    
    BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:[self.variantInventoriesArray objectAtIndex:indexPath.row]
                                                 toSizesArray:[cell sizesArray]
                                             toSizeCodesArray:[cell sizeCodesArray]
                                          toSizeQuantityArray:[cell sizeQuantityArray]];

    Item *productItem = [self.collectionViewResourceArray objectAtIndex:indexPath.row];
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
                
            } failure:^(NSError *error) {

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
            [cell.selectSizeButton setAlpha:1.0];
            [cell.selectSizeButton setEnabled:true];
            
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
    
    Item *productItem = [self.originalItemArray objectAtIndex:indexPath.row];
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
        productDetailVC.productItem = [self.originalItemArray objectAtIndex:[self.selectedIndexPath row]];
        productDetailVC.eventId = [self eventSku];
        productDetailVC.variantInventoryDictionary = [self.variantInventoriesArray objectAtIndex:[self.selectedIndexPath row]];
        productDetailVC.attributesDictionary = [self.attributesArray objectAtIndex:[self.selectedIndexPath row]];
    }
}


- (IBAction)unwindFromProductDetailToShowcase:(UIStoryboardSegue *)unwindSegue
{

}


#pragma mark - Filter & Suggestion

- (IBAction)pickerParentTapped:(id)sender {
    [self.pickerParentView setHidden:YES];
}

- (IBAction)sizeSelectionTapped:(id)sender {
    [self loadPickerViewforType:SIZE_PICKER];
}

- (IBAction)sortSelectionTapped:(id)sender {
    [self loadPickerViewforType:SORT_PICKER];
}


#pragma mark PickerView

- (void)loadPickerViewforType:(NSUInteger)type {
    [self setPickerType:type];
    [self.pickerView reloadAllComponents];
    [self.pickerParentView setHidden:FALSE];
    [self.pickerView becomeFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerType == SIZE_PICKER)
        return [self.sizeArray count];
    if (self.pickerType == SORT_PICKER)
        return [self.sortArray count];
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    [self.pickerParentView setHidden:TRUE];
    
    if ([self pickerType] == SORT_PICKER) {
        
        
        if ([self.sortTextField.text isEqualToString:[self.sortArray objectAtIndex:row]])
            return; // we dont need reload collectionView
        
        [self.sortTextField setText:[self.sortArray objectAtIndex:row]];
        
        NSSortDescriptor *sortDescriptor;
        switch (row) {
            case 0:
                break;
            case 1:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"discount" ascending:YES];
                break;
            case 2:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"discount" ascending:NO];
                break;
            case 3:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"salePrice" ascending:YES];
                break;
            case 4:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"salePrice" ascending:NO];
                break;
            case 5:
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sku" ascending:YES];
                break;
            default:
                break;
        }
        
        
        
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.sortedItemsArray = [self.originalItemArray sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    if ([self pickerType] == SIZE_PICKER) {
        [self.filterSizeTextField setText:[self.sizeArray objectAtIndex:row]];
    }
    
    [self.collectionView reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.adjustsFontSizeToFitWidth = YES;
        tView.textAlignment = NSTextAlignmentCenter;
    }
    if (self.pickerType == SORT_PICKER)
        [tView setText:[self.sortArray objectAtIndex:row]];
    if (self.pickerType == SIZE_PICKER)
        [tView setText:[self.sizeArray objectAtIndex:row]];
    return tView;
}

#pragma mark - BTRSelectSizeVC Delegate



- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    
    self.chosenSizesArray[self.selectedCellIndexRow] = [NSNumber numberWithInt:(int)selectedIndex];

    [self.collectionView reloadData];
}


@end















