//
//  BTRProductDetailEmbededVC.m
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 04/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailEmbededVC.h"
#import "BTRProductDetailCellDetail.h"
#import "BTRProductDetailImageCell.h"
#import "BTRProductDetailNameCell.h"
#import "BTRProductCollecCell.h"
#import "BTRProductShareCell.h"
#import "BTRProductImageCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "BTRShoppingBagViewController.h"
#import "BTRProductShowcaseVC.h"
#import "BTRBagFetcher.h"
#import "BagItem+AppServer.h"
#import "BTRItemFetcher.h"
#import "BTRConnectionHelper.h"
#import "BTRLoader.h"
#import "NSString+HeightCalc.h"
#import "BTRHTMLSizeChartViewController.h"
#import "PKYStepper.h"
#import "BTRSizeHandler.h"
#import <Social/Social.h>
#import "PinterestSDK.h"
#import "BTRZoomImageViewController.h"
#import "UIImageView+AFNetworkingFadeIn.h"
#import "BTRSettingManager.h"
#import "CustomIOSAlertView.h"
#import "loadPopView.h"
#import "SKUContents+AppServer.h"
#import "BTRSKUContentFetcher.h"
#import "SDVersion.h"

#define SIZE_NOT_SELECTED_STRING @"-1"
#define SOCIAL_MEDIA_INIT_STRING @"Check out this great sale from Beyond the Rack!"

@interface BTRProductDetailEmbededVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    BOOL selectedAddWithOutSize;
    UIView * view1;
    UIView * view2;
    UITableView * detailTV;
    BTRProductDetailCellDetail * detailCell;
    BTRProductDetailImageCell * imageCell;
    BTRProductDetailNameCell * nameCell;
    BTRProductShareCell * shareCell;
    UICollectionView *_collectionView;
    NSInteger decreaseNameCellSize;
    CustomIOSAlertView * customAlert;
    UIPageControl * iPadPageController;
    
    //Long Description Strings
    NSString *longDescString;
    NSString *additionalDescString;
    NSString *generalnoteString;
    NSString *specialNoteString;
    NSString *shipTimeString;
}

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (weak, nonatomic) IBOutlet UIButton *addTobagButton;
@property (weak, nonatomic) IBOutlet UIView *addToBagView;

@property (strong, nonatomic) NSString *productSku;
@property (nonatomic) NSUInteger selectedSizeIndex;
@property (nonatomic, strong) PKYStepper *stepper;
@property (nonatomic) NSInteger customHeight;
@property (nonatomic) NSInteger descriptionCellHeight;
@property (nonatomic) NSInteger productImageCount;
@property (strong, nonatomic) NSString *variant;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSMutableArray *bagItemsArray;
@property (strong, nonatomic) NSMutableArray *attributeKeys;
@property (strong, nonatomic) NSMutableArray *attributeValues;
@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *sizeCodesArray;
@property (strong, nonatomic) NSMutableArray *sizeQuantityArray;
@property (strong, nonatomic) NSDictionary *sizeReserved;

@property NSMutableArray * rowsArray;
@property operation lastOperation;
@end

@implementation BTRProductDetailEmbededVC
@synthesize customHeight,descriptionCellHeight;


