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
#import "BTRSizeChartViewController.h"
#import "PKYStepper.h"
#import "BTRSizeHandler.h"
#import <Social/Social.h>
#import "PinterestSDK.h"
#import "BTRZoomImageViewController.h"
#import "UIImageView+AFNetworkingFadeIn.h"
#import "BTRSettingManager.h"
#import "BTRLoginViewController.h"

#define SIZE_NOT_SELECTED_STRING @"-1"
#define SOCIAL_MEDIA_INIT_STRING @"Check out this great sale from Beyond the Rack!"

typedef enum operation {
    addToBag = 1,
    gotoBag = 2
}operation;

@interface BTRProductDetailEmbededVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL selectedAddWithOutSize;
    UIView * view1;
    UIView * view2;
    UITableView * detailTV;
    BTRProductDetailCellDetail * detailCell;
    BTRProductDetailImageCell * imageCell;
    BTRProductDetailNameCell * nameCell;
    BTRProductShareCell * shareCell;
    UIView * descriptionView;
    UICollectionView *_collectionView;
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
    if (self.variant == nil)
        self.variant = SIZE_NOT_SELECTED_STRING;
    if (!_rowsArray) {
        _rowsArray = [[NSMutableArray alloc]initWithObjects:@"imageCell",@"nameCell",@"detailCell",@"shareCell", nil];
    }
    _selectedSizeIndex = -1;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.headerView setBackgroundColor:[BTRViewUtility BTRBlack]];
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
    [view2 addSubview:detailTV];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    view1.hidden = YES;
    view2.hidden = YES;
    detailTV.hidden = YES;
    [BTRLoader showLoaderInView:self.view];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.02 animations:^{
        [_collectionView performBatchUpdates:nil completion:nil];
    }];
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.01];
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    self.bagButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[sharedShoppingBag bagCount]];
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

- (void)fillWithItem:(Item*)item {
    [self extractAttributesFromAttributesDictionary:_getAttribDic];
    [self updateViewWithDeatiledItem:item];
}

#pragma UpdateView Size and View

- (void)updateViewWithDeatiledItem:(Item *)productItem {
    self.productImageCount = [[productItem imageCount] integerValue];
    if (productItem) {
        [self setProductSku:[productItem sku]];
        [nameCell.brandLabel setText:[productItem brand]];
        [nameCell.shortDescriptionLabel setText:[productItem shortItemDescription]];
        [nameCell.salePriceLabel setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
        [nameCell.crossedOffPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
        
        if ([productItem.allReserved boolValue] || self.disableAddToCart) {
            self.addTobagButton.enabled = NO;
            self.addTobagButton.backgroundColor = [UIColor grayColor];
        }
        
        descriptionView = [[UIView alloc]init];
        descriptionView = [self getDescriptionViewForView:descriptionView withDescriptionString:[productItem longItemDescription]];
        descriptionView = [self getAttribueViewForView:descriptionView];
        descriptionView = [self getNoteView:descriptionView withNote:[productItem generalNote] withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] andColor:[UIColor blackColor]];
        descriptionView = [self getNoteView:descriptionView withNote:[productItem specialNote] withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] andColor:[UIColor redColor]];
        descriptionView = [self getNoteView:descriptionView withNote:@"Applicable sales tax will be added." withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] andColor:[UIColor blackColor]];
        descriptionView = [self getNoteView:descriptionView withNote:[productItem shipTime] withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] andColor:[UIColor blackColor]];
        [detailCell.detailView addSubview:descriptionView];
        
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
        
        BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:_getVariantInventoryDic
                                                                            toSizesArray:[self sizesArray]
                                                                        toSizeCodesArray:[self sizeCodesArray]
                                                                     toSizeQuantityArray:[self sizeQuantityArray]];
        [self updateSizeSelectionViewforSizeMode:sizeMode];
    } else {
        [nameCell.brandLabel setText:@""];
        [nameCell.shortDescriptionLabel setText:@""];
        [nameCell.salePriceLabel setText:@""];
        [nameCell.crossedOffPriceLabel setText:@""];
    }
    [detailTV reloadData];
    [_collectionView reloadData];
    
}

