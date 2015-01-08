//
//  CategoryViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "CategoryViewController.h"


#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "EventsTableTableViewController.h"



@interface CategoryViewController ()

@property (strong, nonatomic) TTScrollSlidingPagesController *slider;

@end

@implementation CategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor lightGrayColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    
    self.slider.hideStatusBarWhenScrolling = NO;
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.initialPageNumber = 2;
    self.slider.pagingEnabled = YES;
    self.slider.zoomOutAnimationDisabled = YES;
    self.slider.disableTitleShadow = YES;
    
    //self.slider.titleScrollerHidden = YES;
    //slider.titleScrollerHeight = 100;
    //slider.titleScrollerItemWidth=60;
    //self.slider.titleScrollerBackgroundColour = [UIColor redColor];
    //slider.disableUIPageControl = YES;
    //self.slider.titleScrollerBottomEdgeColour = [UIColor blueColor];

    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)tableCellDidSelect:(UITableViewCell *)cell{
    NSLog(@"Tap %@",cell.textLabel.text);
    //DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    //detailVC.label.text = cell.textLabel.text;
    //[self.navigationController pushViewController:detailVC animated:YES];
}




#pragma mark TTSlidingPagesDataSource methods

-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return [[self categoryNames] count];
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    
    
    EventsTableTableViewController *myVC  = [[EventsTableTableViewController alloc] init];
    myVC.eventsArray = [[self dataArray] objectAtIndex:index];
    viewController = myVC;
    
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
  
    title = [[TTSlidingPageTitle alloc] initWithHeaderText:[[self categoryNames] objectAtIndex:index]];
    
    return title;
}

#pragma mark - delegate
-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    NSLog(@"scrolled to view");
}




-(void)initData{
    
    
    self.categoryNames = [[NSMutableArray alloc] initWithObjects:
                          @"Women",
                          @"Men",
                          @"Your Catalog",
                          @"Home",
                          @"Kids",
                          @"Outlet",
                          @"Curvey Closet",
                          nil];
        
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventwomen1.png",
                               @"eventwomen2.png",
                               @"eventwomen3.png",
                               @"eventwomen2.png",
                               @"eventwomen2.png",
                               @"eventwomen3.png",
                               @"eventwomen1.png",
                               @"eventwomen3.png",
                               nil],
                              
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventmen1.png",
                               @"eventmen2.png",
                               @"eventmen1.png",
                               @"eventmen2.png",
                               @"eventmen1.png",
                               @"eventmen2.png",
                               nil],
                      
                      [[NSMutableArray alloc] initWithObjects:
                       @"eventwomen1.png",
                       @"eventwomen2.png",
                       @"eventwomen3.png",
                       @"eventmen1.png",
                       @"eventmen2.png",
                       @"eventhome1.png",
                       @"eventhome2.png",
                       @"eventoutlet1.png",
                       @"eventoutlet2.png",
                       @"eventoutlet3.png",
                       @"eventoutlet4.png",
                       @"eventkids.png",
                       @"eventcurveycloset.png",
                       @"eventholidaysale.png",
                       nil],
                
                      [[NSMutableArray alloc] initWithObjects:
                       @"eventhome1.png",
                       @"eventhome1.png",
                       @"eventhome1.png",
                       @"eventhome2.png",
                       @"eventhome1.png",
                       @"eventhome2.png",
                       nil],
                      
                      [[NSMutableArray alloc] initWithObjects:
                       @"eventkids.png",
                       @"eventkids.png",
                       @"eventkids.png",
                       @"eventkids.png",
                       @"eventkids.png",
                       nil],
                      
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventoutlet1.png",
                               @"eventoutlet2.png",
                               @"eventoutlet3.png",
                               @"eventoutlet4.png",
                               @"eventoutlet2.png",
                               @"eventoutlet4.png",
                               @"eventoutlet1.png",
                               @"eventoutlet3.png",
                               @"eventoutlet1.png",
                               @"eventoutlet1.png",
                               @"eventoutlet2.png",
                               @"eventoutlet4.png",
                               nil],
  
                      
            
                              
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               nil],

                              
                              nil];
}


@end
