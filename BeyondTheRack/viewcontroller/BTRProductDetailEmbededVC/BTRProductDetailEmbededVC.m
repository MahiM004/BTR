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
#import "BTRProductShareCell.h"
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

#define SIZE_NOT_SELECTED_STRING @"-1"
#define SOCIAL_MEDIA_INIT_STRING @"Check out this great sale from Beyond the Rack!"

@interface BTRProductDetailEmbededVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView * view1;
    UIView * view2;
    UITableView * detailTV;
    BTRProductDetailCellDetail * detailCell;
    BTRProductDetailImageCell * imageCell;
    BTRProductDetailNameCell * nameCell;
    BTRProductShareCell * shareCell;
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
    if (!_rowsArray) {
        _rowsArray = [[NSMutableArray alloc]initWithObjects:@"imageCell",@"nameCell",@"detailCell",@"shareCell", nil];
    }
    _selectedSizeIndex = -1;
    [self.view setBackgroundColor:[BTRViewUtility BTRBlack]];
    [self.headerView setBackgroundColor:[BTRViewUtility BTRBlack]];
    if ([[[self getItem] brand] length] > 1)
        [self.eventTitleLabel setText:[[self getItem] brand]];
    else
        [self.eventTitleLabel setText:@"Product Detail"];
    
    [BTRLoader showLoaderInView:self.view];
    [self fetchItemforProductSku:[[self getItem] sku]
                         success:^(Item *responseObject) {
                             [self fillWithItem:responseObject];
                             [BTRLoader hideLoaderFromView:self.view];
                         }
                         failure:^(NSError *error) {
                         }];

    
    
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
    
    if (self.disableAddToCart) {
        self.addTobagButton.enabled = NO;
        self.addToBagView.backgroundColor = [UIColor grayColor];
    }
    [PDKClient configureSharedInstanceWithAppId:@"1445223"];
}
-(void)fillWithItem:(Item*)item {
     [self extractAttributesFromAttributesDictionary:_getAttribDic];
    [self updateViewWithDeatiledItem:_getItem];
}
- (void)updateViewWithDeatiledItem:(Item *)productItem {
    self.productImageCount = [[productItem imageCount] integerValue];
    if (productItem) {
         [self setProductSku:[productItem sku]];
        [nameCell.brandLabel setText:[productItem brand]];
        [nameCell.shortDescriptionLabel setText:[productItem shortItemDescription]];
        [nameCell.salePriceLabel setText:[BTRViewUtility priceStringfromNumber:[productItem salePrice]]];
        [nameCell.crossedOffPriceLabel setAttributedText:[BTRViewUtility crossedOffPricefromNumber:[productItem retailPrice]]];
        
        
        UIView * descriptionView = [[UIView alloc]init];
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
//            [selfPointer quantityChangedWithValue:stepper.countLabel.text];
        };
        
        [self.stepper setup];
        [nameCell.stepperView addSubview:self.stepper];
        
        BTRSizeMode sizeMode = [BTRSizeHandler extractSizesfromVarianInventoryDictionary:_getVariantInventoryDic
                                                                            toSizesArray:[self sizesArray]
                                                                        toSizeCodesArray:[self sizeCodesArray]
                                                                     toSizeQuantityArray:[self sizeQuantityArray]];
        [self updateSizeSelectionViewforSizeMode:sizeMode];
        [self quantityChangedWithValue:@"1"];
        
    } else {
        [nameCell.brandLabel setText:@""];
        [nameCell.shortDescriptionLabel setText:@""];
        [nameCell.salePriceLabel setText:@""];
        [nameCell.crossedOffPriceLabel setText:@""];
    }
    [detailTV reloadData];

}
- (void)updateSizeSelectionViewforSizeMode:(BTRSizeMode)sizeMode {
    if (sizeMode == BTRSizeModeSingleSizeShow || sizeMode == BTRSizeModeSingleSizeNoShow) {
        [nameCell.selectSizeLabel setAttributedText:[BTRViewUtility crossedOffStringfromString:@"Select Size :"]];
        [nameCell.selectSizeLabel setAlpha:0.4];
        [nameCell.selectSizeButton setEnabled:false];
        [nameCell.sizeLabel setText:@"One Size"];
        [nameCell.sizeLabel setTextColor:[UIColor blackColor]];
        [nameCell.dropdownLabelIcon setHidden:YES];
//        if ([self.delegate respondsToSelector:@selector(variantCodeforAddtoBag:)]) {
//            [self.delegate variantCodeforAddtoBag:@"Z"];
//        }
    }
}
#pragma mark - Quantity Delegate

