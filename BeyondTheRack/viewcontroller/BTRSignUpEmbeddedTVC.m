//
//  BTRSignUpEmbeddedTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-17.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSignUpEmbeddedTVC.h"
#import "BTRUserFetcher.h"
#import "User+AppServer.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BTRConnectionHelper.h"

#define COUNTRY_PICKER 1
#define GENDER_PICKER 2


@interface BTRSignUpEmbeddedTVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryIconLabel;
@property (strong, nonatomic) NSString *chosenCountryCodeString;
@property (strong, nonatomic) NSArray *genderNameArray;
@property (strong, nonatomic) NSArray *countryNameArray;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewForPicker;
@property (nonatomic) NSUInteger pickerType;
@property (strong, nonatomic) NSString *sessionId;

@end




@implementation BTRSignUpEmbeddedTVC


- (NSArray *)genderNameArray {
    _genderNameArray = @[@"Female", @"Male"];
    return _genderNameArray;
}

- (NSArray *)countryNameArray {
    
    _countryNameArray = @[@"Canada", @"USA"];
    return _countryNameArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
    self.sessionId = [btrSettings sessionId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.emailTextField = [BTRViewUtility underlineTextField:[self emailTextField]];
    self.passwordTextField = [BTRViewUtility underlineTextField:[self passwordTextField]];
    self.genderTextField = [BTRViewUtility underlineTextField:[self genderTextField]];
    self.countryTextField = [BTRViewUtility underlineTextField:[self countryTextField]];
    self.emailIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.emailIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope-o"];
    self.passwordIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.passwordIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-unlock-alt"];
    self.genderIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.genderIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-female"];
    self.countryIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.countryIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-globe"];
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)genderButtonTapped:(UIButton *)sender {
    [self setPickerType:GENDER_PICKER];
    [self.pickerView reloadAllComponents];
    [self dismissKeyboard];
    [self.viewForPicker setHidden:FALSE];
}


- (IBAction)countryButtonTapped:(UIButton *)sender {
    [self setPickerType:COUNTRY_PICKER];
    [self.pickerView reloadAllComponents];
    [self dismissKeyboard];
    [self.viewForPicker setHidden:FALSE];
}



- (IBAction)joinButtonTapped:(UIButton *)sender {
    if ([self allFieldsAreValid]) {
        [self userRegistrationServerCallWithSuccess:^(NSString *didSignUp, NSString *messageString) {
            if ([didSignUp  isEqualToString:@"TRUE"]) {
                [self performSegueWithIdentifier:@"SignUpToInitSceneSegueIdentifier" sender:self];
            } else {
                
                if (messageString == nil)
                    [self alertUserForSignUpError];
                else
                    [self alertUserForLoginErrorWithMessage:messageString];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        } ];
    }
}




#pragma mark - Alerts



- (void)alertUserForSignUpError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try agian"
                                                    message:@"Sign Up Failed !"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}



- (BOOL)allFieldsAreValid {
    if ([[[self emailTextField] text] isEqualToString:@""]) {
        [self alertSystemFieldIncomplete:@"Email"];
        return FALSE;
        
    } else if ([[[self passwordTextField] text] isEqualToString:@""]) {
        [self alertSystemFieldIncomplete:@"Password"];
        return FALSE;
        
    } else if ([[[self genderTextField] text] isEqualToString:@""]) {
        [self alertSystemFieldIncomplete:@"Gender"];
        return FALSE;
        
    } else if ([[[self countryTextField] text] isEqualToString:@""]) {
        [self alertSystemFieldIncomplete:@"Country"];
        return FALSE;
    }
    return TRUE;
}




- (void)alertSystemFieldIncomplete:(NSString *)fieldString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Form"
                                                    message:[NSString stringWithFormat:@"%@ required.", fieldString]
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}




- (void)alertUserForLoginError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try agian"
                                                    message:@"Email or Password Incorrect !"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}