- (void)updateSizeSelectionViewforSizeMode:(BTRSizeMode)sizeMode {
    if (sizeMode == BTRSizeModeSingleSizeShow || sizeMode == BTRSizeModeSingleSizeNoShow) {
        [nameCell.selectSizeLabel setAttributedText:[BTRViewUtility crossedOffStringfromString:@"Select Size :"]];
        [nameCell.selectSizeLabel setAlpha:0.4];
        [nameCell.selectSizeButton setEnabled:false];
        [nameCell.sizeLabel setText:@"One Size"];
        [nameCell.sizeLabel setTextColor:[UIColor blackColor]];
        [nameCell.dropdownLabelIcon setHidden:YES];
        [nameCell.sizeChartView setHidden:YES];
        self.variant = @"Z";
    } else
        [nameCell.sizeChartView setHidden:NO];
}

#pragma mark - Construct Description Views
- (UIView *)getDescriptionViewForView:(UIView *)descriptionView1 withDescriptionString:(NSString *)longDescriptionString {
    customHeight = 0;
    
    NSString *descriptionString = longDescriptionString;
    NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
    
    if ([descriptionString length] == 0 || [descriptionString isEqual:[NSNull null]]) {
        descriptionString = @"no descriptions available for this item.";
    }
    [descriptionArray addObjectsFromArray:[descriptionString componentsSeparatedByString:@"|"]];
//    [descriptionArray removeLastObject];
    for (int i = 0; i < [descriptionArray count]; i++) {
        
        NSString *labelText = [NSString stringWithFormat:@" - %@.", [descriptionArray objectAtIndex:i]];
        UIFont *descriptionFont =  [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        int labelHeight = [labelText heightForWidth:self.view.frame.size.width - 40 usingFont:descriptionFont];
        CGRect labelFrame = CGRectMake(0, customHeight, self.view.frame.size.width - 40 , labelHeight);
        
        customHeight = customHeight + (labelHeight + 5);
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [myLabel setFont:descriptionFont];
        [myLabel setText:labelText];
        [myLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [myLabel sizeToFit];
        [myLabel setTextAlignment:NSTextAlignmentLeft];
        [descriptionView1 addSubview:myLabel];
    }
    
    customHeight = customHeight + 15;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, customHeight, self.view.frame.size.width, 0.5)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [descriptionView1 addSubview:lineView];
    customHeight += 15;
    
    return descriptionView1;
}

- (UIView *)getAttribueViewForView:(UIView *)attributeView {
    
    UILabel *additinalInformation = [[UILabel alloc] initWithFrame:CGRectMake(-8, customHeight, self.view.frame.size.width, 10)];
    [additinalInformation setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [additinalInformation setText:@"Additional Information : "];
    [additinalInformation setNumberOfLines:0];
    [additinalInformation sizeToFit];
    [additinalInformation setTextAlignment:NSTextAlignmentLeft];
    [attributeView addSubview:additinalInformation];
    customHeight +=30;
    
    for (int i = 0; i < [self.attributeKeys count]; i++) {
        
        NSString *attributeText = [NSString stringWithFormat:@"    %@ : %@", [self.attributeKeys objectAtIndex:i], [self.attributeValues objectAtIndex:i]];
        UIFont *attributeFont =  [UIFont fontWithName:@"HelveticaNeue" size:12];
        
        int attributeHeight = [attributeText heightForWidth:self.view.frame.size.width - 40 usingFont:attributeFont];
        CGRect attributeFrame = CGRectMake(0, customHeight, self.view.frame.size.width - 40, attributeHeight);
        
        customHeight = customHeight + (attributeHeight + 5);
        
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:attributeFrame];
        [attributeLabel setFont:attributeFont];
        [attributeLabel setText:attributeText];
        [attributeLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [attributeLabel sizeToFit];
        [attributeLabel setTextAlignment:NSTextAlignmentLeft];
        [attributeView addSubview:attributeLabel];
    }
    
    customHeight += 10;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, customHeight, self.view.frame.size.width, 0.5)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [attributeView addSubview:lineView];
    customHeight += 10;
    
    return attributeView;
}

- (UIView *)getNoteView:(UIView *)noteView withNote:(NSString *)note withFont:(UIFont *)font andColor:(UIColor *)color {
    if ([note length] > 2) {
        customHeight += 8;
        
        NSString *noteLabelText = note;
        int generalNoteLabelHeight = [noteLabelText heightForWidth:self.view.frame.size.width - 40  usingFont:font];
        CGRect specialNoteFrame = CGRectMake(0, customHeight, self.view.frame.size.width - 40 , generalNoteLabelHeight);
        
        customHeight = customHeight + generalNoteLabelHeight + 10;
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:specialNoteFrame];
        [noteLabel setFont:font];
        [noteLabel setTextColor:color];
        [noteLabel setText:noteLabelText];
        [noteLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [noteLabel sizeToFit];
        [noteLabel setTextAlignment:NSTextAlignmentLeft];
        [noteView addSubview:noteLabel];
    }
    
    self.descriptionCellHeight = customHeight + 80;
    return noteView;
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
        imageCell = (BTRProductDetailImageCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (imageCell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductDetailImageCell" owner:self options:nil];
            imageCell = [nib objectAtIndex:0];
            imageCell.contentView.backgroundColor = [UIColor grayColor];
            if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                CGFloat viewWidth = self.view.frame.size.width;
                CGFloat collectHeight;
                if ([BTRViewUtility isIPAD]) {
                    collectHeight = 400;
                } else {
                    if (self.view.frame.size.height < 500) {
                        collectHeight = 200;
                    } else {
                        collectHeight = 312;
                    }
                }
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
                [detailCell.detailView addSubview:descriptionView];
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
            [shareCell.pinitAction addTarget:self action:@selector(shareOnPinterestTapped:) forControlEvents:UIControlEventTouchUpInside];
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
    switch (indexPath.row) {
        case 0:
            if ([BTRViewUtility isIPAD]) {
                if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                    imageCell.contentView.hidden = NO;
                    return 400;
                } else {
                    imageCell.contentView.hidden = YES;
                    return 0;
                }
            }else
                if (self.view.frame.size.height < 500) {
                    return 200;
                }else
                    return 312;
            break;
        case 1:
            return 260;
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


#pragma mark - Navigation

- (IBAction)backButtonTapped:(UIButton *)sender {
    if ([[self getOriginalVCString] isEqualToString:SEARCH_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToSearchScene" sender:self];
    
    if ([[self getOriginalVCString] isEqualToString:EVENT_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToShowcase" sender:self];
}

- (IBAction)bagButtonTapped:(UIButton *)sender {
    if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
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
    [self cartIncrementServerCallWithSuccess:^(NSString *successString) {
        if ([successString isEqualToString:@"TRUE"]) {
            UIStoryboard *storyboard = self.storyboard;
            BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)cartIncrementServerCallWithSuccess:(void (^)(id  responseObject)) success
                                   failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforSetBag]];
    [BTRConnectionHelper postDataToURL:url withParameters:[self itemParameters] setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSDictionary *actionResponse = [[[response valueForKey:@"response"]valueForKey:@"key1"]valueForKey:@"response"];
        if (![[actionResponse valueForKey:@"success"]boolValue]) {
            if ([actionResponse valueForKey:@"error_message"]) {
                [[[UIAlertView alloc]initWithTitle:@"Error" message:[actionResponse valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
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
    NSString* url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforItemWithProductSku:productSku]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        Item *productItem = [Item itemWithAppServerInfo:response withEventId:[self getEventID]];
        success(productItem);
    } faild:^(NSError *error) {
        failure(error);
    }];
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
        
        
        CGFloat collectHeight;
        if ([BTRViewUtility isIPAD]) {
            collectHeight = 400;
        } else {
            if (self.view.frame.size.height < 500) {
                collectHeight = 200;
            } else {
                collectHeight = 312;
            }
        }
        
        //When ever we change the Orientation we remove and readd the CollectionView
        NSArray *viewsToRemove = [imageCell.contentView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [imageCell.contentView addSubview:[self collectionView:CGRectMake(0, 0, viewWidth, collectHeight)]];
        
    } else {
        // Landscape frames
        if ([BTRViewUtility isIPAD]) {
            view1.hidden = NO;
            CGFloat viewWidth = screenBounds.size.width;
            CGFloat viewHeight = screenBounds.size.height;
            [view1 setFrame:CGRectMake(0, 75, viewWidth / 2, viewHeight - 145)];
            [view2 setFrame:CGRectMake(viewWidth/2, 75, viewWidth / 2, viewHeight - 145)];
            [detailTV setFrame:CGRectMake(0, 0, viewWidth / 2, viewHeight - 145)];
            [self collectionView:CGRectMake(0, 0, viewWidth / 2, viewHeight - 145)];
            
            //When ever we change the Orientation we remove and readd the CollectionView
            NSArray *viewsToRemove = [view1 subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
            [view1 addSubview:[self collectionView:CGRectMake(0, 0, viewWidth / 2, viewHeight - 145)]];
        }
    }
}

-(void)selectSizeChartAction {
    BTRSizeChartViewController* sizechart = [[BTRSizeChartViewController alloc]initWithNibName:@"BTRSizeChartViewController" bundle:nil];
    [sizechart setCategory:apparel];
    [self presentViewController:sizechart animated:YES completion:nil];
}

-(void)selectSizeButtonAction {
    UIStoryboard *storyboard = self.storyboard;
    BTRSelectSizeVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"SelectSizeVCIdentifier"];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.sizesArray = [self sizesArray];
    vc.sizeQuantityArray = [self sizeQuantityArray];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - BTRSelectSizeVC Delegate
- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    self.selectedSizeIndex = selectedIndex;
    nameCell.sizeLabel.text = [[self sizesArray] objectAtIndex:selectedIndex];
    self.variant = [[self sizesArray] objectAtIndex:selectedIndex];
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
    [cell.productImage setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]
                                                                   withCount:1+indexPath.row
                                                                     andSize:@"large"] placeholderImage:[UIImage imageNamed:@"placeHolderImage"] fadeInWithDuration:0.5];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if ([BTRViewUtility isIPAD]) {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            return CGSizeMake(screenBounds.size.width / 2 - 40,screenBounds.size.height - 165);
        } else
            return CGSizeMake(280 , 390);
    } else {
        return CGSizeMake((collectionView.bounds.size.width * 2) / 3, collectionView.bounds.size.height);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BTRZoomImageViewController *zoomVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZoomImageVC"];
    zoomVC.productSkuString = [self productSku];
    if ([self productImageCount] == 0)
        zoomVC.zoomImageCount = 1;
    else
        zoomVC.zoomImageCount = [self productImageCount];
    zoomVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:zoomVC animated:YES completion:nil];
}

-(UICollectionView *)collectionView:(CGRect)frame {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
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
    NSDictionary *updateParam = (@{@"key1" : params});
    return updateParam;
}

- (void)showLogin {
    BTRLoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRLoginViewController"];
    [self presentViewController:login animated:YES completion:nil];
}

- (void)userDidLogin:(NSNotification *) notification {
    if (self.lastOperation == addToBag)
        [self addToBag];
    if  (self.lastOperation == gotoBag)
        [self bagButtonTapped:nil];
    self.lastOperation = 0;
}

@end