- (NSMutableArray *)bagItemsArray {
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}
- (NSMutableArray *)attributeKeys {
    if (!_attributeKeys) _attributeKeys = [[NSMutableArray alloc] init];
    return _attributeKeys;
}
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
- (NSMutableArray *)attributeValues {
    if (!_attributeValues) _attributeValues = [[NSMutableArray alloc] init];
    return  _attributeValues;
}
- (void)setProductImageCount:(NSInteger)productImageCount {
    _productImageCount = productImageCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BTRRefreshManager sharedInstance]setTopViewController:self];
    if (self.variant == nil)
        self.variant = SIZE_NOT_SELECTED_STRING;
    if (!_rowsArray) {
        _rowsArray = [[NSMutableArray alloc]initWithObjects:@"imageCell",@"nameCell",@"detailCell",@"shareCell", nil];
    }
    _selectedSizeIndex = -1;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    if ([[[self getItem] brand] length] > 1)
        [self.eventTitleLabel setText:[[self getItem] brand]];
    else
        [self.eventTitleLabel setText:@""];
    
    CGRect frame = self.view.frame;
    CGFloat viewWidth = frame.size.width;
    CGFloat viewHeight = frame.size.height;
    view1 = [[UIView alloc]initWithFrame:CGRectMake(10, 70, viewWidth - 20, viewHeight/2 - 70)];
    view1.backgroundColor = [UIColor whiteColor];
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(10, viewHeight/2 + 10, viewWidth - 20, viewHeight/2 - 20)];
    view2.backgroundColor = [UIColor greenColor];
    
    detailTV = [[UITableView alloc]initWithFrame:view2.frame];
    detailTV.delegate = self;
    detailTV.dataSource = self;
    detailTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view2 addSubview:detailTV];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    view1.hidden = YES;
    view2.hidden = YES;
    detailTV.hidden = YES;
    [BTRLoader showLoaderInView:self.view];
   
    [BTRGAHelper logScreenWithName:[NSString stringWithFormat:@"product/%@",self.getItem.sku]];

    [self fetchItemforProductSku:[[self getItem] sku]
                         success:^(Item *responseObject) {
                             [self fillWithItem:responseObject];
                             [BTRLoader hideLoaderFromView:self.view];
                             view1.hidden = NO;
                             view2.hidden = NO;
                             detailTV.hidden = NO;
                         }
                         failure:^(NSError *error) {
                         }];
    if (self.disableAddToCart) {
        self.addTobagButton.enabled = NO;
        self.addToBagView.backgroundColor = [UIColor grayColor];
    }
    [PDKClient configureSharedInstanceWithAppId:@"1445223"];
}
- (BOOL)isItemSoldOutWithVariant:(NSArray *)variantArray {
    for (int i = 0; i < [variantArray count]; i++)
        if ([[variantArray objectAtIndex:i]intValue] > 0)
            return NO;
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    imageCell.pageController.currentPage = 0;
    iPadPageController.currentPage = 0;
    [UIView animateWithDuration:0.02 animations:^{
        [_collectionView performBatchUpdates:nil completion:nil];
    }];
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.01];
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
    [_collectionView removeFromSuperview];
    
}

- (void)fillWithItem:(Item*)item {
    [self extractAttributesFromAttributesDictionary:item.attributeDictionary];
    [self updateViewWithDeatiledItem:item];
}

#pragma UpdateView Size and View