- (void)alertUserForLoginErrorWithMessage:(NSString *)messageString {
    NSString *alertMessage = @"Email or Password Incorrect !";
    if ([messageString length] > 0)
        alertMessage = messageString;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
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
                         if ([didLogIn isEqualToString:@"TRUE"])
                             [self performSegueWithIdentifier:@"SignUpToInitSceneSegueIdentifier" sender:self];
                        else
                             [self alertUserForLoginError];
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self alertUserForLoginError];
                     }];
                 } else
                     NSLog(@"graph api error: %@", error);
             }];
        }
    }
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
}

#pragma mark - User Registration RESTful

- (void)userRegistrationServerCallWithSuccess:(void (^)(id  responseObject, NSString *messageString)) success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforUserRegistration]];
    NSDictionary *params = (@{
                              @"email": [[self emailTextField] text],
                              @"password": [[self passwordTextField] text],
                              @"gender": [[self genderTextField] text],
                              @"country": [self chosenCountryCodeString],
                              });
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES success:^(NSDictionary *response) {
        if (response) {
            int error_code = (int)[[response valueForKey:@"error_code"] intValue];
            if (error_code == 400) {
                NSArray *messageArray = response[@"messages"];
                success(@"FALSE", messageArray[0]);
            } else {
                NSDictionary *infoDic = response[@"info"];
                NSDictionary *sessionDic = response[@"session"];
                NSDictionary *userDic = response[@"user"];
                NSString *sessionIdString = [sessionDic valueForKey:@"session_id"];
                BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
                [sessionSettings initSessionId:sessionIdString withEmail:[self.emailTextField text] andPassword:[self.passwordTextField text] hasFBloggedIn:NO];
                User *user = [[User alloc] init];
                [User signUpUserWithAppServerInfo:infoDic andUserInfo:userDic forUser:user];
                success(@"TRUE", nil);
            }
            
        } else
            success(@"FALSE", nil);

    } faild:^(NSError *error) {
        [self alertUserForSignUpError];
        failure(nil, error);
    }];
}




- (void)fetchFacebookUserSessionforFacebookUserParams:(NSDictionary *)fbUserParams
                                              success:(void (^)(id  responseObject)) success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    [self attemptRegisterWithFacebookUserParams:fbUserParams success:^(NSString *didLogIn, NSString *alertString) {
        if ([didLogIn  isEqualToString:@"TRUE"]) {
            success(@"TRUE");
        } else {
            [self attemptAuthenticateWithFacebookUserParams:fbUserParams
                                                    success:^(NSString *didLogIn, NSString *alertString) {
                 if ([didLogIn  isEqualToString:@"TRUE"])
                     success(@"TRUE");
                 else
                     success(@"FALSE");
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 success(@"FALSE");
             }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(@"FALSE");
    }];
}



- (void)attemptRegisterWithFacebookUserParams:(NSDictionary *)fbUserParams
                                      success:(void (^)(id  responseObject, NSString *alertString)) success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
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
        } else if (i_success == 0) {
            [btrSettings clearSession];
            success(@"FALSE", alertString);
        }
    } faild:^(NSError *error) {
        [self alertUserForLoginError];
    }];
}

- (void)attemptAuthenticateWithFacebookUserParams:(NSDictionary *)fbUserParams
                                          success:(void (^)(id  responseObject, NSString *alertString)) success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
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
        } else if (i_success == 0) {
            [btrSettings clearSession];
            success(@"FALSE", nil);
        }
    } faild:^(NSError *error) {
        [self alertUserForLoginError];
    }];
}


#pragma mark - PickerView Delegates


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if ([self pickerType] == COUNTRY_PICKER) {
        [self.countryTextField setText:[[self countryNameArray] objectAtIndex:row]];
        if ([self.countryTextField.text isEqualToString:@"Canada"])
            self.chosenCountryCodeString = @"CA";
        else if ([self.countryTextField.text isEqualToString:@"USA"])
            self.chosenCountryCodeString = @"US";
    }
    if ([self pickerType] == GENDER_PICKER)
        [self.genderTextField setText:[[self genderNameArray] objectAtIndex:row]];
    [self.viewForPicker setHidden:TRUE];
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] count];
    return [[self genderNameArray] count];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] objectAtIndex:row];
    return [[self genderNameArray] objectAtIndex:row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300.0;
}




@end
































