//
//  BTRCategoryViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCategoryViewController.h"
#import "BTRCategoryData.h"
#import "MarqueeLabel.h"
#import "Freeship+appServer.h"
#import "BTRConnectionHelper.h"
#import "BTRFreeshipFetcher.h"
#import "BTREventsVC.h"
#import "ApplePayManager.h"

#define INITIAL_PAGE_INDEX 0

@interface BTRCategoryViewController ()

@property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@property (strong, nonatomic) Freeship* freeshipInfo;
@property (strong, nonatomic) NSDate* dueDate;
@property (weak, nonatomic) IBOutlet UILabel *bannerLabel; // its just hidden
@property (weak, nonatomic) IBOutlet UIView *sliderBackFrame;

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
    
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor darkGrayColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    self.slider.hideStatusBarWhenScrolling = NO;
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.initialPageNumber = INITIAL_PAGE_INDEX;
    self.slider.pagingEnabled = YES;
    self.slider.zoomOutAnimationDisabled = YES;
    self.slider.disableTitleShadow = YES;
    self.slider.titleScrollerBackgroundColour = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.slider.hideStatusBarWhenScrolling = YES;
    }
    
    self.slider.dataSource = self;
    // getting header's info
    [self.bannerLabel setTextColor:[UIColor blackColor]];
    [self getheaderInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    // adding tableview frame
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin:)
                                                 name:kUSERDIDLOGIN
                                               object:nil];
    self.slider.view.frame = _sliderBackFrame.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUSERDIDLOGIN object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [BTRGAHelper logScreenWithName:@"/event"];
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
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
        self.freeshipInfo = [Freeship extractFreeshipInfofromJSONDictionary:response forFreeship:self.freeshipInfo];
        if ([self.freeshipInfo.banner rangeOfString:@"##counter##"].location != NSNotFound) {
            self.dueDate = [NSDate dateWithTimeIntervalSince1970:[self.freeshipInfo.endTimestamp integerValue]];
            [self changeTimerString:nil];
            [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(changeTimerString:) userInfo:nil repeats:YES];
            return ;
        }
//        [_bannerLabel setText:self.freeshipInfo.banner];
        [self.slider.msgLbl setText: self.freeshipInfo.banner];
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
        timerString = [NSString stringWithFormat:@"\nLess than a minute"];
    else {
        timerString = [NSString stringWithFormat:@"\n%02ld days %02d Hours : %02d Minutes",days,hours,minutes];
    }
    NSString* bannerString = [self.freeshipInfo.banner stringByReplacingOccurrencesOfString:@"##counter##" withString:timerString];
//    [_bannerLabel setText:bannerString];
    [self.slider.msgLbl setText: bannerString];
}

- (void) viewWillLayoutSubviews {
    [_bannerLabel setCenter:CGPointMake(self.view.center.x, _bannerLabel.center.y)];
}

#pragma mark header info

- (void)userDidLogin:(NSNotification *) notification {
    [self getheaderInfo];
}

@end










