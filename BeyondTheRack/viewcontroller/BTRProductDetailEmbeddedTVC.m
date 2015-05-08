//
//  BTRProductDetailEmbededTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-05.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailEmbeddedTVC.h"

#import "BTRProductImageCollectionCell.h"
#import "BTRZoomImageViewController.h"

#import "BTRItemFetcher.h"
#import "NSString+HeightCalc.h"


@interface BTRProductDetailEmbeddedTVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *crossedOffPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *longDescriptionView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectSizeButton;
@property (weak, nonatomic) IBOutlet UILabel *dropdownLabelIcon;

@property (weak, nonatomic) IBOutlet UILabel *selectSizeLabel;



@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSInteger customHeight;
@property (nonatomic) NSInteger descriptionCellHeight;

@property (strong, nonatomic) NSString *productSku;
@property (nonatomic) NSInteger productImageCount;

@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *sizeCodesArray;
@property (strong, nonatomic) NSMutableArray *sizeQuantityArray;

@property (strong, nonatomic) NSMutableArray *attributeKeys;
@property (strong, nonatomic) NSMutableArray *attributeValues;

@property (nonatomic) NSUInteger selectedSizeIndex;


@end


@implementation BTRProductDetailEmbeddedTVC

@synthesize customHeight;
@synthesize descriptionCellHeight;

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


- (NSMutableArray *)attributeKeys {
    
    if (!_attributeKeys) _attributeKeys = [[NSMutableArray alloc] init];
    return _attributeKeys;
}


