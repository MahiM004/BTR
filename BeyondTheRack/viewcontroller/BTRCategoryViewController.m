//
//  BTRCategoryViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCategoryViewController.h"


#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "BTREventsCDTVC.h"



@interface BTRCategoryViewController ()

@property (strong, nonatomic) TTScrollSlidingPagesController *slider;


@end

@implementation BTRCategoryViewController

-(void)initData {
    
    
    /* 
     
     TODO: the categoryNames and urlCategoryNames should be refactored into an editable config file 
    
     */
    self.categoryNames = [[NSMutableArray alloc] initWithObjects:@"Women", @"Men", @"Your Catalog", @"Home", @"Kids", @"Outlet", @"My Curvy Closet", nil];
    self.urlCategoryNames = [[NSMutableArray alloc] initWithObjects:@"women", @"men", @"all", @"home", @"kids", @"stockroom", @"curvy_closet", nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    
    [self initData];
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor darkGrayColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    
    self.slider.hideStatusBarWhenScrolling = NO;
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.initialPageNumber = 2;
    self.slider.pagingEnabled = YES;
    self.slider.zoomOutAnimationDisabled = YES;
    self.slider.disableTitleShadow = YES;
    self.slider.titleScrollerBackgroundColour = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];
    //self.slider.titleScrollerHidden = YES;
    //slider.titleScrollerHeight = 100;
    //slider.titleScrollerItemWidth=60;
    //slider.disableUIPageControl = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.slider.hideStatusBarWhenScrolling = YES;//this property normally only makes sense on iOS7+. See the documentation in TTScrollSlidingPagesController.h. If you wanted to use it in iOS6 you'd have to make sure the status bar overlapped the TTScrollSlidingPagesController.
    }
    
    //set the datasource.
    self.slider.dataSource = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)

    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableCellDidSelect:(UITableViewCell *)cell{
    NSLog(@"Tap %@",cell.textLabel.text);
    //DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    //detailVC.label.text = cell.textLabel.text;
    //[self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark TTSlidingPagesDataSource methods

-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return (int)[[self categoryNames] count];
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    
    
    BTREventsCDTVC *myVC  = [[BTREventsCDTVC alloc] init];
    viewController = myVC;
    myVC.categoryName = [[self categoryNames] objectAtIndex:index];
    myVC.urlCategoryName = [[self urlCategoryNames] objectAtIndex:index];
    
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
  
    title = [[TTSlidingPageTitle alloc] initWithHeaderText:[[self categoryNames] objectAtIndex:index]];
    
    return title;
}

#pragma mark - scrollview delegate

-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    NSLog(@"scrolled to view");
}


#pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

 }



@end
