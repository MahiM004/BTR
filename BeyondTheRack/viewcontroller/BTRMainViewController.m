//
//  EventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRMainViewController.h"
#import "BTRShoppingBagViewController.h"



#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "BTREventsTableTableViewController.h"


#import <math.h>

#define YOUR_CATAGORY 4

@interface BTRMainViewController ()


@property (strong, nonatomic) TTScrollSlidingPagesController *slider;


@end

@implementation BTRMainViewController


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
