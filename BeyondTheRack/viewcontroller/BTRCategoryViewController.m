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
#import "BTREventsTVC.h"
#import "BTRCategoryData.h"

#define INITIAL_PAGE_INDEX 1

@interface BTRCategoryViewController ()

@property (strong, nonatomic) TTScrollSlidingPagesController *slider;


@end

@implementation BTRCategoryViewController


- (NSMutableArray *)categoryNames {
    
    if (!_categoryNames) _categoryNames = [[NSMutableArray alloc] init];
    return _categoryNames;
}

- (NSMutableArray *)urlCategoryNames {
    
    if (!_urlCategoryNames) _urlCategoryNames = [[NSMutableArray alloc] init];
    return _urlCategoryNames;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    BTRCategoryData *sharedCategoryData = [BTRCategoryData sharedCategoryData];
    
    [[self categoryNames] addObjectsFromArray:[sharedCategoryData categoryNameArray]];
    [[self urlCategoryNames] addObjectsFromArray:[sharedCategoryData categoryUrlArray]];
    
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor darkGrayColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    
    self.slider.hideStatusBarWhenScrolling = NO;
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.initialPageNumber = INITIAL_PAGE_INDEX;
    self.slider.pagingEnabled = YES;
    self.slider.zoomOutAnimationDisabled = YES;
    self.slider.disableTitleShadow = YES;
    self.slider.titleScrollerBackgroundColour = [BTRViewUtility BTRBlack];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.slider.hideStatusBarWhenScrolling = YES;//this property normally only makes sense on iOS7+. See the documentation in TTScrollSlidingPagesController.h. If you wanted to use it in iOS6 you'd have to make sure the status bar overlapped the TTScrollSlidingPagesController.
    }
    
    self.slider.dataSource = self;
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TTSlidingPagesDataSource methods


-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
   
    return (int)[[self categoryNames] count];
}


-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{

    UIViewController *viewController;
    
    BTREventsTVC *myVC  = [[BTREventsTVC alloc] init];
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


-(void)didScrollToViewAtIndex:(NSUInteger)index {
}

 



@end










