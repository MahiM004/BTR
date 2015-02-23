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

@interface BTRRefineResultsViewController () 

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;



@end

@implementation BTRRefineResultsViewController

@synthesize backgroundImage;




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
         NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                            options:0
                                                                              error:NULL];
         
         
         BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
         [sharedFacetsHandler updateFacetsFromResponseDictionary:entitiesPropertyList];

         success(entitiesPropertyList);         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
    
}


#pragma mark - Navigation


- (IBAction)clearTapped:(UIButton *)sender {

    
    [self performSegueWithIdentifier:@"unwindFromRefineResultsCleared" sender:self];
}

- (IBAction)applyButtonTapped:(UIButton *)sender {

    /*
     
     handle the sort and pass back the query result
    
     */
    
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    NSString *facetString = [sharedFacetHandler getFacetStringForRESTfulRequest];

    
    [self fetchItemsIntoDocument:[self beyondTheRackDocument]
                  forSearchQuery:[sharedFacetHandler searchString]
                withFacetsString:facetString
                         success:^(NSDictionary *responseDictionary) {
                            
                             if ([self.delegate respondsToSelector:@selector(refineSceneWillDisappearWithResponseDictionary:)]) {
                                 [self.delegate refineSceneWillDisappearWithResponseDictionary:responseDictionary];
                             }
                             
                             [self performSegueWithIdentifier:@"unwindFromRefineResultsApplied" sender:self];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error: %@",error);
                         }];
    
}



@end



















