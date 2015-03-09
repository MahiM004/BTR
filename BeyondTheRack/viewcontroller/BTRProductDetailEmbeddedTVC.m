//
//  BTRProductDetailEmbededTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-05.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailEmbeddedTVC.h"
#import "BTRItemFetcher.h"
#import "NSString+HeightCalc.h"


@interface BTRProductDetailEmbeddedTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *tempProductImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *crossedOffPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *longDescriptionView;


@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@property (nonatomic) int descriptionCellHeight;


@end

@implementation BTRProductDetailEmbeddedTVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self updateViewWithItem:[self productItem]];
    
    [self setupDocument];

    if ([[self productItem] sku] && [[[self productItem] sku] isEqual:[NSNull null]])
        [self fetchItemIntoDocument:[self beyondTheRackDocument] forProductSku:[[self productItem] sku]
                            success:^(Item *responseObject) {
                                
                                [self updateViewWithItem:responseObject];
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
    
    
}


#pragma mark - Update Detail View



- (void)updateViewWithItem:(Item *)productItem {
    
    
    if (productItem)
    {
        [self.tempProductImageView setImageWithURL:[BTRItemFetcher URLforItemImageForSku:[productItem sku] ] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];
        
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
    descriptionView = [self getDescriptionViewForView:descriptionView withDescriptionString:[productItem longItemDescription]];
    
    [self.longDescriptionView addSubview:descriptionView];
}



- (UIView *)getDescriptionViewForView:(UIView *)descriptionView withDescriptionString:(NSString *)longDescriptionString {
  
    
    int customHeight = 80;
    int xPos = 0;
    
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

        CGRect labelFrame = CGRectMake(0, xPos, self.longDescriptionView.bounds.size.width, labelHeight);

        xPos += (labelHeight + 5);
        customHeight = customHeight + labelHeight + 10;

        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [myLabel setFont:descriptionFont];
        [myLabel setText:labelText];
        [myLabel setNumberOfLines:0];      // Tell the label to use an unlimited number of lines
        [myLabel sizeToFit];
        [myLabel setTextAlignment:NSTextAlignmentLeft];
        
        [descriptionView addSubview:myLabel];
    }
    
    [descriptionView sizeToFit];
    self.descriptionCellHeight = customHeight;
    
    return descriptionView;
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



/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCellIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




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
         
         Item *productItem = [Item itemWithAppServerInfo:entitiesPropertyList inManagedObjectContext:document.managedObjectContext];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        
         success(productItem);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
