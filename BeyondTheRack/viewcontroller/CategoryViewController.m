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
    return 7;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    if (index % 2 == 0){ //just an example, alternating views between one example table view and another.
        viewController = [[EventsTableTableViewController alloc] init];
    } else {
        viewController = [[EventsTableTableViewController alloc] init];
    }
    
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    // if (index == 0){
    //use a image as the header for the first page
    //   title= [[TTSlidingPageTitle alloc] initWithHeaderImage:[UIImage imageNamed:@"about-tomthorpelogo.png"]];
    //} else {
    //all other pages just use a simple text header
    switch (index) {
            
        case 0:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Women"];
            break;
        case 1:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Men"];
            break;
        case 2:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Your Catalog"];
            break;
        case 3:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Home"];
            break;
        case 4:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Kids"];
            break;
        case 5:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Outlet"];
            break;
        case 6:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Curvey Closet"];
            break;
        default:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:[NSString stringWithFormat:@"Page %d", index+1]];
            break;
    }
    
    //                                                                                                                                                                                                                                 }
    return title;
}

#pragma mark - delegate
-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    NSLog(@"scrolled to view");
}


@end