- (void)updateViewWithDeatiledItem:(Item *)productItem {
    self.productImageCount = [[productItem imageCount] integerValue];
    if (productItem) {
        if (self.productImageCount == 1) {
            [imageCell.pgParentHeight setConstant:0];
            [imageCell.pgParentView setHidden:YES];
             [iPadPageController setHidden:YES];
        }
        imageCell.pageController.numberOfPages = self.productImageCount;
        iPadPageController.numberOfPages = self.productImageCount;
        [self setProductSku:[productItem sku]];
        NSString * brandText = productItem.brand;
        if (brandText.length != 0) {
            [nameCell.brandLabel setText:[productItem brand]];
        } else {
            [nameCell.brandHeight setConstant:0];
            decreaseNameCellSize += 20;
        }
        if (! [productItem.isFlatRate boolValue]) {
            [nameCell.flatShippingBtn setHidden:YES];
            [nameCell.flatShippingHeight setConstant:0];
            [nameCell.flatShippingTopMargin setConstant:0];
            decreaseNameCellSize += 28;
        }
        [nameCell.shortDescriptionLabel setText:[productItem shortItemDescription]];
        [nameCell.salePriceLabel setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
        [nameCell.crossedOffPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
        
        if ([productItem.allReserved boolValue] || self.disableAddToCart) {
            self.addTobagButton.enabled = NO;
            self.addTobagButton.backgroundColor = [UIColor grayColor];
        }
        
        CGRect stepperFrame = CGRectMake(0, 0, 90, 20);
        
        self.stepper = [[PKYStepper alloc] initWithFrame:stepperFrame];
        self.stepper.value = 1;
        
        self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
            if (stepper.value < 1)
                return;
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
            _quantity = stepper.countLabel.text;
        };
        
        [self.stepper setup];
        [nameCell.stepperView addSubview:self.stepper];
        
        BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:productItem.variantInventory
                                                                            toSizesArray:[self sizesArray]
                                                                        toSizeCodesArray:[self sizeCodesArray]
                                                                     toSizeQuantityArray:[self sizeQuantityArray]];
        self.sizeReserved = productItem.reserverdSizes;
        [self updateSizeSelectionViewforSizeMode:sizeMode];
        
        if ([self isItemSoldOutWithVariant:[self sizeQuantityArray]] && [[self getOriginalVCString] isEqualToString:BAG_SCENE]) {
            self.addTobagButton.enabled = NO;
            self.addTobagButton.backgroundColor = [UIColor grayColor];
            self.addToBagView.backgroundColor = [UIColor grayColor];
        }

        longDescString =  [self getLongDescription:[productItem longItemDescription]];
        additionalDescString = [self getAdditionalDescription];
        generalnoteString = [productItem generalNote];
        specialNoteString = [productItem specialNote];
        shipTimeString = [productItem shipTime];
        
        CGFloat screenWidth = self.view.frame.size.width;
        if ([BTRViewUtility isIPAD] && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
            screenWidth = screenWidth/2;
        
        [self loadDetailCellDescriptionWithWidth:screenWidth];
        
    } else {
        [nameCell.brandLabel setText:@""];
        [nameCell.shortDescriptionLabel setText:@""];
        [nameCell.salePriceLabel setText:@""];
        [nameCell.crossedOffPriceLabel setText:@""];
    }
    [detailTV reloadData];
    [_collectionView reloadData];
    
}

- (void)loadDetailCellDescriptionWithWidth:(CGFloat)width {
    descriptionCellHeight = 0;

    // Calculate Heights
    int labelHeight = [longDescString heightForWidth:width - 20 usingFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    int desc2Height = [additionalDescString heightForWidth:width - 20 usingFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    
    int genStringHeight = 0;
    int spclStringHeight = 0;
    int shipStringHeight = 0;
    
    if ([generalnoteString length] > 2)
        genStringHeight = [generalnoteString heightForWidth:width - 20 usingFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    else
        [detailCell.topMarginGenNote setConstant:0];
    
    if ([specialNoteString length] > 2)
        spclStringHeight = [specialNoteString heightForWidth:width - 20 usingFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    else
        [detailCell.topMarginSpclNote setConstant:0];
    
    if ([shipTimeString length] > 2)
        shipStringHeight = [shipTimeString heightForWidth:width - 20 usingFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    else
        [detailCell.topMarginTimeNote setConstant:0];
    
    
    //Height for Labels
    [detailCell.descHeight  setConstant:labelHeight];
    [detailCell.heightDesc2 setConstant:desc2Height];
    [detailCell.heightGenNote setConstant:genStringHeight];
    [detailCell.heightSpclNote setConstant:spclStringHeight];
    [detailCell.heightTimeNote setConstant:shipStringHeight];
    
    
    // Height For Cell
    descriptionCellHeight = labelHeight + desc2Height + genStringHeight + spclStringHeight + shipStringHeight;
    
    // Setting Texts
    [detailCell.detailLabel setText:longDescString];
    [detailCell.lblDesc2 setText:additionalDescString];
    [detailCell.lblGenNote setText:generalnoteString];
    [detailCell.lblSpclNote setText:specialNoteString];
    [detailCell.lblTimeNote setText:shipTimeString];
    
    [detailCell.lblSpclNote setTextColor:[UIColor redColor]];
    
}

- (NSString *)getLongDescription:(NSString *)longDesc {
    NSString * helloString = @"";
    if (longDesc.length == 0 || [longDesc isEqual:[NSNull null]]) {
        helloString = [NSString stringWithFormat:@"No description available for this item\n"];
    } else {
        NSArray * breakDescArr = [longDesc componentsSeparatedByString:@"|"];
        for (int i = 0; i < breakDescArr.count; i++) {
            NSString *labelText = [NSString stringWithFormat:@" - %@",breakDescArr[i]];
            helloString = [NSString stringWithFormat:@"%@%@\n",helloString,labelText];
        }
    }
        return helloString;
}

- (NSString*)getAdditionalDescription {
    NSString * helloString = @"";
    for (int j = 0; j < [self attributeKeys].count; j++) {
        NSString *attributeText = [NSString stringWithFormat:@"    %@ : %@", self.attributeKeys[j], self.attributeValues[j]];
        helloString = [NSString stringWithFormat:@"%@%@\n",helloString,attributeText];
    }
    helloString = [NSString stringWithFormat:@"%@\nITEM : %@",helloString,self.productSku];
    return helloString;
}

- (void)updateSizeSelectionViewforSizeMode:(BTRSizeMode)sizeMode {
    if (sizeMode == BTRSizeModeSingleSizeShow || sizeMode == BTRSizeModeSingleSizeNoShow) {

        [nameCell.selectSizeView setHidden:YES];
        [nameCell.selectSizeViewHeight setConstant:0];//32
        [nameCell.selectSizeViewTopMargin setConstant:0];//8
        
        [nameCell.sizeChartView setHidden:YES];
        [nameCell.sizeChartHeight setConstant:0];//38
        [nameCell.sizeChartTopConstraint setConstant:0];//8
        
        decreaseNameCellSize += 38 + 32 + 8 + 8;

        self.variant = @"Z";
    }
}

#pragma mark -  Handle JSON with Arbitrary Keys (attributes)

- (void) extractAttributesFromAttributesDictionary:(NSDictionary *)attributeDictionary {
    [attributeDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyString = key;
        NSString *objString = obj;
        if (![keyString isEqualToString:@""]) {
            [[self attributeKeys] addObject:keyString];
            [[self attributeValues] addObject:objString];
        }
    }];
}

#pragma TableView Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIdenti = [_rowsArray objectAtIndex:indexPath.row];
    
    if ([cellIdenti isEqual:@"imageCell"]) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        imageCell = (BTRProductDetailImageCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (imageCell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductDetailImageCell" owner:self options:nil];
            imageCell = [nib objectAtIndex:0];
            if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                CGFloat viewWidth = self.view.frame.size.width;
                CGFloat collectHeight = (screenBounds.size.height * 5.5) / 10 - 30;
                [imageCell.contentView addSubview:[self collectionView:CGRectMake(0, 0, viewWidth, collectHeight)]];
            }
        }
        return imageCell;
    }
    else if ([cellIdenti isEqual:@"nameCell"]) {
        nameCell = (BTRProductDetailNameCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (!nameCell) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductDetailNameCell" owner:self options:nil];
            nameCell = [nib objectAtIndex:0];
            [nameCell.flatShippingBtn addTarget:self action:@selector(flatRateShipping) forControlEvents:UIControlEventTouchUpInside];
            [nameCell.selectChart addTarget:self action:@selector(selectSizeChartAction) forControlEvents:UIControlEventTouchUpInside];
            [nameCell.selectSizeButton addTarget:self action:@selector(selectSizeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        }
        return nameCell;
    }
    else if ([cellIdenti isEqual:@"detailCell"]) {
        detailCell = (BTRProductDetailCellDetail*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (detailCell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductDetailCellDetail" owner:self options:nil];
            detailCell = [nib objectAtIndex:0];
            if (![BTRViewUtility isIPAD]) {
                CGFloat screenWidth = self.view.frame.size.width;
                [self loadDetailCellDescriptionWithWidth:screenWidth];
            }
        }
        return detailCell;
    }
    else if ([cellIdenti isEqual:@"shareCell"]) {
        shareCell = (BTRProductShareCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (shareCell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductShareCell" owner:self options:nil];
            shareCell = [nib objectAtIndex:0];
            [shareCell.twitterAction addTarget:self action:@selector(twitter:) forControlEvents:UIControlEventTouchUpInside];
            [shareCell.facebookAction addTarget:self action:@selector(shareOnFacebookTapped:) forControlEvents:UIControlEventTouchUpInside];
            [shareCell.emailAction addTarget:self action:@selector(shareOnEmailTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        return shareCell;
    }
    else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"Hello";
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    switch (indexPath.row) {
        case 0:
            if ([BTRViewUtility isIPAD]) {
                if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                    imageCell.contentView.hidden = NO;
                    return (screenBounds.size.height * 5.5) / 10;
                } else {
                    imageCell.contentView.hidden = YES;
                    return 0;
                }
            }else
                return (screenBounds.size.height * 5.5) / 10;
            break;
        case 1:
            return 260 - decreaseNameCellSize;
            break;
        case 2:
            return [self descriptionCellHeight] + 180; // 180 is default
            break;
        case 3:
            return 206;
            break;
        default:
            break;
    }
    return 1;
}


#pragma mark - Navigation

- (IBAction)backButtonTapped:(UIButton *)sender {
    if ([[self getOriginalVCString] isEqualToString:SEARCH_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToSearchScene" sender:self];
    
    if ([[self getOriginalVCString] isEqualToString:EVENT_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToShowcase" sender:self];
    
    if ([[self getOriginalVCString] isEqualToString:BAG_SCENE])
        [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)bagButtonTapped:(UIButton *)sender {
    if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        if ([[self getOriginalVCString] isEqualToString:BAG_SCENE]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        UIStoryboard *storyboard = self.storyboard;
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [self showLogin];
        [self setLastOperation:gotoBag];
    }
}

#pragma mark - RESTful Calls Add to bag methods
- (IBAction)addToBagTapped:(UIButton *)sender {
    if ([[self variant] isEqualToString:SIZE_NOT_SELECTED_STRING]) {
        selectedAddWithOutSize = YES;
        [self selectSizeButtonAction];
    } else {
        if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
            selectedAddWithOutSize = NO;
            [self addToBag];
        } else {
            [self showLogin];
            [self setLastOperation:addToBag];
        }
    }
}

- (void)addToBag {
    [BTRGAHelper logEventWithCatrgory:@"pdp" action:@"click" label:@"add to bag"];
    [BTRLoader showLoaderWithViewDisabled:self.view withLoader:NO withTag:555];
    [self cartIncrementServerCallWithSuccess:^(NSString *successString) {
        if ([successString isEqualToString:@"TRUE"]) {
            [BTRLoader removeLoaderFromViewDisabled:self.view withTag:555];
            if ([[self getOriginalVCString] isEqualToString:BAG_SCENE]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            UIStoryboard *storyboard = self.storyboard;
            BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [BTRLoader removeLoaderFromViewDisabled:self.view withTag:555];
    }];
}

- (void)cartIncrementServerCallWithSuccess:(void (^)(id  responseObject)) success
                                   failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]];
    [BTRConnectionHelper postDataToURL:url withParameters:[self itemParameters] setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSArray *errorResponseArray = [[response valueForKey:@"response"]valueForKey:@"response"];
        for (NSDictionary* errorResponse in errorResponseArray) {
            if (![errorResponse isEqual:[NSNull null]]) {
                if (![[errorResponse valueForKey:@"success"]boolValue]) {
                    if ([errorResponse valueForKey:@"error_message"]) {
                        NSString *errorMessage = [errorResponse valueForKey:@"error_message"];
                        errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                    }
                }
            }
        }
        [self updateBagWithDictionary:response];
        success(@"TRUE");
    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (void)updateBagWithDictionary:(NSDictionary *)entitiesPropertyList {
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
}

- (void)fetchItemforProductSku:(NSString *)productSku
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    NSString *url;
    BOOL sessionNeeded;
    if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku]];
        sessionNeeded = YES;
    } else {
        NSString *country = [[[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERLOCATION]lowercaseString];
        url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku forCountry:country]];
        sessionNeeded = NO;
    }
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response ,NSString *jSonString) {
        Item *productItem = [Item itemWithAppServerInfo:response withEventId:[self getEventID] withJsonString:jSonString];
        success(productItem);
    } faild:^(NSError *error) {
        failure(error);
    }];
    
    
//    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.validatesDomainName = NO;
//    [manager setSecurityPolicy:securityPolicy];
//    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
//    
//    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    manager.responseSerializer = serializer;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    if (sessionNeeded)
//        [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
//    
//    [manager.requestSerializer setValue:[[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERAGENT] forHTTPHeaderField:@"User-Agent"];
//    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

#pragma View Orientation Changes
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        view1.hidden = YES;
        // Portrait frames
        CGFloat viewWidth = screenBounds.size.width;
        CGFloat viewHeight = screenBounds.size.height;
        [view1 setFrame:CGRectMake(0, 75, 0, 0)];
        [view2 setFrame:CGRectMake(0, 75, viewWidth , viewHeight - 145)];
        [detailTV setFrame:CGRectMake(0, 0, viewWidth, viewHeight - 145)];
        
        
        CGFloat collectHeight = (screenBounds.size.height * 5.5) / 10 - 30;
        
        //When ever we change the Orientation we remove and readd the CollectionView
        NSArray *viewsToRemove = [imageCell.contentView subviews];
        for (UIView *v in viewsToRemove) {
            if (v.tag != 504 && v.tag != 444) {
                [v removeFromSuperview];
            }
        }
        
        [imageCell.contentView addSubview:[self collectionView:CGRectMake(0, 0, viewWidth, collectHeight)]];
        [detailTV beginUpdates];
        [self loadDetailCellDescriptionWithWidth:viewWidth];
        [detailTV endUpdates];
        
    } else {
        // Landscape frames
        if ([BTRViewUtility isIPAD]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [detailTV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            view1.hidden = NO;
            CGFloat viewWidth;
            CGFloat viewHeight;
            if (iOSVersionLessThan(@"8.0")) {
                viewWidth = screenBounds.size.height;
                viewHeight = screenBounds.size.width;
            }else {
                viewWidth = screenBounds.size.width;
                viewHeight = screenBounds.size.height;
            }
            
            UIView * pageController = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight - 145-37, viewWidth/2, 37)];
            pageController.tag = 505;
            iPadPageController = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, viewWidth/2, 37)];
            iPadPageController.pageIndicatorTintColor = [UIColor grayColor];
            iPadPageController.currentPageIndicatorTintColor = [UIColor redColor];
            iPadPageController.numberOfPages = [self productImageCount];
            [pageController addSubview:iPadPageController];
            [view1 setFrame:CGRectMake(0, 75, viewWidth / 2, viewHeight - 145)];
            [view2 setFrame:CGRectMake(viewWidth/2, 75, viewWidth / 2, viewHeight - 145)];
            [detailTV setFrame:CGRectMake(0, 0, viewWidth / 2, viewHeight - 145)];
            
            //When ever we change the Orientation we remove and readd the CollectionView
            NSArray *viewsToRemove = [view1 subviews];
            for (UIView *v in viewsToRemove) {
                if (v.tag != 504 || v.tag !=505) {
                    [v removeFromSuperview];
                }
            }
            
            [pageController addSubview:iPadPageController];
            [view1 addSubview:pageController];
            [view1 addSubview:[self collectionView:CGRectMake(0, 0, viewWidth / 2, viewHeight - 145-37)]];
            [detailTV beginUpdates];
            [self loadDetailCellDescriptionWithWidth:viewWidth/2];
            [detailTV endUpdates];
        }
    }
}

-(void)selectSizeChartAction {
    BTRHTMLSizeChartViewController * sizechart = [[BTRHTMLSizeChartViewController alloc]initWithNibName:@"BTRHTMLSizeChartViewController" bundle:nil];
    [self presentViewController:sizechart animated:YES completion:nil];
}

-(void)selectSizeButtonAction {
    UIStoryboard *storyboard = self.storyboard;
    BTRSelectSizeVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.sizeCodes = [self sizeCodesArray];
    vc.sizesArray = [self sizesArray];
    vc.sizeQuantityArray = [self sizeQuantityArray];
    vc.reservedSizes = self.sizeReserved;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - BTRSelectSizeVC Delegate
- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    self.selectedSizeIndex = selectedIndex;
    nameCell.sizeLabel.text = [[self sizesArray] objectAtIndex:selectedIndex];
    self.variant = [[self sizeCodesArray] objectAtIndex:selectedIndex];
    if (selectedAddWithOutSize == YES) {
        if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
            [self addToBag];
            selectedAddWithOutSize = NO;
        } else {
            [self showLogin];
            [self setLastOperation:addToBag];
        }
    }
}

#pragma mark - Social Media Sharing
- (void)shareOnFacebookTapped:(UIButton *)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]]]];
        [controller setInitialText:SOCIAL_MEDIA_INIT_STRING];
        [controller addImage:image];
        [controller addURL:[BTRItemFetcher URLtoShareforEventId:_getEventID withProductSku:[self productSku]]];
        [self presentViewController:controller animated:YES completion:Nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook not available"
                                                        message:@"Your facebook account is not setup on this phone!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void)twitter:(UIButton *)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]]]];
        [tweetSheet setInitialText:SOCIAL_MEDIA_INIT_STRING];
        [tweetSheet addImage:image];
        [tweetSheet addURL:[BTRItemFetcher URLtoShareforEventId:_getEventID withProductSku:[self productSku]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter not available"
                                                        message:@"Your twitter account is not setup on this phone!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void)shareOnEmailTapped:(UIButton *)sender  {
    if ([MFMailComposeViewController canSendMail] == NO) {
        [[[UIAlertView alloc]initWithTitle:@"No Mail Accounts" message:@"Please set up an Mail account in order to share." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    
    MFMailComposeViewController *emailVC = [[MFMailComposeViewController alloc]init];
    [emailVC setMailComposeDelegate:self];
    [emailVC setMessageBody:[NSString stringWithFormat:@"<HTML>%@</br><a href=\"%@\">%@</a><HTML>",SOCIAL_MEDIA_INIT_STRING,[BTRItemFetcher URLtoShareforEventId:_getEventID withProductSku:[self productSku]],[self productSku]] isHTML:YES];
    [self presentViewController:emailVC animated:YES completion:nil];
}

- (void)shareOnPinterestTapped:(UIButton *)sender {
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions,
                                                              PDKClientWritePublicPermissions,
                                                              PDKClientReadPrivatePermissions,
                                                              PDKClientWritePrivatePermissions,
                                                              PDKClientReadRelationshipsPermissions,
                                                              PDKClientWriteRelationshipsPermissions]
                                                withSuccess:^(PDKResponseObject *responseObject)
     {
         NSLog(@"%@",responseObject);
     } andFailure:^(NSError *error) {
         NSLog(@"%@",error);
     }];
    
    //    [[PDKClient sharedInstance]createPinWithImageURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]] link:[BTRItemFetcher URLtoShareforEventId:[self eventId] withProductSku:[self productSku]] onBoard:@"BeyondTheRack" description:SOCIAL_MEDIA_INIT_STRING withSuccess:^(PDKResponseObject *responseObject) {
    //
    //    } andFailure:^(NSError *error) {
    //        NSLog(@"%@",error);
    //    }];
    //
    //
    //
    //    [_pinterest createPinWithImageURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]]
    //                            sourceURL:[BTRItemFetcher URLtoShareforEventId:[self eventId] withProductSku:[self productSku]]
    //                          description:SOCIAL_MEDIA_INIT_STRING];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self productImageCount] == 0)
        return 1;
    return [self productImageCount];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cellImage";
    UINib *nib = [UINib nibWithNibName:@"BTRProductCollecCell" bundle: nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    BTRProductCollecCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellImage" forIndexPath:indexPath];
    [cell.productImage setImageWithURL:[BTRItemFetcher URLforItemImageForSkuWithDomain:[_getItem imagesDomain] withSku:[self productSku] withCount:1+indexPath.row andSize:@"large"] placeholderImage:nil fadeInWithDuration:0.5];
    
//    [cell.productImage setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]
//                                                                   withCount:1+indexPath.row
//                                                                     andSize:@"large"] placeholderImage:nil fadeInWithDuration:0.5];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if ([BTRViewUtility isIPAD]) {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            return CGSizeMake(screenBounds.size.width / 2 - 8,screenBounds.size.height - 200);
        } else
            return CGSizeMake(screenBounds.size.width -16 , (screenBounds.size.height * 5.5) / 10 - 35);
    } else {
        return CGSizeMake(collectionView.frame.size.width - 8, (screenBounds.size.height * 5.5) / 10 - 35);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BTRZoomImageViewController *zoomVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZoomImageVC"];
    zoomVC.productSkuString = [self productSku];
    zoomVC.productImageDomain = [_getItem imagesDomain];
    if ([self productImageCount] == 0)
        zoomVC.zoomImageCount = 1;
    else
        zoomVC.zoomImageCount = [self productImageCount];
    zoomVC.selectedIndex = indexPath;
    zoomVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:zoomVC animated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_collectionView) {
        CGFloat currentIndex = _collectionView.frame.size.width;
        float currentPage = _collectionView.contentOffset.x/currentIndex;
        if (0.0f != fmodf(currentPage, 1.0f))
        {
            imageCell.pageController.currentPage = currentPage + 1;
            iPadPageController.currentPage = currentPage + 1;
        }
        else
        {
            imageCell.pageController.currentPage = currentPage;
            iPadPageController.currentPage = currentPage;
        }
    }
}

-(UICollectionView *)collectionView:(CGRect)frame {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.pagingEnabled = YES;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    return _collectionView;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_collectionView performBatchUpdates:nil completion:nil];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    [_collectionView.collectionViewLayout invalidateLayout];
}

- (NSDictionary *)itemParameters {
    NSDictionary *params;
    if ([[self getItem]eventId]) {
        params = (@{
                    @"event_id": [[self getItem]eventId],
                    @"sku": [[self getItem] sku],
                    @"variant":[self variant],
                    @"quantity":[self quantity]
                    });
    } else
        params = (@{
                    @"sku": [[self getItem] sku],
                    @"variant":[self variant],
                    @"quantity":[self quantity]
                    });
//    NSDictionary *updateParam = (@{@"key1" : params});
    return params;
}

- (void)showLogin {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRLoginNavigation"];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidLogin:(NSNotification *) notification {
    if (self.lastOperation == addToBag)
        [self addToBag];
    if  (self.lastOperation == gotoBag)
        [self bagButtonTapped:nil];
    self.lastOperation = 0;
}

- (void)getCartCountServerCallWithSuccess:(void (^)(id  responseObject)) success
                                  failure:(void (^)(NSError *error)) failure {
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBagCount]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response ,NSString *jSonString) {
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

- (void)flatRateShipping {
    [BTRLoader showLoaderWithViewDisabled:self.view withLoader:YES withTag:143];
    NSString *url = [NSString stringWithFormat:@"%@",[BTRSKUContentFetcher URLForContent]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:NO contentType:kContentTypeJSON success:^(NSDictionary *response ,NSString *jSonString) {
        SKUContents *content = [[SKUContents alloc]init];
        [SKUContents extractSKUContentFromContentInformation:response forSKUContent:content];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePop)];
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"LoadPopView" owner:self options:nil];
        loadPopView * pop = [nib objectAtIndex:0];
        [pop.closeAction addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
        [pop.flatShipMessage setText:content.flatRateDropShipMessage];
        [pop.flatShipTitle setText:content.flatRateDropShipTitle];
        customAlert = [[CustomIOSAlertView alloc] init];
        [customAlert addGestureRecognizer:tap];
        [customAlert setButtonTitles:nil];
        [customAlert setContainerView:pop];
        [customAlert setUseMotionEffects:false];
        [customAlert show];
        [BTRLoader removeLoaderFromViewDisabled:self.view withTag:143];
    } faild:^(NSError *error) {
        [BTRLoader removeLoaderFromViewDisabled:self.view withTag:143];
    }];
}

-(void)closePop {
    [customAlert close];
}

#pragma mark - Email Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
