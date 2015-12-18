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
#import "BTRLoader.h"
#import "UITextField+BSErrorMessageView.h"
#import "BTRLoadingButton.h"
#import "TNRadioButtonGroup.h"

@interface BTRSignUpEmbeddedTVC () {
    BTRAppDelegate * appDelegate;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *hasPromoTF;

@property (weak, nonatomic) IBOutlet UILabel *emailIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryIconLabel;
@property (strong, nonatomic) NSString *chosenCountryCodeString;
@property (strong, nonatomic) NSString *sessionId;

@property (weak, nonatomic) IBOutlet UIView *genderSelectionView;
@property (strong, nonatomic) TNRadioButtonGroup* genderGroup;
@property (weak, nonatomic) IBOutlet UIView *countrySelectionView;
@property (strong, nonatomic) NSString* selectedCountry;
@property (strong, nonatomic) TNRadioButtonGroup* countryGroup;

@end


@implementation BTRSignUpEmbeddedTVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
    self.sessionId = [btrSettings sessionId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication]delegate];
    // Add a custom login button to your app
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.frame=CGRectMake(0, 0, 288, 50);
    myLoginButton.backgroundColor = [UIColor clearColor];
    myLoginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [myLoginButton setTitle: @"Join with Facebook" forState: UIControlStateNormal];
    [myLoginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * fImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 25, 25)];
    fImage.image = [UIImage imageNamed:@"facebook"];
    [self.fbButton addSubview:fImage];
    [self.fbButton addSubview:myLoginButton];
    self.fbButton.backgroundColor = [UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:152.0f/255.0f alpha:1.0f];
    self.fbButton.layer.cornerRadius  = 3;
    
    
    self.emailTextField = [BTRViewUtility underlineTextField:[self emailTextField]];
    self.emailIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.emailIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope-o"];
    
    self.passwordTextField = [BTRViewUtility underlineTextField:[self passwordTextField]];
    self.passwordIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.passwordIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-unlock-alt"];
    
    self.genderIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.genderIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-male"];
    [self makeGenderView];
    
    self.countryIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.countryIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-globe"];
    [self makeCountryView];
    
     self.hasPromoTF = [BTRViewUtility underlineTextField:[self hasPromoTF]];
    [self.passwordTextField bs_setupErrorMessageViewWithMessage:@"Minimum 3 characters"];
    [self.emailTextField bs_setupErrorMessageViewWithMessage:@"Incorrect email format"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}
// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
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
                          if ( [BTRViewUtility isIPAD] ) {
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
                                                      @"invite": inviteCode
                                                      });
                          [self fetchFacebookUserSessionforFacebookUserParams:fbParams success:^(NSString *didLogIn) {
                              if ([didLogIn isEqualToString:@"TRUE"])
                                  [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                      [self sendNotification];
                                  }];
                              else
                                  [self showAlert:@"Please try agian" msg:@"Email or Password Incorrect !"];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [self showAlert:@"Please try agian" msg:@"Email or Password Incorrect !"];
                          }];
                      } else {
                          NSLog(@"graph api error: %@", error);
                          [BTRLoader hideLoaderFromView:self.view];
                      }
                  }];
             }
         }
     }];
}

//Manual Join SignUP
- (IBAction)joinButtonTapped:(BTRLoadingButton *)sender {
    if ([_emailTextField.text length] == 0 || ![self validateEmailWithString:_emailTextField.text]) {
        [self showAlert:@"Failed" msg:@"Please give Valid Email ID"];
        [self.emailTextField bs_showError];
    } else if (_passwordTextField.text.length < 3){
        [self showAlert:@"Failed" msg:@"Password should be minimum 3 characters"];
        [self.passwordTextField bs_showError];
    }else {
        if ([appDelegate connected] == 1) {
            [sender showLoading];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [self userRegistrationServerCallWithSuccess:^(NSString *didSignUp, NSString *messageString) {
                    [sender hideLoading];
                    if ([didSignUp  isEqualToString:@"TRUE"]) {
                            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                [self sendNotification];
                            }];
                    } else {
                        if (messageString.length != 0) {
                            [self showAlert:@"Please try agian" msg:messageString];
                        } else {
                            [self showAlert:@"Email or Password Incorrect !" msg:@"Sign Up Failed !"];
                        }
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self showAlert:@"Ooops...!" msg:@"Something went Wrong Please try Again !"];
                    [sender hideLoading];
                }];
            });
        } else {
            [self showAlert:@"Network Error !" msg:@"Please check the internet"];
        }
    }
}
#pragma mark - User Registration RESTful
- (void)userRegistrationServerCallWithSuccess:(void (^)(id  responseObject, NSString *messageString)) success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    if (_hasPromoTF.text.length == 0) {
        if ( [BTRViewUtility isIPAD] ) {
            _hasPromoTF.text = @"IOSTABLETAPP2";
        } else {
            _hasPromoTF.text = @"IOSMOBILEAPP2";
        }
    }
    NSString* url = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforUserRegistration]];
    NSDictionary *params = (@{
                              @"email": [[self emailTextField] text],
                              @"password": [[self passwordTextField] text],
                              @"gender": self.genderGroup.selectedRadioButton.data.identifier,
                              @"country": self.countryGroup.selectedRadioButton.data.identifier,
                              @"invite": [[self hasPromoTF]text]
                              });
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
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
        [self showAlert:@"Please try agian" msg:@"Sign Up Failed !"];
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
        } else if (i_success == 0) {
            [btrSettings clearSession];
            success(@"FALSE", alertString);
        }
    } faild:^(NSError *error) {
        [self showAlert:@"Please try agian" msg:@"Email or Password Incorrect !"];
    }];
}

