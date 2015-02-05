//
//  BTRSearchFilterViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchFilterViewController.h"

@interface BTRSearchFilterViewController ()


@property (strong, nonatomic) NSMutableArray *priceFilterCounter;
@property (strong, nonatomic) NSMutableArray *sortOptions;
@property (strong, nonatomic) NSMutableArray *categoryFilter;
@property (strong, nonatomic) NSMutableArray *categoryFilterCounter;
@property (strong, nonatomic) NSMutableArray *brandFilter;
@property (strong, nonatomic) NSMutableArray *brandFilterCounter;
@property (strong, nonatomic) NSMutableArray *colorFilter;
@property (strong, nonatomic) NSMutableArray *colorFilterCounter;
@property (strong, nonatomic) NSMutableArray *sizeFilter;
@property (strong, nonatomic) NSMutableArray *sizeFilterCounter;


@end

@implementation BTRSearchFilterViewController

@synthesize backgroundImage;

- (NSMutableArray *)_priceFilterCounter{
    
    if (!_priceFilterCounter) _priceFilterCounter = [[NSMutableArray alloc] init];
    return _priceFilterCounter;
}

- (NSMutableArray *)sortOptions{
    
    if (!_sortOptions) _sortOptions = [[NSMutableArray alloc] init];
    return _sortOptions;
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


- (NSMutableArray *)categoryFilterCounter{
    
    if (!_categoryFilterCounter) _categoryFilterCounter = [[NSMutableArray alloc] init];
    return _categoryFilterCounter;
}

- (NSMutableArray *)brandFilterCounter{
    
    if (!_brandFilterCounter) _brandFilterCounter = [[NSMutableArray alloc] init];
    return _brandFilterCounter;
}

- (NSMutableArray *)colorFilterCounter{
    
    if (!_colorFilterCounter) _colorFilterCounter = [[NSMutableArray alloc] init];
    return _colorFilterCounter;
}

- (NSMutableArray *)sizeFilterCounter{
    
    if (!_sizeFilter) _sizeFilterCounter = [[NSMutableArray alloc] init];
    return _sizeFilterCounter;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self extractFilterFacetsWithFacetQueries:[self facetQueriesDictionary] andFacetFields:[self facetFieldsDictionary]];

    
    
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


- (BOOL) extractFilterFacetsWithFacetQueries:(NSDictionary *)facetQueriesDictionary andFacetFields:(NSDictionary *)facetFieldsDictionary {
    
    
    [self.priceFilterCounter removeAllObjects];
    [self.sortOptions removeAllObjects];
    [self.categoryFilter removeAllObjects];
    [self.categoryFilterCounter removeAllObjects];
    [self.brandFilter removeAllObjects];
    [self.brandFilterCounter removeAllObjects];
    [self.colorFilter removeAllObjects];
    [self.colorFilterCounter removeAllObjects];
    [self.sizeFilter removeAllObjects];
    [self.sizeFilterCounter removeAllObjects];
    
    NSNumber *tempNum = (NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[0 TO 200]"];
    [self.priceFilterCounter addObject:tempNum];
    tempNum = (NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[200 TO 400]"];
    [self.priceFilterCounter addObject:tempNum];
    tempNum = (NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[400 TO 600]"];
    [self.priceFilterCounter addObject:tempNum];
    tempNum = (NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[600 TO 800]"];
    [self.priceFilterCounter addObject:tempNum];
    tempNum = (NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[800 TO 1000]"];
    [self.priceFilterCounter addObject:tempNum];
    tempNum = (NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[1000 TO *]"];
    [self.priceFilterCounter addObject:tempNum];
    
    
    NSDictionary *brandDictionary = facetFieldsDictionary[@"brand"];
    for (NSString *item in brandDictionary) {
        
        [self.brandFilter addObject:item];
        [self.brandFilterCounter addObject:(NSNumber *)brandDictionary[item]];
    }
    
    NSDictionary *categoryDictionary = facetFieldsDictionary[@"cat_1"];
    for (NSString *item in categoryDictionary) {
        
        [self.categoryFilter addObject:item];
        [self.categoryFilterCounter addObject:(NSNumber *)categoryDictionary[item]];
    }
    
    NSDictionary *colorDictionary = facetFieldsDictionary[@"att_color"];
    for (NSString *item in colorDictionary) {
        
        [self.colorFilter addObject:item];
        [self.colorFilterCounter addObject:(NSNumber *)colorDictionary[item]];
    }
    
    NSDictionary *sizeDictionary = facetFieldsDictionary[@"variant"];
    for (NSString *item in sizeDictionary) {
        
        [self.sizeFilter addObject:item];
        [self.sizeFilterCounter addObject:(NSNumber *)sizeDictionary[item]];
    }
    
    return TRUE;
}


#pragma mark - Navigation


- (IBAction)cancelTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end






