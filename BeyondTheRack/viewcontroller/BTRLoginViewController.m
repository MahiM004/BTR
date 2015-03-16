//
//  BTRLoginViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRLoginViewController.h"
#import "FAImageView.h"

@interface BTRLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet FAImageView *emailImageView;
@property (weak, nonatomic) IBOutlet UILabel *someLabel;



@end

@implementation BTRLoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];


    [self setNeedsStatusBarAppearanceUpdate];

/*
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.view.frame.size.height - 1, self.view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.passwordTextField.layer addSublayer:bottomBorder];
 */
    
    self.someLabel.text = [NSString fontAwesomeIconStringForEnum:FAGithub];

    
    //self.someLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-car"];
    
    // or:


}




-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