- (void)attemptAuthenticateWithFacebookUserParams:(NSDictionary *)fbUserParams
                                          success:(void (^)(id  responseObject, NSString *alertString)) success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
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
        } else if (i_success == 0) {
            [btrSettings clearSession];
            success(@"FALSE", nil);
        }
    } faild:^(NSError *error) {
        [self showAlert:@"Please try agian" msg:@"Email or Password Incorrect !"];
    }];
}

- (void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.hasPromoTF resignFirstResponder];
}

-(UIAlertView*)showAlert:(NSString *)title msg:(NSString *)messege {
    UIAlertView * aa = [[UIAlertView alloc]initWithTitle:title message:messege delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [aa show];
    [BTRLoader hideLoaderFromView:self.view];
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

#pragma mark TextField Delegate

- (IBAction)textFieldSelectedOrChanged:(UITextField *)sender {
    [sender bs_hideError];
}

- (void)makeGenderView {
    TNCircularRadioButtonData *maleData = [TNCircularRadioButtonData new];
    maleData.labelText = @"Male";
    maleData.identifier = @"Male";
    maleData.selected = YES;
    maleData.borderColor = [UIColor blackColor];
    maleData.circleColor = [UIColor redColor];
    maleData.borderRadius = 12;
    maleData.circleRadius = 5;
    
    TNCircularRadioButtonData *femaleData = [TNCircularRadioButtonData new];
    femaleData.labelText = @"Female";
    femaleData.identifier = @"Female";
    femaleData.selected = NO;
    femaleData.borderColor = [UIColor blackColor];
    femaleData.circleColor = [UIColor redColor];
    femaleData.borderRadius = 12;
    femaleData.circleRadius = 5;
    
    self.genderGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[maleData,femaleData] layout:TNRadioButtonGroupLayoutHorizontal];
    self.genderGroup.identifier = @"My group";
    [self.genderGroup create];
    self.genderGroup.position = CGPointMake(0, 18);
    [self.genderSelectionView addSubview:self.genderGroup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(genderChanged) name:SELECTED_RADIO_BUTTON_CHANGED object:self.genderGroup];
}

- (void)makeCountryView {
    TNCircularRadioButtonData *usData = [TNCircularRadioButtonData new];
    usData.labelText = @"USA";
    usData.identifier = @"US";
    usData.selected = NO;
    usData.borderColor = [UIColor blackColor];
    usData.circleColor = [UIColor redColor];
    usData.borderRadius = 12;
    usData.circleRadius = 5;
    
    TNCircularRadioButtonData *canadaData = [TNCircularRadioButtonData new];
    canadaData.labelText = @"Canada";
    canadaData.identifier = @"CA";
    canadaData.selected = YES;
    canadaData.borderColor = [UIColor blackColor];
    canadaData.circleColor = [UIColor redColor];
    canadaData.borderRadius = 12;
    canadaData.circleRadius = 5;
    
    self.countryGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[usData,canadaData] layout:TNRadioButtonGroupLayoutHorizontal];
    self.countryGroup.identifier = @"My group";
    [self.countryGroup create];
    self.countryGroup.position = CGPointMake(0, 17);
    [self.countrySelectionView addSubview:self.countryGroup];
}

- (void)genderChanged {
    if ([self.genderGroup.selectedRadioButton.data.identifier isEqualToString:@"male"])
        self.genderIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-male"];
    else
        self.genderIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-female"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.genderGroup];
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

- (IBAction)backToLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end