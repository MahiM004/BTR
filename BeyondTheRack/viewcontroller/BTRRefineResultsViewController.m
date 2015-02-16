//
//  BTRRefineResultsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRRefineResultsViewController.h"
#import "BTRSearchFilterTVC.h"

#import "BTRFacetsHandler.h"

@interface BTRRefineResultsViewController () <BTRSearchFilterTableDelegate>


@property (strong, nonatomic) NSMutableArray *priceFilter;
@property (strong, nonatomic) NSMutableArray *sortOptions;
@property (strong, nonatomic) NSMutableArray *categoryFilter;
@property (strong, nonatomic) NSMutableArray *brandFilter;
@property (strong, nonatomic) NSMutableArray *colorFilter;
@property (strong, nonatomic) NSMutableArray *sizeFilter;


@end

@implementation BTRRefineResultsViewController

@synthesize backgroundImage;



- (NSMutableArray *)sortOptions{
    
    if (!_sortOptions) _sortOptions = [[NSMutableArray alloc] init];
    return _sortOptions;
}

- (NSMutableArray *)priceFilter {
    
    if (!_priceFilter) _priceFilter = [[NSMutableArray alloc] init];
    return _priceFilter;
}

- (NSMutableArray *)categoryFilter{
    
    if (!_categoryFilter) _categoryFilter = [[NSMutableArray alloc] init];
    return _categoryFilter;
}

- (NSMutableArray *)brandFilter{
    
    if (!_brandFilter) _brandFilter = [[NSMutableArray alloc] init];
    return _brandFilter;
}

- (NSMutableArray *)colorFilter{
    
    if (!_colorFilter) _colorFilter = [[NSMutableArray alloc] init];
    return _colorFilter;
}

- (NSMutableArray *)sizeFilter{
    
    if (!_sizeFilter) _sizeFilter = [[NSMutableArray alloc] init];
    return _sizeFilter;
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self extractFilterFacetsWithFacetQueries:[self facetsDictionary]];
    
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


- (void) extractFilterFacetsWithFacetQueries:(NSDictionary *)facetsDictionary {


    NSMutableArray *facetsArray = [BTRFacetsHandler extractFilterFacetsForDisplayFromResponse:facetsDictionary];
    
    [self.priceFilter setArray:[facetsArray objectAtIndex:0]];
    [self.categoryFilter setArray:[facetsArray objectAtIndex:1]];
    [self.brandFilter setArray:[facetsArray objectAtIndex:2]];
    [self.colorFilter setArray:[facetsArray objectAtIndex:3]];
    [self.sizeFilter setArray:[facetsArray objectAtIndex:4]];
    
}


#pragma mark - Navigation



- (IBAction)applyButtonTapped:(UIButton *)sender {

    /*
     
     handle the sort and pass back the query result
    
     */
    
    if ([self.delegate respondsToSelector:@selector(refineSceneWillDisappearWithResponseDictionary:)]) {
        [self.delegate refineSceneWillDisappearWithResponseDictionary:[self responseDictionaryFromFacets]];
    }

    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelTapped:(id)sender {
    
    /*
     
     clear selections and dismiss vc
    
     */
    
    [self dismissViewControllerAnimated:YES completion:nil];

}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {


    if ([[segue identifier] isEqualToString:@"EmbededdFilterSegue"]) {
     
        BTRSearchFilterTVC *embedTVC = segue.destinationViewController;
     
        embedTVC.pricesArray = self.priceFilter;
        embedTVC.brandsArray = self.brandFilter;
        embedTVC.colorsArray = self.colorFilter;
        embedTVC.categoriesArray = self.categoryFilter;
        embedTVC.sizesArray = self.sizeFilter;
        embedTVC.searchString = [self searchString];
        embedTVC.delegate = self;
    }
    
}


#pragma mark - BTRSearchFilterTableDelegate

- (void)searchFilterTableWillDisappearWithResponseDictionary:(NSDictionary *)responseDictionary {
    
    self.responseDictionaryFromFacets = responseDictionary;
}



@end



















