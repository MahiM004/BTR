//
//  BTRLoginViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRLoginViewController.h"
#import "FAImageView.h"
#import "NSString+FontAwesome.h"

@interface BTRLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UILabel *emailIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordIconLabel;

@end

@implementation BTRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                               action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    

    [self setNeedsStatusBarAppearanceUpdate];
 
    
    
    self.emailTextField = [BTRViewUtility underlineTextField:[self emailTextField]];
    self.passwordTextField = [BTRViewUtility underlineTextField:[self passwordTextField]];
    
    
    /*
     self.someLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
     self.someLabel.text = [NSString fontAwesomeIconStringForEnum:FAGithub];
     self.someLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-github"];
     */
    
    
    /*
     FAImageView *imageView = [[FAImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 100.f)];
     imageView.image = nil;
     [imageView setDefaultIconIdentifier:@"fa-github"];
     */
    
    
    self.emailIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16];
    self.emailIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope-o"];
    
    self.passwordIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.passwordIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-unlock-alt"];
    
    
}




- (void)dismissKeyboard {
    
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
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