- (NSMutableArray *)attributeValues {
    
    if (!_attributeValues) _attributeValues = [[NSMutableArray alloc] init];
    return  _attributeValues;
}


 
- (void)setProductImageCount:(NSInteger)productImageCount {
    
    _productImageCount = productImageCount;
    
    if(productImageCount <= 1)
        productImageCount = 1;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dropdownLabelIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.dropdownLabelIcon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-caret-down"];
    
    
    self.selectedSizeIndex = -1;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    [self setupDocument];
    [self updateViewWithItem:[self productItem]];

    if ([[self productItem] sku] && ![[[self productItem] sku] isEqual:[NSNull null]])
        [self fetchItemIntoDocument:[self beyondTheRackDocument] forProductSku:[[self productItem] sku]
                            success:^(Item *responseObject, NSString * singleSizeBoolString) {
                                
                                [self updateViewWithDeatiledItem:responseObject];
                                
                                if ([singleSizeBoolString isEqualToString:@"TRUE"]) {
                                    
                                    [self.selectSizeLabel setAttributedText:[BTRViewUtility crossedOffStringfromString:@"Select Size :"]];
                                    [self.selectSizeLabel setAlpha:0.4];
                                    [self.selectSizeButton setEnabled:false];
                                    [self.sizeLabel setText:@"One Size"];
                                    [self.sizeLabel setTextColor:[UIColor blackColor]];
                                    [self.dropdownLabelIcon setHidden:YES];
                                    
                                    if ([self.delegate respondsToSelector:@selector(variantCodeforAddtoBag:)]) {
                                        [self.delegate variantCodeforAddtoBag:@"Z"];
                                    }
                                    
                                }
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
}


#pragma mark - Update Detail View


- (void)updateViewWithDeatiledItem:(Item *)productItem {
   
    [self updateViewWithItem:productItem];
    
    
    UIView *descriptionView = [[UIView alloc] init];
    descriptionView = [self getDescriptionViewForView:descriptionView withDescriptionString:[productItem longItemDescription]];
    descriptionView = [self getAttribueViewForView:descriptionView];
    descriptionView = [self getSpecialNoteView:descriptionView withSpecialNote:[productItem specialNote]];
    
    [self.longDescriptionView addSubview:descriptionView];
 
    [self.collectionView reloadData];
}


- (void)updateViewWithItem:(Item *)productItem {
    
    
    self.productImageCount = [[productItem imageCount] integerValue];
    
    if (productItem)
    {
        [self setProductSku:[productItem sku]];
        [self.brandLabel setText:[productItem brand]];
        [self.shortDescriptionLabel setText:[productItem shortItemDescription]];
        [self.salePriceLabel setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
        [self.crossedOffPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
    
    } else {
    
        [self.brandLabel setText:@""];
        [self.shortDescriptionLabel setText:@""];
        [self.salePriceLabel setText:@""];
        [self.crossedOffPriceLabel setText:@""];
        
    }
 

    [self.collectionView reloadData];
}


#pragma mark - Construct Description Views



- (UIView *)getDescriptionViewForView:(UIView *)descriptionView withDescriptionString:(NSString *)longDescriptionString {
  
    customHeight = 0;
    
    NSString *descriptionString = longDescriptionString;
    
    NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
    
    if ([descriptionString length] == 0 || [descriptionString isEqual:[NSNull null]]) {
        
        descriptionString = @"no descriptions available for this item.";
    }
    
    [descriptionArray addObjectsFromArray:[descriptionString componentsSeparatedByString:@"."]];
    [descriptionArray removeLastObject];
    
    for (int i = 0; i < [descriptionArray count]; i++) {
        
        NSString *labelText = [NSString stringWithFormat:@" - %@.", [descriptionArray objectAtIndex:i]];
        UIFont *descriptionFont =  [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        
        int labelHeight = [labelText heightForWidth:self.longDescriptionView.bounds.size.width usingFont:descriptionFont];
        CGRect labelFrame = CGRectMake(0, customHeight, self.longDescriptionView.bounds.size.width, labelHeight);

        customHeight = customHeight + (labelHeight + 5);
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [myLabel setFont:descriptionFont];
        [myLabel setText:labelText];
        [myLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [myLabel sizeToFit];
        [myLabel setTextAlignment:NSTextAlignmentLeft];
        
        [descriptionView addSubview:myLabel];
    }
    
    customHeight = customHeight + 15;
    
    return descriptionView;
}


- (UIView *)getAttribueViewForView:(UIView *)attributeView {

    for (int i = 0; i < [self.attributeKeys count]; i++) {
        
        NSString *attributeText = [NSString stringWithFormat:@"    %@ : %@", [self.attributeKeys objectAtIndex:i], [self.attributeValues objectAtIndex:i]];
        UIFont *attributeFont =  [UIFont fontWithName:@"HelveticaNeue" size:12];
        
        int attributeHeight = [attributeText heightForWidth:self.longDescriptionView.bounds.size.width usingFont:attributeFont];
        CGRect attributeFrame = CGRectMake(0, customHeight, self.longDescriptionView.bounds.size.width, attributeHeight);
        
        customHeight = customHeight + (attributeHeight + 5);
        
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:attributeFrame];
        
        [attributeLabel setFont:attributeFont];
        [attributeLabel setText:attributeText];
        [attributeLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [attributeLabel sizeToFit];
        [attributeLabel setTextAlignment:NSTextAlignmentLeft];
        
        [attributeView addSubview:attributeLabel];
    }

    
    return attributeView;
}

- (UIView *)getSpecialNoteView:(UIView *)specialNoteView withSpecialNote:(NSString *)specialNoteString {

    
    if ([specialNoteString length] > 2) {
        
        
        customHeight += 20;

        
        NSString *specialNoteLabelText = [NSString stringWithFormat:@"Special Note: %@", specialNoteString];
        UIFont *specialNoteFont =  [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        
        int specialNoteLabelHeight = [specialNoteLabelText heightForWidth:self.longDescriptionView.bounds.size.width usingFont:specialNoteFont];
        CGRect specialNoteFrame = CGRectMake(0, customHeight, self.longDescriptionView.bounds.size.width, specialNoteLabelHeight);
        
        customHeight = customHeight + specialNoteLabelHeight + 10;
        UILabel *specialNoteLabel = [[UILabel alloc] initWithFrame:specialNoteFrame];
        
        [specialNoteLabel setFont:specialNoteFont];
        [specialNoteLabel setText:specialNoteLabelText];
        [specialNoteLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [specialNoteLabel sizeToFit];
        [specialNoteLabel setTextAlignment:NSTextAlignmentLeft];
        
        [specialNoteView addSubview:specialNoteLabel];
    }
    
    self.descriptionCellHeight = customHeight + 80;
    
    
    return specialNoteView;
}



#pragma mark - UICollectionView Datasource



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self productImageCount];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRProductImageCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductImageCollectionCellIdentifier" forIndexPath:indexPath];
    
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]
                                                                       withCount:1+indexPath.row
                                                                         andSize:@"large"]
                          placeholderImage:[UIImage imageNamed:@"neulogo.png"]];

    return cell;
}



#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        
        case 0:
            return 312;
            break;
            
        case 1:
            return 174;
            break;
            
        case 2:
            return [self descriptionCellHeight];
            break;
            
        case 3:
            return 206;
            break;
            
        default:
            break;
    }
    
    return 1;
}


#pragma mark - Load Product Detail RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}



- (void)fetchItemIntoDocument:(UIManagedDocument *)document forProductSku:(NSString *)productSku
                       success:(void (^)(id  responseObject, id oneSizeBoolString)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                         options:0
                                                                           error:NULL];
    
         enum btrSizeMode sizeMode = [self extractSizesFromVarianInventoryDictionary:entitiesPropertyList[@"variant_inventory"]];
         [self extractAttributsFromAttributesDictionary:entitiesPropertyList[@"attributes"]];
         
         Item *productItem = [Item itemWithAppServerInfo:entitiesPropertyList inManagedObjectContext:document.managedObjectContext withEventId:[self eventId]];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        
         NSString *sizeBoolString = @"FALSE";
         if (sizeMode == btrSizeModeSingleSizeShow || sizeMode == btrSizeModeSingleSizeNoShow)
             sizeBoolString = @"TRUE";

         success(productItem, sizeBoolString);

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}



