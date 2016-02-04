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
#import "UITextField+BSErrorMessageView.h"

@interface BTRForgotPasswordVC ()
{
    NSDictionary * responseDic;
    BTRAppDelegate * appDelegate;
}
@end

@implementation BTRForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication]delegate];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self.emailField bs_setupErrorMessageViewWithMessage:@"Incorrect email format"];
}

- (void)viewWillAppear:(BOOL)animated {
    [BTRGAHelper logScreenWithName:@"/forgotPassword"];
}

- (void)dismissKeyboard {
    [self.emailField resignFirstResponder];
}

- (IBAction)newPasswordTapped:(BTRLoadingButton *)sender {
    
    if ([appDelegate connected] == 1) {
        
        if ([self.emailField.text length] != 0 && [self validateEmailWithString:_emailField.text]) {
            [sender showLoading];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [self resetPasswordforEmail:[[self emailField] text] success:^(NSString *didSucceed) {
                    [sender hideLoading];
                    int successUser = [responseDic[@"success"] intValue];
                    NSString * messege = responseDic[@"message"];
                    NSLog(@"%@",responseDic);
                    if (successUser == 1) {
                        [self dismissKeyboard];
                        if (messege.length != 0) {
                            [self showAlert:@"Check your email" msg:messege];
                        } else {
                            [self showAlert:@"Success" msg:@"Reset link is sent to Your given Email"];
                        }
                        [self performSegueWithIdentifier:@"unwindToLoginScene" sender:self];
                    } else {
                        [self showAlert:@"Failed" msg:messege];
                    }
                    
                } failure:^(NSError *error) {
                    [sender hideLoading];
                }];
            });
        }
        else {
            [self showAlert:@"Failed" msg:@"It seems to be you did not given valid email address"];
            [self.emailField bs_showError];
        }
    } else {
        [self showAlert:@"Network Error !" msg:@"Please check the internet"];
    }
    
}

- (void)resetPasswordforEmail:(NSString *)emailString
                           success:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure {
    NSString *url = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforPasswordReset]];
    NSDictionary *params = (@{ @"email": emailString });
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:NO contentType:kContentTypeJSON success:^(NSDictionary *response) {
        responseDic = [NSDictionary dictionaryWithDictionary:response];
        success(@"TRUE");
    } faild:^(NSError *error) {
        failure(error);
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyGo) {
        [self newPasswordTapped:_loadingBtn];
    }
    return YES;
}

-(UIAlertView*)showAlert:(NSString *)title msg:(NSString *)messege {
    UIAlertView * aa = [[UIAlertView alloc]initWithTitle:title message:messege delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [aa show];
    return aa;
}

- (BOOL)validateEmailWithString:(NSString*)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)backToLoginTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TextField delegate

- (IBAction)textFieldSelectedOrChanged:(UITextField *)sender {
    [sender bs_hideError];
}


@end