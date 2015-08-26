//
//  BTRSizeChartViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-25.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSizeChartViewController.h"
#import "BTRChartFetcher.h"

@interface BTRSizeChartViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chartTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *chartCategoryCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *chartScrollView;

@property (nonatomic, strong) NSArray* currentCategoryArray;
@property (nonatomic, strong) NSArray* currentImagesArray;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSArray* apparelArray;
@property (nonatomic, strong) NSArray* apparelImages;

@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation BTRSizeChartViewController


- (NSArray *)apparelArray {
    _apparelArray = @[@"WOMEN",@"MEN",@"KID",@"HOW TO MEASURE ( MEN )",@"HOW TO MEASURE ( WOMEN )"];
    return _apparelArray;
}
- (NSArray *)apparelImages {
    _apparelImages = @[@"women_size_chart.jpg",@"men_size_chart.jpg",@"kids_size_chart.jpg",@"how_to_measure_men.jpg",@"how_to_measure_women.jpg"];
    return _apparelImages;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // initialization
    switch (self.category) {
        case apparel:
            self.currentCategoryArray = self.apparelArray;
            self.currentImagesArray = self.apparelImages;
            break;
            
        default:
            break;
    }
    
    // scrollview
    [self.chartScrollView setDelegate:self];
    [self.chartScrollView setMaximumZoomScale:3.0];
    [self.chartScrollView setMinimumZoomScale:0.01];
    
    // cell of collection view
    UINib *cellNib = [UINib nibWithNibName:@"BTRSizeChartCategoryCollectionViewCell" bundle:nil];
    [self.chartCategoryCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    // selecting first cell
    self.selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self collectionView:self.chartCategoryCollectionView didSelectItemAtIndexPath:self.selectedIndexPath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.currentCategoryArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BTRSizeChartCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    cell.categoryTitleLabel.text = [self.currentCategoryArray objectAtIndex:indexPath.row];
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
        cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.currentCategoryArray count] - 2 || indexPath.row == [self.currentCategoryArray count] - 1) {
        return CGSizeMake(230, 30);
    }
    return CGSizeMake(80, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.chartScrollView setZoomScale:1.0];
    [self.imageView removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    if (self.selectedIndexPath) {
        BTRSizeChartCategoryCollectionViewCell *lastSelectedCell  = (BTRSizeChartCategoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        lastSelectedCell.backgroundColor = [UIColor lightGrayColor];
    }
    BTRSizeChartCategoryCollectionViewCell *cell  = (BTRSizeChartCategoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.imageView == nil) {
        self.imageView = [[UIImageView alloc]init];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[BTRChartFetcher URLforImagesOfChartsWithName:[self.currentImagesArray objectAtIndex:indexPath.row]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    [self.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"neulogo.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakSelf.imageView setImage:image];
        [weakSelf.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [weakSelf.chartScrollView setContentSize:CGSizeMake(weakSelf.imageView.frame.size.width, weakSelf.imageView.frame.size.height)];
        [weakSelf.chartScrollView addSubview:weakSelf.imageView];
        if (image.size.width > 500) {
            [weakSelf.chartScrollView setZoomScale:weakSelf.chartScrollView.frame.size.width/image.size.width];
            [weakSelf.chartScrollView setNeedsDisplay];
        }else
            [weakSelf.chartScrollView setZoomScale:1.0];

        [weakSelf scrollViewDidZoom:weakSelf.chartScrollView];
        [cell setBackgroundColor:[UIColor whiteColor]];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    self.selectedIndexPath = indexPath;
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView {
    CGFloat offsetX = (aScrollView.bounds.size.width > aScrollView.contentSize.width)?
    (aScrollView.bounds.size.width - aScrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (aScrollView.bounds.size.height > aScrollView.contentSize.height)?
    (aScrollView.bounds.size.height - aScrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(aScrollView.contentSize.width * 0.5 + offsetX,
                                   aScrollView.contentSize.height * 0.5 + offsetY);
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
