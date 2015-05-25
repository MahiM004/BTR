//
//  BTRForgotPasswordVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-25.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRForgotPasswordVC.h"
#import "BTRUserFetcher.h"

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
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // TODO: Check for internet connectivity!
            
        }];
    }
}


- (void)resetPasswordforEmail:(NSString *)emailString
                           success:(void (^)(id  responseObject)) success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    
    NSDictionary *params = (@{
                              @"email": emailString
                              });
    
    [manager POST:[NSString stringWithFormat:@"%@",[BTRUserFetcher URLforPasswordReset]]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              // We will just prompt that 'a new password was sent' whether it was successful or not. This is a secuity measure.
              success(@"TRUE");
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              failure(operation, error);
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










