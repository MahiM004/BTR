//
//  BTRForgotPasswordVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-25.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRForgotPasswordVC.h"
#import "BTRUserFetcher.h"
#import "BTRConnectionHelper.h"

@interface BTRForgotPasswordVC ()

@end

@implementation BTRForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}


- (void)dismissKeyboard {
    [self.emailField resignFirstResponder];
}


- (IBAction)newPasswordTapped:(UIButton *)sender {
    if ([self.emailField.text length] > 0) {
        [self resetPasswordforEmail:[[self emailField] text] success:^(NSString *didSucceed) {
            [self alertUserforNewPassword];
        } failure:^(NSError *error) {
            // TODO: Check for internet connectivity!
        }];
    }
}


- (void)resetPasswordforEmail:(NSString *)emailString
                           success:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure {
    NSString *url = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforPasswordReset]];
    NSDictionary *params = (@{ @"email": emailString });
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:NO success:^(NSDictionary *response) {
        success(@"TRUE");
    } faild:^(NSError *error) {
        failure(error);
    }];
}


- (void)alertUserforNewPassword {
    [self dismissKeyboard];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check your email"
                                                    message:@"A new password was sent to your email address!"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [self performSegueWithIdentifier:@"unwindToLoginScene" sender:self];
    [alert show];
}




@end










