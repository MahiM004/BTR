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

#import "Item+AppServer.h"
#import "BTRItemFetcher.h"

@interface BTRProductShowcaseVC () {
    long selectedIndex;
}

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;



@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *itemArray;

@end

@implementation BTRProductShowcaseVC


- (NSMutableArray *)itemArray {
    
    if (!_itemArray) _itemArray = [[NSMutableArray alloc] init];
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"country ignored: configureViewForShowcaseCollectionCell");

    
    [self.eventTitleLabel setText:[self eventTitleString]];
    
    self.headerView.backgroundColor = [BTRViewUtility BTRBlack];
    self.view.backgroundColor = [BTRViewUtility BTRBlack];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    selectedIndex = -1;
    [self setupDocument];
    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument]
                     forEventSku:[self eventSku]
                         success:^(NSDictionary *responseDictionary) {
                             
                             [self.collectionView reloadData];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             
                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforAllItemsWithEventSku:eventSku]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSArray *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                              options:0
                                                                                error:NULL];
         
         [self.itemArray addObjectsFromArray:[Item loadItemsFromAppServerArray:entitiesPropertyList intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext]];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
         
         success([self itemArray]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}

#pragma mark - UICollectionView Datasource



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.itemArray count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRProductShowcaseCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductShowcaseCollectionCellIdentifier" forIndexPath:indexPath];
    Item *productItem = [self.itemArray objectAtIndex:indexPath.row];

    cell = [self configureViewForShowcaseCollectionCell:cell withItem:productItem];
    
    return cell;
}


- (BTRProductShowcaseCollectionCell *)configureViewForShowcaseCollectionCell:(BTRProductShowcaseCollectionCell *)cell withItem:(Item *)productItem {

    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku]] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
    
    [cell.productTitleLabel setText:[productItem shortItemDescription]];
    [cell.brandLabel setText:[productItem brand]];
    [cell.btrPriceLabel setAttributedText:[BTRViewUtility crossedOffTextFrom:[NSString stringWithFormat:@"$%@",[productItem retailCAD]]]];
    [cell.originalPrice setText:[NSString stringWithFormat:@"$%@", [[productItem clearancePriceCAD] stringValue]]];
 
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
    
    selectedIndex = indexPath.row;
    
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor lightGrayColor]; // highlight selection
    
    [self performSegueWithIdentifier:@"ProductDetailSegueIdentifier" sender:self];
}


- (IBAction)bagButtonTapped:(UIButton *)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)searchIconTapped:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRProductShowcaseVC *viewController = (BTRProductShowcaseVC *)[storyboard instantiateViewControllerWithIdentifier:@"SearchNavigationControllerIdentifier"];
    
    [self presentViewController:viewController animated:NO completion:nil];
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    /*
    if ([[segue identifier] isEqualToString:@"ProductDetailSegueIdentifier"])
    {
        BTRProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.someString = [NSString stringWithFormat:@"Some Detail Scene %ld", selectedIndex];
    }
     */
    
}



@end
