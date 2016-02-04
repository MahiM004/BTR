//
//  BTRLoginViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRLoginViewController.h"
#import "BTRBagFetcher.h"
#import "BTRUserFetcher.h"
#import "User+AppServer.h"
#import "BagItem+AppServer.h"
#import "Item+AppServer.h"
#import "BTRConnectionHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BTRLoader.h"
#import "UITextField+BSErrorMessageView.h"
#import "BTRLoadingButton.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface BTRLoginViewController ()<UITextFieldDelegate>
{
    BTRAppDelegate * appDelegate;
}
@property (weak, nonatomic) IBOutlet BTRLoadingButton *loadingBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *emailIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordIconLabel;
@property (nonatomic, strong) NSDictionary *fbUserParams;

@end


@implementation BTRLoginViewController


#pragma mark - Object lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // We wire up the FBSDKLoginButton using the interface builder
        // but we could have also explicitly wired its delegate here.
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - View Management


- (void)viewDidLoad {

    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.fbButton.readPermissions = @[@"public_profile", @"email"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                               action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //setting bottom Line
    self.emailTextField = [BTRViewUtility underlineTextField:[self emailTextField]];
    self.passwordTextField = [BTRViewUtility underlineTextField:[self passwordTextField]];

    //setting email and password icons with Font Awesome
    self.emailIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16];
    self.emailIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope-o"];
    self.passwordIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.passwordIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-unlock-alt"];
    
    [self.passwordTextField bs_setupErrorMessageViewWithMessage:@"Minimum 3 characters"];
    [self.emailTextField bs_setupErrorMessageViewWithMessage:@"Incorrect email format"];
}

- (void)viewWillAppear:(BOOL)animated {
    [BTRGAHelper logScreenWithName:@"/login"];
}

- (IBAction)signInButtonTapped:(BTRLoadingButton *)sender {
    if ([appDelegate connected] == 1) {
        if (_emailTextField.text.length != 0 & _passwordTextField.text.length != 0 & [self validateEmailWithString:_emailTextField.text]) {
            [sender showLoading];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [self fetchUserWithSuccess:^(NSString *didLogIn) {
                    [sender hideLoading];
                    if ([didLogIn  isEqualToString:@"TRUE"]) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            [self sendNotification];
                        }];
                    }
                    else {
                        [self alertUserForLoginError];
                    }
                    
                } failure:^(NSError *error) {
                    [sender hideLoading];
                }];
            });
        }
        else {
            if (![self validateEmailWithString:_emailTextField.text]) {
                [_emailTextField becomeFirstResponder];
                [self.emailTextField bs_showError];
            } else if (self.passwordTextField.text.length < 4) {
                [_passwordTextField becomeFirstResponder];
                [self.passwordTextField bs_showError];
            }
            [self showAlert:@"Please try again" msg:@"Please check the Email and Password !"];
        }
    }
    else {
        [self showAlert:@"Network Error !" msg:@"Please check the internet"];
    }
}

#pragma mark - FBSDKLoginButtonDelegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"Unexpected login error: %@", error);
        NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
        NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        if ([FBSDKAccessToken currentAccessToken]) {
            [BTRLoader showLoaderInView:self.view];
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, gender, first_name, last_name, email"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id responseObject, NSError *error) {
                 if (!error) {
                     NSString *email = [responseObject valueForKeyPath:@"email"];
                     NSString *firstName = [responseObject valueForKeyPath:@"first_name"];
                     NSString *lastName = [responseObject valueForKeyPath:@"last_name"];
                     NSString *gender=[responseObject valueForKeyPath:@"gender"];
                     NSString *fbUserId = [responseObject valueForKeyPath:@"id"];
                     NSString *fbAccessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                     
                     NSString *inviteCode = nil;
                     if ( IDIOM == IPAD ) {
                         inviteCode = @"IOSTABLETAPP2";
                     } else {
                         inviteCode = @"IOSMOBILEAPP2";
                     }
                     NSDictionary *fbParams = (@{
                                                 @"id": fbUserId,
                                                 @"access_token": fbAccessToken,
                                                 @"email": email,
                                                 @"first_name": firstName,
                                                 @"last_name": lastName,
                                                 @"gender": gender,
                                                 @"invite":inviteCode
                                                 });
                     
                     [self fetchFacebookUserSessionforFacebookUserParams:fbParams success:^(NSString *didLogIn) {
                         if ([didLogIn isEqualToString:@"TRUE"]) {
                             [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                 [self sendNotification];
                             }];
                         } else {
                             [self alertUserForLoginError];
                         }
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self alertUserForLoginError];
                     }];
                 } else {
                     NSLog(@"graph api error: %@", error);
                     [BTRLoader hideLoaderFromView:self.view];
                 }
             }];
        }
    }
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

#pragma mark - Load User RESTful

