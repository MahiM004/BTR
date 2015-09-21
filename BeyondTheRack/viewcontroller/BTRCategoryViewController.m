//
//  BTRCategoryViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCategoryViewController.h"
#import "BTREventsTVC.h"
#import "BTRCategoryData.h"
#import "MarqueeLabel.h"
#import "Freeship+appServer.h"
#import "BTRConnectionHelper.h"
#import "BTRFreeshipFetcher.h"
#import "BTREventsVC.h"

#define INITIAL_PAGE_INDEX 1

@interface BTRCategoryViewController ()

@property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@property (strong, nonatomic) MarqueeLabel *bannerView;
@property (strong, nonatomic) Freeship* freeshipInfo;
@property (strong, nonatomic) NSDate* dueDate;

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
    self.view.backgroundColor = [BTRViewUtility BTRBlack];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.slider.hideStatusBarWhenScrolling = YES;//this property normally only makes sense on iOS7+. See the documentation in TTScrollSlidingPagesController.h. If you wanted to use it in iOS6 you'd have to make sure the status bar overlapped the TTScrollSlidingPagesController.
    }
    
    self.slider.dataSource = self;
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle
    
    // getting header's info
    [self getheaderInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // adding banner
    if (_bannerView == nil) {
        _bannerView = [[MarqueeLabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]applicationFrame].size.width, 25) rate:70.0 andFadeLength:30.0];
        _bannerView.textAlignment = NSTextAlignmentCenter;
        _bannerView.marqueeType = MLContinuous;
        _bannerView.backgroundColor = [BTRViewUtility BTRBlack];
        _bannerView.textColor = [UIColor whiteColor];
        _bannerView.font = [UIFont systemFontOfSize:13];
        _bannerView.text = @"Beyond The Rack";
        [self.view addSubview:_bannerView];
    }
    
    // adding tableview frame
    self.slider.view.frame = CGRectMake(0, _bannerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.bannerView.frame.size.height);
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
}

#pragma mark TTSlidingPagesDataSource methods

- (int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return (int)[[self categoryNames] count];
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    BTREventsVC *myVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BTREventsTableViewController"];
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
 
#pragma mark header info

- (void)getheaderInfo {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRFreeshipFetcher URLforFreeship]];
    self.freeshipInfo = [[Freeship alloc]init];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        self.freeshipInfo = [Freeship extractFreeshipInfofromJSONDictionary:response forFreeship:self.freeshipInfo];
        if ([self.freeshipInfo.banner containsString:@"##counter##"]) {
            self.dueDate = [NSDate dateWithTimeIntervalSince1970:[self.freeshipInfo.endTimestamp integerValue]];
            [self changeTimerString:nil];
            [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(changeTimerString:) userInfo:nil repeats:YES];
            return ;
        }
        [self.bannerView setText:self.freeshipInfo.banner];
        [self.bannerView resetLabel];
    } faild:^(NSError *error) {
        
    }];
}

- (void)changeTimerString:(NSTimer *)timer {
    NSInteger ti = ((NSInteger)[self.dueDate timeIntervalSinceNow]);
    int seconds = ti % 60;
    int minutes = (ti / 60) % 60;
    int hours = ((ti / 60) / 60) % 24;
    long days = ((ti / 60) / 60) / 24;
    if (seconds < 0) {
        [timer invalidate];
        return;
    }
    NSString* timerString;
    if (minutes == 0 && hours == 0)
        timerString = [NSString stringWithFormat:@"Less than a minute"];
    else {
        timerString = [NSString stringWithFormat:@"%02ld days %02d Hours : %02d Minutes",days,hours,minutes];
    }
    NSString* bannerString = [self.freeshipInfo.banner stringByReplacingOccurrencesOfString:@"##counter##" withString:timerString];
    [self.bannerView setText:bannerString];
}


@end










