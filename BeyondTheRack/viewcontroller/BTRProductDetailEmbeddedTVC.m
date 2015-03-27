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


@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@property (nonatomic) int descriptionCellHeight;
@property (strong, nonatomic) NSString *productSku;
@property (nonatomic) NSInteger productImageCount;

@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *sizeCodesArray;
@property (strong, nonatomic) NSMutableArray *sizeQuantityArray;


@property (strong, nonatomic) NSMutableArray *attributeKeys;
@property (strong, nonatomic) NSMutableArray *attributeValues;

@end


@implementation BTRProductDetailEmbeddedTVC



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


/*
 
 
 */

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
}


- (void)setProductImageCount:(NSInteger)productImageCount {
    
    _productImageCount = productImageCount;
    
    if(productImageCount <= 1)
        productImageCount = 1;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    [self setupDocument];
   // [self updateViewWithItem:[self productItem]];

    if ([[self productItem] sku] && ![[[self productItem] sku] isEqual:[NSNull null]])
        [self fetchItemIntoDocument:[self beyondTheRackDocument] forProductSku:[[self productItem] sku]
                            success:^(Item *responseObject) {
                                
                                [self updateViewWithItem:responseObject];
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
}


#pragma mark - Update Detail View



- (void)updateViewWithItem:(Item *)productItem {
    
    
    self.productImageCount = [[productItem imageCount] integerValue];
    
    if (productItem)
    {
        [self setProductSku:[productItem sku]];
        [self.brandLabel setText:[productItem brand]];
        [self.shortDescriptionLabel setText:[productItem shortItemDescription]];
        [self.salePriceLabel setText:[BTRViewUtility priceStringFromNumber:[productItem priceCAD]]];
        [self.crossedOffPriceLabel setAttributedText:[BTRViewUtility crossedOffPriceFromNumber:[productItem retailCAD]]];
    
    } else {
    
        [self.brandLabel setText:@""];
        [self.shortDescriptionLabel setText:@""];
        [self.salePriceLabel setText:@""];
        [self.crossedOffPriceLabel setText:@""];
        
    }
    
    UIView *descriptionView = [[UIView alloc] init];
    descriptionView = [self getDescriptionViewForView:descriptionView withDescriptionString:[productItem longItemDescription] andSpecialNote:[productItem specialNote]];
    [self.longDescriptionView addSubview:descriptionView];
 
    
    [self.collectionView reloadData];
}



- (UIView *)getDescriptionViewForView:(UIView *)descriptionView withDescriptionString:(NSString *)longDescriptionString andSpecialNote:(NSString *)specialNoteString {
  
    
    NSInteger customHeight = 80;
    NSInteger yPos = 0;
    
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
        CGRect labelFrame = CGRectMake(0, yPos, self.longDescriptionView.bounds.size.width, labelHeight);

        yPos = yPos + (labelHeight + 5);
        customHeight = customHeight + labelHeight + 10;
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [myLabel setFont:descriptionFont];
        [myLabel setText:labelText];
        [myLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [myLabel sizeToFit];
        [myLabel setTextAlignment:NSTextAlignmentLeft];
        
        [descriptionView addSubview:myLabel];
    }
    
    yPos = yPos + 15;
        
    for (int i = 0; i < [self.attributeKeys count]; i++) {
        
        NSString *attributeText = [NSString stringWithFormat:@"    %@ : %@", [self.attributeKeys objectAtIndex:i], [self.attributeValues objectAtIndex:i]];
        UIFont *attributeFont =  [UIFont fontWithName:@"HelveticaNeue" size:12];
        
        int attributeHeight = [attributeText heightForWidth:self.longDescriptionView.bounds.size.width usingFont:attributeFont];
        CGRect attributeFrame = CGRectMake(0, yPos, self.longDescriptionView.bounds.size.width, attributeHeight);
        
        yPos = yPos + (attributeHeight + 5);
        customHeight = customHeight + attributeHeight + 10;
        
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:attributeFrame];
        
        [attributeLabel setFont:attributeFont];
        [attributeLabel setText:attributeText];
        [attributeLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [attributeLabel sizeToFit];
        [attributeLabel setTextAlignment:NSTextAlignmentLeft];
        
        [descriptionView addSubview:attributeLabel];
    }

    
    if ([specialNoteString length] > 2) {
        
        NSString *specialNoteLabelText = [NSString stringWithFormat:@"Special Note: %@.", specialNoteString];
        UIFont *specialNoteFont =  [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        
        int specialNoteLabelHeight = [specialNoteLabelText heightForWidth:self.longDescriptionView.bounds.size.width usingFont:specialNoteFont];
        CGRect specialNoteFrame = CGRectMake(0, customHeight - 80, self.longDescriptionView.bounds.size.width, specialNoteLabelHeight);
        
        customHeight = customHeight + specialNoteLabelHeight + 10;
        UILabel *specialNoteLabel = [[UILabel alloc] initWithFrame:specialNoteFrame];
        
        [specialNoteLabel setFont:specialNoteFont];
        [specialNoteLabel setText:specialNoteLabelText];
        [specialNoteLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [specialNoteLabel sizeToFit];
        [specialNoteLabel setTextAlignment:NSTextAlignmentLeft];
        
        [descriptionView addSubview:specialNoteLabel];
    }
    
 
    [descriptionView sizeToFit];
    self.descriptionCellHeight = customHeight;
    
    return descriptionView;
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
            return 162;
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
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                         options:0
                                                                           error:NULL];
         
         [self extractSizesFromVarianInventoryDictionary:entitiesPropertyList[@"variant_inventory"]];
         [self extractAttributsFromAttributesDictionary:entitiesPropertyList[@"attributes"]];
         
         Item *productItem = [Item itemWithAppServerInfo:entitiesPropertyList inManagedObjectContext:document.managedObjectContext];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        
         success(productItem);
         
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
    
    
    NSString *keyString = @"";
    NSArray *allKeys = [variantInventoryDictionary allKeys];
   
    if ([allKeys count] == 0) {
        
        NSLog(@"no info");
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
    
    
    if ([[segue identifier] isEqualToString:@"ZoomOnProductImageSegueIdentifier"])
    {
        BTRZoomImageViewController *zoomVC = [segue destinationViewController];
        zoomVC.productSkuString = [self productSku];
        zoomVC.zoomImageCount = [self productImageCount];
    }
    
}





- (IBAction)unwindFromImageZoomToProductDetail:(UIStoryboardSegue *)unwindSegue
{
    
}



@end





















