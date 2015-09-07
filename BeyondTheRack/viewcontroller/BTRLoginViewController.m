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
#import "MBProgressHUD.h"

@interface BTRLoginViewController ()
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
}
- (IBAction)signInButtonTapped:(UIButton *)sender {
    if (_emailTextField.text.length != 0 && _passwordTextField.text.length != 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self fetchUserWithSuccess:^(NSString *didLogIn) {
            [hud hide:YES];
            if ([didLogIn  isEqualToString:@"TRUE"]) {
                [self performSegueWithIdentifier:@"BTRInitializeSegueIdentifier" sender:self];
            }
            else {
                [self alertUserForLoginError];
            }
            
        } failure:^(NSError *error) {
        }];
    } else {
        [[[UIAlertView alloc]initWithTitle:@"Please try again" message:@"Email and Password should not be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
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
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id responseObject, NSError *error) {
                 if (!error) {
                     NSString *email = [responseObject valueForKeyPath:@"email"];
                     NSString *firstName = [responseObject valueForKeyPath:@"first_name"];
                     NSString *lastName = [responseObject valueForKeyPath:@"last_name"];
                     NSString *gender=[responseObject valueForKeyPath:@"gender"];
                     NSString *fbUserId = [responseObject valueForKeyPath:@"id"];
                     NSString *fbAccessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                     NSDictionary *fbParams = (@{
                                                 @"id": fbUserId,
                                                 @"access_token": fbAccessToken,
                                                 @"email": email,
                                                 @"first_name": firstName,
                                                 @"last_name": lastName,
                                                 @"gender": gender
                                                 });
                     
                     [self fetchFacebookUserSessionforFacebookUserParams:fbParams success:^(NSString *didLogIn) {
                         if ([didLogIn isEqualToString:@"TRUE"]) {
                             [self performSegueWithIdentifier:@"BTRInitializeSegueIdentifier" sender:self];
                         } else {
                             [self alertUserForLoginError];
                         }
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self alertUserForLoginError];
                     }];
                 } else {
                     NSLog(@"graph api error: %@", error);
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
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:NO success:^(NSDictionary *response) {
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
        NSLog(@"eooorrooorrr --- %@", error);
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
    [BTRConnectionHelper postDataToURL:url withParameters:fbUserParams setSessionInHeader:NO success:^(NSDictionary *response) {
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
    [BTRConnectionHelper postDataToURL:url withParameters:fbUserParams setSessionInHeader:NO success:^(NSDictionary *response) {
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


- (void)alertUserForLoginError {
    [[[UIAlertView alloc] initWithTitle:@"Please try agian"
                                message:@"Email or Password Incorrect !"
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}
- (void)dismissKeyboard {
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end