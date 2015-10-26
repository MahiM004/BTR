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
#import "BTRSizeChartViewController.h"
#import "NSString+HeightCalc.h"
#import <Social/Social.h>
#import "PinterestSDK.h"
#import "PKYStepper.h"
#import "UIImageView+AFNetworking.h"

#define SOCIAL_MEDIA_INIT_STRING @"Check out this great sale from Beyond the Rack!"
#define kMargin             20.0
#define kSampleImageWidth   320.0
#define kSampleImageHeight  200.0
#define kPinItButtonWidth   72.0
#define kPinItButtonHeight  32.0
#define kTextMargin 54

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
@property (weak, nonatomic) IBOutlet UILabel *qtyNum;
@property (weak, nonatomic) IBOutlet UIView *stepperView;

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
@property (nonatomic, strong) PKYStepper *stepper;

@property (strong, nonatomic) Item *productItem;
@property (strong, nonatomic) NSDictionary *variantInventoryDictionary;
@property (strong, nonatomic) NSDictionary *attributesDictionary;
@property (strong, nonatomic) NSString *eventId;

@end


@implementation BTRProductDetailEmbeddedTVC {
    PDKClient *_pinterest;
}

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dropdownLabelIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.dropdownLabelIcon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-caret-down"];
    self.selectedSizeIndex = -1;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
   [PDKClient configureSharedInstanceWithAppId:@"1445223"];
   // _pinterest = [[PDKClient alloc] initWithClientId:@"1445223" urlSchemeSuffix:@"prod"];
    // Initialize a Pinterest instance with our client_id
}

- (void)fillWithItem:(Item *)productItem {
    _productItem = productItem;
    _attributesDictionary = productItem.attributeDictionary;
    _variantInventoryDictionary = productItem.variantInventory;
    [self extractAttributesFromAttributesDictionary:[self attributesDictionary]];
    [self updateViewWithDeatiledItem:[self productItem]];
}

#pragma mark - Update Detail View

- (void)updateViewWithDeatiledItem:(Item *)productItem {
    self.productImageCount = [[productItem imageCount] integerValue];
    __block BTRProductDetailEmbeddedTVC* selfPointer = self;
    
    if (productItem) {
        [self setProductSku:[productItem sku]];
        [self.brandLabel setText:[productItem brand]];
        [self.shortDescriptionLabel setText:[productItem shortItemDescription]];
        [self.salePriceLabel setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
        [self.crossedOffPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
        UIView *descriptionView = [[UIView alloc] init];
        descriptionView = [self getDescriptionViewForView:descriptionView withDescriptionString:[productItem longItemDescription]];
        descriptionView = [self getAttribueViewForView:descriptionView];
        descriptionView = [self getNoteView:descriptionView withNote:[productItem generalNote] withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] andColor:[UIColor blackColor]];
        descriptionView = [self getNoteView:descriptionView withNote:[productItem specialNote] withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] andColor:[UIColor redColor]];
        descriptionView = [self getNoteView:descriptionView withNote:@"Applicable sales tax will be added." withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12] andColor:[UIColor blackColor]];
        descriptionView = [self getNoteView:descriptionView withNote:[productItem shipTime] withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] andColor:[UIColor blackColor]];
        [self.longDescriptionView addSubview:descriptionView];
        
        self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
        self.stepper.value = 1;
        self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
            if (stepper.value < 1)
                return;
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
            [selfPointer quantityChangedWithValue:stepper.countLabel.text];
        };
        
        [self.stepper setup];
        [self.stepperView addSubview:self.stepper];

        BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:[self variantInventoryDictionary]
                                                                                 toSizesArray:[self sizesArray]
                                                                             toSizeCodesArray:[self sizeCodesArray]
                                                                          toSizeQuantityArray:[self sizeQuantityArray]];
        [self updateSizeSelectionViewforSizeMode:sizeMode];
        [self quantityChangedWithValue:@"1"];
    } else {
        [self.brandLabel setText:@""];
        [self.shortDescriptionLabel setText:@""];
        [self.salePriceLabel setText:@""];
        [self.crossedOffPriceLabel setText:@""];
    }
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