- (void)fetchUserWithSuccess:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforUserAuthentication]];
    NSDictionary *params = (@{
                              @"username" :[NSString stringWithFormat:@"%@",[[self emailTextField] text]],
                              @"password":[NSString stringWithFormat:@"%@",[[self passwordTextField] text]]
                              });
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:NO contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if ([[response valueForKey:@"success"]boolValue]) {
            NSDictionary *tempDic = response[@"session"];
            NSDictionary *userDic = response[@"user"];
            NSString *sessionIdString = [tempDic valueForKey:@"session_id"];
            BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
            [btrSettings initSessionId:sessionIdString withEmail:[[self emailTextField] text] andPassword:[[self passwordTextField] text] hasFBloggedIn:NO];
            User *user = [[User alloc] init];
            [User userAuthWithAppServerInfo:userDic forUser:user];
            success(@"TRUE");
        } else {
            BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
            [btrSettings clearSession];
            success(@"FALSE");
        }
    } faild:^(NSError *error) {
        failure(error);
        [self alertUserForLoginError];
    }];
}
- (void)fetchFacebookUserSessionforFacebookUserParams:(NSDictionary *)fbUserParams
                                     success:(void (^)(id  responseObject)) success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    [self attemptAuthenticateWithFacebookUserParams:fbUserParams
                                            success:^(NSString *didLogIn, NSString *alertString)
     {
         if ([didLogIn  isEqualToString:@"TRUE"]) {
             success(@"TRUE");
         } else {
             [self attemptRegisterWithFacebookUserParams:fbUserParams success:^(NSString *didLogIn, NSString *alertString) {
                 if ([didLogIn  isEqualToString:@"TRUE"]) {
                     success(@"TRUE");
                 } else {
                     success(@"FALSE");
                 }
             } failure:^(NSError *error) {
                 success(@"FALSE");
             }];
         }
     } failure:^(NSError *error) {
         success(@"FALSE");
     }];
}
- (void)attemptRegisterWithFacebookUserParams:(NSDictionary *)fbUserParams
                                     success:(void (^)(id  responseObject, NSString *alertString)) success
                                     failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforFacebookRegistration]];
    [BTRConnectionHelper postDataToURL:url withParameters:fbUserParams setSessionInHeader:NO contentType:kContentTypeJSON success:^(NSDictionary *response) {
        BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
        int i_success = -1;
        if ([response valueForKey:@"success"])
            i_success = [[response valueForKey:@"success"] intValue];
        NSString *alertString = [response valueForKey:@"error"];
        if (i_success == 1) {
            NSDictionary *tempDic = response[@"session"];
            NSDictionary *userDic = response[@"user"];
            NSString *sessionIdString = [tempDic valueForKey:@"session_id"];
            [btrSettings initSessionId:sessionIdString withEmail:[self.emailTextField text] andPassword:[self.passwordTextField text] hasFBloggedIn:YES];
            User *user = [[User alloc] init];
            [User userAuthWithAppServerInfo:userDic forUser:user];
            success(@"TRUE", nil);
        } else if (i_success == 0){
            [btrSettings clearSession];
            success(@"FALSE", alertString);
        }
    } faild:^(NSError *error) {
        [self alertUserForLoginError];
    }];
}
- (void)attemptAuthenticateWithFacebookUserParams:(NSDictionary *)fbUserParams
                                      success:(void (^)(id  responseObject, NSString *alertString)) success
                                      failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforFacebookAuthentication]];
    [BTRConnectionHelper postDataToURL:url withParameters:fbUserParams setSessionInHeader:NO contentType:kContentTypeJSON success:^(NSDictionary *response) {
        BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
        NSDictionary *sessionObject = response[@"session"];
        NSString *sessionIdString = sessionObject[@"session_id"];
        NSDictionary *userObject = response[@"user"];
        NSString *email = userObject[@"email"];
        NSString *password = userObject[@"password"];
        int i_success = -1;
        if ([response valueForKey:@"success"])
            i_success = [[response valueForKey:@"success"] intValue];
        if (i_success == 1) {
            [btrSettings initSessionId:sessionIdString withEmail:email andPassword:password hasFBloggedIn:YES];
            success(@"TRUE", nil);
        } else if (i_success == 0){
            [btrSettings clearSession];
            success(@"FALSE", nil);
        }
    } faild:^(NSError *error) {
        [self alertUserForLoginError];
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [BTRLoader hideLoaderFromView:self.view];
}

- (void)alertUserForLoginError {
    [[[UIAlertView alloc] initWithTitle:@"Please try agian"
                                message:@"Email or Password Incorrect !"
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
    [BTRLoader hideLoaderFromView:self.view];
}

- (void)dismissKeyboard {
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
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

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TextField Delegations

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [_passwordTextField resignFirstResponder];
        [self signInButtonTapped:_loadingBtn];
    }
    return YES;
}

- (IBAction)textFieldValueChangedOrSelected:(UITextField *)sender {
    [sender bs_hideError];
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    [sender setValue:[UIColor clearColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [sender setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)sendNotification {
    [[NSNotificationCenter defaultCenter]postNotificationName:kUSERDIDLOGIN object:nil];
}


@end