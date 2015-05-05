//
//  BTRSignUpViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSignUpViewController.h"

@interface BTRSignUpViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation BTRSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.scrollView setContentSize:CGSizeMake(320, 1100)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
