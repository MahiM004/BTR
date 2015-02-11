//
//  BTRRefineResultsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRRefineResultsViewController.h"
#import "BTRSearchFilterTVC.h"



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

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
    [self extractFilterFacetsWithFacetQueries:[self facetsDictionary]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) extractFilterFacetsWithFacetQueries:(NSDictionary *)facetsDictionary {

    
    [self.priceFilter removeAllObjects];
    [self.sortOptions removeAllObjects];
    [self.categoryFilter removeAllObjects];
    [self.brandFilter removeAllObjects];
    [self.colorFilter removeAllObjects];
    [self.sizeFilter removeAllObjects];

    
    NSDictionary *facetQueriesDictionary = facetsDictionary[@"facet_queries"];
    NSDictionary *facetFieldsDictionary =  facetsDictionary[@"facet_fields"];
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    
    NSString *tempString = [NSString stringWithFormat:@"$0 to $200: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[0 TO 200]"] ];
    [self.priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$200 to $400: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[200 TO 400]"] ];
    [self.priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$400 to $600: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[400 TO 600]"] ];
    [self.priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$600 to $800: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[600 TO 800]"] ];
    [self.priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$800 to $1000: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[800 TO 1000]"] ];
    [self.priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$1000 to *: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[1000 TO *]"] ];
    [self.priceFilter addObject:tempString];

    
    NSDictionary *brandDictionary = facetFieldsDictionary[@"brand"];
    for (NSString *item in brandDictionary)
        [self.brandFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)brandDictionary[item]] ];
    
    NSDictionary *categoryDictionary = facetFieldsDictionary[@"cat_1"];
    for (NSString *item in categoryDictionary)
        [self.categoryFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)categoryDictionary[item]] ];
    
    NSDictionary *colorDictionary = facetFieldsDictionary[@"att_color"];
    for (NSString *item in colorDictionary)
        [self.colorFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)colorDictionary[item]] ];
    
    NSDictionary *sizeDictionary = facetFieldsDictionary[@"variant"];
    for (NSString *item in sizeDictionary)
        [self.sizeFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)sizeDictionary[item]] ];
    
    
    [self.brandFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.categoryFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.colorFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.sizeFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];

}


#pragma mark - Navigation



- (IBAction)applyButtonTapped:(UIButton *)sender {

    /*
     
     handle the sort and pass back the query result
    
     */
    
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
        embedTVC.delegate = self;
    }
    
}


#pragma mark - BTRSearchFilterTableDelegate

- (void)searchRefineOptionChosen:(NSMutableArray *)searchRefineArray {
    
    for (NSMutableArray *someArray in searchRefineArray) {
        
        
        for (NSString *someString in someArray) {
            NSLog(@"%@",someString);
        }
    }
    
    // construct the query here!
    
}



@end



