- (void)quantityChangedWithValue:(NSString *)value {
//    if ([self.delegate respondsToSelector:@selector(quantityForAddToBag:)]) {
//        [self.delegate quantityForAddToBag:self.stepper.countLabel.text];
//    }
    NSLog(@"%@",value);
}
#pragma mark - Construct Description Views

- (UIView *)getDescriptionViewForView:(UIView *)descriptionView withDescriptionString:(NSString *)longDescriptionString {
    customHeight = 0;
    
    NSString *descriptionString = longDescriptionString;
    NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
    
    if ([descriptionString length] == 0 || [descriptionString isEqual:[NSNull null]]) {
        descriptionString = @"no descriptions available for this item.";
    }
    [descriptionArray addObjectsFromArray:[descriptionString componentsSeparatedByString:@"|"]];
    [descriptionArray removeLastObject];
    for (int i = 0; i < [descriptionArray count]; i++) {
        
        NSString *labelText = [NSString stringWithFormat:@" - %@.", [descriptionArray objectAtIndex:i]];
        UIFont *descriptionFont =  [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        int labelHeight = [labelText heightForWidth:detailCell.detailView.bounds.size.width usingFont:descriptionFont];
        CGRect labelFrame = CGRectMake(0, customHeight, detailCell.detailView.bounds.size.width , labelHeight);
        
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
        
        int attributeHeight = [attributeText heightForWidth:detailCell.detailView.bounds.size.width usingFont:attributeFont];
        CGRect attributeFrame = CGRectMake(0, customHeight, detailCell.detailView.bounds.size.width, attributeHeight);
        
        customHeight = customHeight + (attributeHeight + 5);
        
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:attributeFrame];
        [attributeLabel setFont:attributeFont];
        [attributeLabel setText:attributeText];
        [attributeLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [attributeLabel sizeToFit];
        [attributeLabel setTextAlignment:NSTextAlignmentLeft];
        [attributeView addSubview:attributeLabel];
        NSLog(@"%@",attributeLabel.text);
    }
    return attributeView;
}
- (UIView *)getNoteView:(UIView *)noteView withNote:(NSString *)note withFont:(UIFont *)font andColor:(UIColor *)color {
    if ([note length] > 2) {
        customHeight += 8;
        
        NSString *noteLabelText = note;
        int generalNoteLabelHeight = [noteLabelText heightForWidth:detailCell.detailView.bounds.size.width  usingFont:font];
        CGRect specialNoteFrame = CGRectMake(0, customHeight, detailCell.detailView.bounds.size.width , generalNoteLabelHeight);
        
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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.01];
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    self.bagButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[sharedShoppingBag bagCount]];
}



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
        }
        return imageCell;
    } else if ([cellIdenti isEqual:@"nameCell"]) {
        nameCell = (BTRProductDetailNameCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (!nameCell) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductDetailNameCell" owner:self options:nil];
            nameCell = [nib objectAtIndex:0];
            [nameCell.selectChart addTarget:self action:@selector(selectSizeChartAction) forControlEvents:UIControlEventTouchUpInside];
            [nameCell.selectSizeButton addTarget:self action:@selector(selectSizeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        }
        return nameCell;
    } else if ([cellIdenti isEqual:@"detailCell"]) {
        detailCell = (BTRProductDetailCellDetail*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (detailCell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductDetailCellDetail" owner:self options:nil];
            detailCell = [nib objectAtIndex:0];
        }
        return detailCell;
    } else if ([cellIdenti isEqual:@"shareCell"]) {
        shareCell = (BTRProductShareCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (shareCell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"BTRProductShareCell" owner:self options:nil];
            shareCell = [nib objectAtIndex:0];
            [shareCell.twitterAction addTarget:self action:@selector(twitter:) forControlEvents:UIControlEventTouchUpInside];
            [shareCell.facebookAction addTarget:self action:@selector(shareOnFacebookTapped:) forControlEvents:UIControlEventTouchUpInside];
            [shareCell.pinitAction addTarget:self action:@selector(shareOnPinterestTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        return shareCell;
    } else {
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
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)addToBagTapped:(UIButton *)sender {
    
    if ([[self variant] isEqualToString:SIZE_NOT_SELECTED_STRING]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Size"
                                                        message:@"Please select a size!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        [self cartIncrementServerCallWithSuccess:^(NSString *successString) {
            if ([successString isEqualToString:@"TRUE"]) {
                UIStoryboard *storyboard = self.storyboard;
                BTRShoppingBagViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark - RESTful Calls

- (void)cartIncrementServerCallWithSuccess:(void (^)(id  responseObject)) success
                                   failure:(void (^)(NSError *error)) failure {
    [[self bagItemsArray] removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforAddtoBag]];
    NSDictionary *params = (@{
                              @"event_id": [[self getItem] eventId],
                              @"sku": [[self getItem] sku],
                              @"variant":[self variant],
                              });
    NSLog(@"%@",params);
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (![[response valueForKey:@"success"]boolValue]) {
            if ([response valueForKey:@"error_message"]) {
                [[[UIAlertView alloc]initWithTitle:@"Error" message:[response valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            }
            return;
        }
        if (self.quantity.intValue > 1) {
            NSDictionary *itemInfo = (@{@"event_id": [[self getItem] eventId],
                                        @"sku": [[self getItem] sku],
                                        @"variant":[self variant],
                                        @"quantity":[self quantity]
                                        });
            NSDictionary *updateParam = (@{@"key1" : itemInfo});
            NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforSetBag]];
            [BTRConnectionHelper postDataToURL:url withParameters:updateParam setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
                [self updateBagWithDictionary:response];
                success(@"TRUE");
            } faild:^(NSError *error) {
                failure(error);
            }];
            
        } else {
            
            [self updateBagWithDictionary:response];
            success(@"TRUE");
        }
        
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
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        // Portrait frames
        CGFloat viewWidth = screenBounds.size.width;
        CGFloat viewHeight = screenBounds.size.height;
        [view1 setFrame:CGRectMake(0, 0, 0, 0)];
        [view2 setFrame:CGRectMake(10, 75, viewWidth - 20, viewHeight - 150)];
        [detailTV setFrame:CGRectMake(0, 0, viewWidth - 20, viewHeight - 150)];
    } else {
        // Landscape frames
        CGFloat viewWidth = screenBounds.size.width;
        CGFloat viewHeight = screenBounds.size.height;
        [view1 setFrame:CGRectMake(10, 75, viewWidth / 2 - 20, viewHeight - 150)];
        [view2 setFrame:CGRectMake(viewWidth/2 + 10, 75, viewWidth / 2 - 20, viewHeight - 150)];
        [detailTV setFrame:CGRectMake(0, 0, viewWidth / 2 - 20, viewHeight - 150)];
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
    vc.sizesArray = [self sizesArray];
    vc.sizeQuantityArray = [self sizeQuantityArray];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - BTRSelectSizeVC Delegate

- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
    self.selectedSizeIndex = selectedIndex;
    nameCell.sizeLabel.text = [[self sizesArray] objectAtIndex:selectedIndex];
//    if ([self.delegate respondsToSelector:@selector(variantCodeforAddtoBag:)])
//        [self.delegate variantCodeforAddtoBag:[[self sizeCodesArray] objectAtIndex:[self selectedSizeIndex]]];
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

@end
