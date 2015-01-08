//
//  EventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "MainViewController.h"
#import "ShoppingBagViewController.h"



#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "EventsTableTableViewController.h"


#import <math.h>

#define YOUR_CATAGORY 4

@interface MainViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *originalDataArray;


@property (strong, nonatomic) TTScrollSlidingPagesController *slider;


@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // handling boundry indexes for category titles
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
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



-(void)initData{
    
    self.categoryNames = [[NSMutableArray alloc] initWithObjects:
                          @"Women",
                          @"Men",
                          @"Home",
                          @"Outlet",
                          @"Your Catalog",
                          @"Kids",
                          @"Curvey Closet",
                          @"Holiday Sale",
                          nil];
    
    self.categoryCount = [[self categoryNames] count];
    
    self.originalDataArray = [[NSMutableArray alloc] initWithObjects:
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
                               @"eventhome1.png",
                               @"eventhome1.png",
                               @"eventhome1.png",
                               @"eventhome2.png",
                               @"eventhome1.png",
                               @"eventhome2.png",
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
                               @"eventkids.png",
                               @"eventkids.png",
                               @"eventkids.png",
                               @"eventkids.png",
                               @"eventkids.png",
                               nil],
                              
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               nil],
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               
                               nil],
                              
                              nil];
}


- (IBAction)tappedShoppingBag:(id)sender {

    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (IBAction)unwindFromShoppingBagToEventsScene:(UIStoryboardSegue *)unwindSegue
{
}



- (NSInteger) modulaForIndex:(NSInteger)inputInt withCategoryCount:(NSInteger)count
{
    NSInteger relevantInt = (inputInt >= 0) ? (inputInt % count) : ((inputInt % count) + count);

    return relevantInt;
}


- (IBAction)unwindFromShoppingBagToMainScene:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindFromMyAccount:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindToEventViewController:(UIStoryboardSegue *)unwindSegue
{
}


@end


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