- (void)updateSizeSelectionViewforSizeMode:(BTRSizeMode)sizeMode {
    if (sizeMode == BTRSizeModeSingleSizeShow || sizeMode == BTRSizeModeSingleSizeNoShow) {
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
        int labelHeight = [labelText heightForWidth:(self.tableView.frame.size.width - kTextMargin-_rightMargin) usingFont:descriptionFont];
        CGRect labelFrame = CGRectMake(0, customHeight, self.tableView.frame.size.width - kTextMargin - _rightMargin , labelHeight);

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

- (UIView *)getNoteView:(UIView *)noteView withNote:(NSString *)note withFont:(UIFont *)font andColor:(UIColor *)color {
    if ([note length] > 2) {
        customHeight += 8;
        
        NSString *noteLabelText = note;
        int generalNoteLabelHeight = [noteLabelText heightForWidth:self.tableView.frame.size.width - kTextMargin  usingFont:font];
        CGRect specialNoteFrame = CGRectMake(0, customHeight, self.tableView.frame.size.width - kTextMargin , generalNoteLabelHeight);
        
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

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if ([self productImageCount] == 0)
        return 1;
    return [self productImageCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTRProductImageCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductImageCollectionCellIdentifier" forIndexPath:indexPath];
    [cell.productImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]
                                                                       withCount:1+indexPath.row
                                                                         andSize:@"large"]
                          placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    return cell;
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            if ([BTRViewUtility isIPAD] == YES && _rightMargin == 250) {
                return 0;
            }else
                return 312;
            break;
        case 1:
            return 240;
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

#pragma mark - Social Media Sharing

- (IBAction)shareOnFacebookTapped:(UIButton *)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]]]];
        [controller setInitialText:SOCIAL_MEDIA_INIT_STRING];
        [controller addImage:image];
        [controller addURL:[BTRItemFetcher URLtoShareforEventId:[self eventId] withProductSku:[self productSku]]];
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

- (IBAction)twitter:(UIButton *)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]]]];
        [tweetSheet setInitialText:SOCIAL_MEDIA_INIT_STRING];
        [tweetSheet addImage:image];
        [tweetSheet addURL:[BTRItemFetcher URLtoShareforEventId:[self eventId] withProductSku:[self productSku]]];
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

- (IBAction)shareOnPinterestTapped:(UIButton *)sender {
    NSSet *fields = [NSSet setWithArray:@[@"id",
                                          @"username",
                                          @"first_name",
                                          @"last_name",
                                          @"bio",
                                          @"created_at",
                                          @"counts",
                                          @"image"]];
    [[PDKClient sharedInstance]getAuthenticatedUserBoardsWithFields:fields success:^(PDKResponseObject *responseObject) {
        
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
//    [_pinterest createPinWithImageURL:[BTRItemFetcher URLforItemImageForSku:[self productSku]]
//                            sourceURL:[BTRItemFetcher URLtoShareforEventId:[self eventId] withProductSku:[self productSku]]
//                          description:SOCIAL_MEDIA_INIT_STRING];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ZoomOnProductImageSegueIdentifier"] || [[segue identifier] isEqualToString:@"ZoomOnProductImageiPadSegueIdentifier"]) {
        BTRZoomImageViewController *zoomVC = [segue destinationViewController];
        zoomVC.productSkuString = [self productSku];
        if ([self productImageCount] == 0)
            zoomVC.zoomImageCount = 1;
        else
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
#pragma mark - BTRSelectSizeVC Delegate

- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    self.selectedSizeIndex = selectedIndex;
    self.sizeLabel.text = [[self sizesArray] objectAtIndex:selectedIndex];
    if ([self.delegate respondsToSelector:@selector(variantCodeforAddtoBag:)])
        [self.delegate variantCodeforAddtoBag:[[self sizeCodesArray] objectAtIndex:[self selectedSizeIndex]]];
}

#pragma mark - Quantity Delegate

- (void)quantityChangedWithValue:(NSString *)value {
    if ([self.delegate respondsToSelector:@selector(quantityForAddToBag:)]) {
        [self.delegate quantityForAddToBag:self.stepper.countLabel.text];
    }
}

#pragma mark SizeChart

- (IBAction)showSizeChart:(id)sender {
    BTRSizeChartViewController* sizechart = [[BTRSizeChartViewController alloc]initWithNibName:@"BTRSizeChartViewController" bundle:nil];
    [sizechart setCategory:apparel];
    [self presentViewController:sizechart animated:YES completion:nil];
}

@end


























