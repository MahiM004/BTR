//
//  EventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.categoryLabel.text = [self catText];
    self.pageControl.numberOfPages = [self categoryCount];
    self.pageControl.currentPage = [self selectedCategoryIndex];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