#pragma mark -  Handle JSON with Arbitrary Keys (variant_inventory and attributes)


- (void) extractAttributsFromAttributesDictionary:(NSDictionary *)attributeDictionary {
    
 
    [attributeDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *keyString = key;
        NSString *objString = obj;
        
        if (![keyString isEqualToString:@""]) {
            
            [[self attributeKeys] addObject:keyString];
            [[self attributeValues] addObject:objString];
        }
        
    }];
    
}


- (enum btrSizeMode) extractSizesFromVarianInventoryDictionary: (NSDictionary *)variantInventoryDictionary {
    
    
    NSLog(@"sizzzz: %@", variantInventoryDictionary);
    
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


#pragma mark - Navigation



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"ZoomOnProductImageSegueIdentifier"]) {
        
        BTRZoomImageViewController *zoomVC = [segue destinationViewController];
        zoomVC.productSkuString = [self productSku];
        zoomVC.zoomImageCount = [self productImageCount];
    
    }
}



- (IBAction)selectSizeTapped:(UIButton *)sender {

    UIStoryboard *storyboard = self.storyboard;
    BTRSelectSizeVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
    
    vc.sizesArray = [self sizesArray];
    vc.sizeQuantityArray = [self sizeQuantityArray];
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}



- (IBAction)unwindFromImageZoomToProductDetail:(UIStoryboardSegue *)unwindSegue
{
    
}


- (IBAction)unwindFromSelectSizeToProductDetail:(UIStoryboardSegue *)unwindSegue
{
    
}



#pragma mark - BTRSelectSizeVC Delegate



- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    
    self.selectedSizeIndex = selectedIndex;
    self.sizeLabel.text = [[self sizesArray] objectAtIndex:selectedIndex];
    
    if ([self.delegate respondsToSelector:@selector(variantCodeforAddtoBag:)]) {
        [self.delegate variantCodeforAddtoBag:[[self sizeCodesArray] objectAtIndex:[self selectedSizeIndex]]];
    }
    
    
}





@end





















