//
//  BTRRefineResultsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRRefineResultsViewController.h"
#import "BTRSearchFilterTVC.h"
#import "BTRItemFetcher.h"

#import "BTRFacetsHandler.h"

@interface BTRRefineResultsViewController () <BTRSearchFilterTableDelegate>


@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) int *sortOptions;
@property (strong, nonatomic) NSMutableArray *chosenFacetsArray;


@end

@implementation BTRRefineResultsViewController

@synthesize backgroundImage;


- (NSMutableArray *)chosenFacetsArray {
    
    if (!_chosenFacetsArray) _chosenFacetsArray = [[NSMutableArray alloc] init];
    return _chosenFacetsArray;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupDocument];
        
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.headerView.opaque = NO;
    
    self.headerView.backgroundColor = [UIColor clearColor];
    UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:self.headerView.frame];
    bgToolbar.barStyle = UIBarStyleDefault;
    [self.headerView.superview insertSubview:bgToolbar belowSubview:self.headerView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    backgroundImageView.image = [self.backgroundImage applyDarkEffect];
    [self.view insertSubview:backgroundImageView belowSubview:[self headerView]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Load Results RESTful


- (void)setupDocument {
    
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}

- (void)fetchItemsIntoDocument:(UIManagedDocument *)document forSearchQuery:(NSString *)searchQuery
              withFacetsString:(NSString *)facetsString
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:[BTRItemFetcher contentTypeForSearchQuery]];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withFacetString:facetsString andPageNumber:0]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                            options:0
                                                                              error:NULL];
         success(responseDictionary);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}


#pragma mark - Navigation


- (IBAction)clearTapped:(UIButton *)sender {
    
    [self.chosenFacetsArray removeAllObjects];

    if ([self.delegate respondsToSelector:@selector(refineSceneWillDisappearWithResponseDictionary:andChosenFacets:)]) {
        [self.delegate refineSceneWillDisappearWithResponseDictionary:[self responseDictionaryFromFacets] andChosenFacets:[self chosenFacetsArray]];
    }    
    
    [self performSegueWithIdentifier:@"unwindFromRefineResultsCleared" sender:self];
}

- (IBAction)applyButtonTapped:(UIButton *)sender {

    /*
     
     handle the sort and pass back the query result
    
     */
    
    NSString *facetString = [self getFacetQueryString];
    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument]
                  forSearchQuery:[self searchString]
                withFacetsString:facetString
                         success:^(NSDictionary *responseDictionary) {
                             
                             self.responseDictionaryFromFacets = responseDictionary;
                             if ([self.delegate respondsToSelector:@selector(refineSceneWillDisappearWithResponseDictionary:andChosenFacets:)]) {
                                 [self.delegate refineSceneWillDisappearWithResponseDictionary:[self responseDictionaryFromFacets] andChosenFacets:[self chosenFacetsArray]];
                             }
                             
                             
                             [self performSegueWithIdentifier:@"unwindFromRefineResultsApplied" sender:self];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error: %@",error);
                         }];
    
}


- (NSString *)getFacetQueryString {
    
    
    NSMutableArray *facetOptionsArray = [[NSMutableArray alloc] init];
    
    facetOptionsArray = [BTRFacetsHandler getFacetOptionsFromDisplaySelectedPrices:[self.chosenFacetsArray objectAtIndex:0] fromSelectedCategories:[self.chosenFacetsArray objectAtIndex:1] fromSelectedBrand:[self.chosenFacetsArray objectAtIndex:2] fromSelectedColors:[self.chosenFacetsArray objectAtIndex:3] fromSelectedSizes:[self.chosenFacetsArray objectAtIndex:4]];
    
    return [BTRFacetsHandler getFacetStringForRESTWithChosenFacetsArray:facetOptionsArray withSortOption:0];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {


    if ([[segue identifier] isEqualToString:@"EmbededdFilterSegue"]) {
     
        BTRSearchFilterTVC *embedTVC = segue.destinationViewController;
     
        embedTVC.searchString = [self searchString];
        embedTVC.oldChosenFacets = [self oldChosenFacets];
        embedTVC.facetsDictionary = [self facetsDictionary];
        embedTVC.delegate = self;
    }
    
}


#pragma mark - BTRSearchFilterTableDelegate

- (void)searchFilterTableWillDisappearWithChosenFacetsArray:(NSMutableArray *)chosenFacetsArray {

    [self.chosenFacetsArray removeAllObjects];
    [self.chosenFacetsArray addObjectsFromArray:chosenFacetsArray];
}



@end



















