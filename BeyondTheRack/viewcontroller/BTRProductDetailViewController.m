//
//  BTRProductDetailViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailViewController.h"

#import "BTRProductShowcaseVC.h"
#import "BTRProductDetailEmbeddedTVC.h"


@interface BTRProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;


@end

@implementation BTRProductDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if ([[[self productItem] brand] length] > 1)
        [self.eventTitleLabel setText:[[self productItem] brand]];
    else
        [self.eventTitleLabel setText:@"Product Detail"];

    
    [self.view setBackgroundColor:[BTRViewUtility BTRBlack]];
    [self.headerView setBackgroundColor:[BTRViewUtility BTRBlack]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (IBAction)backButtonTapped:(UIButton *)sender {
    
    
    if ([[self originVCString] isEqualToString:SEARCH_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToSearchScene" sender:self];
    
    if ([[self originVCString] isEqualToString:EVENT_SCENE])
        [self performSegueWithIdentifier:@"unwindFromProductDetailToShowcase" sender:self];
}

- (IBAction)bagButtonTapped:(UIButton *)sender {
    
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];

}

- (IBAction)searchButtonTapped:(UIButton *)sender {
   
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSearchViewController *viewController = (BTRSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchNavigationControllerIdentifier"];
    [self presentViewController:viewController animated:NO completion:nil];*/
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"ProductDetailEmbeddedSegueIdentifier"])
    {
        BTRProductDetailEmbeddedTVC *embeddedVC = [segue destinationViewController];
        embeddedVC.productItem = [self productItem];
        
    }
}



@end
