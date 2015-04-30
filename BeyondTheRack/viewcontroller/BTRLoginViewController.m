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


#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface BTRLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UILabel *emailIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordIconLabel;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@property (nonatomic, strong) NSDictionary *fbUserParams;

@end

@implementation BTRLoginViewController


#pragma mark - Object lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    self.fbButton.readPermissions = @[@"public_profile", @"email"];
    
    [self setupDocument];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                               action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    [self setNeedsStatusBarAppearanceUpdate];
    
    self.emailTextField = [BTRViewUtility underlineTextField:[self emailTextField]];
    self.passwordTextField = [BTRViewUtility underlineTextField:[self passwordTextField]];
    
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
                     
                     [self fetchFacebookUserSessionIntoDocument:[self beyondTheRackDocument] forFacebookUserParams:fbParams success:^(NSString *didLogIn, NSString *alertString) {
                         
                         if ([didLogIn  isEqualToString:@"TRUE"]) {
                             
                             [self performSegueWithIdentifier:@"LaunchCategoriesModalSegue" sender:self];
                         }
                         else {
                             
                             [self alertUserForLoginErrorWithMessage:alertString];
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
    NSLog(@"loginButtonDidLogOut");
}


- (void)dismissKeyboard {
    
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (IBAction)signInButtonTapped:(UIButton *)sender {

    [self fetchUserIntoDocument:[self beyondTheRackDocument] success:^(NSString *didLogIn) {
        
        if ([didLogIn  isEqualToString:@"TRUE"]) {

            [self performSegueWithIdentifier:@"LaunchCategoriesModalSegue" sender:self];
        }
        else {

            [self alertUserForLoginError];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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


/*
#pragma mark - Observations


- (void)observeTokenChange:(NSNotification *)notfication {
    
    //NSLog(@"observeTokenChange: %@    -- for User: %@", [[FBSDKAccessToken currentAccessToken] tokenString], [[FBSDKAccessToken currentAccessToken] userID]);
    
    if (![FBSDKAccessToken currentAccessToken]) {
        
        // [self.continueButton setTitle:@"continue as a guest" forState:UIControlStateNormal];
    } else {
        
       // [self performSegueWithIdentifier:@"LaunchCategoriesModalSegue" sender:self];
        
        int needs_session_from_backend;
    }
}
*/

#pragma mark - Load User RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}



- (void)fetchUserIntoDocument:(UIManagedDocument *)document
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;

    NSLog(@"UITextFields are ignored @: signInButtonTapped");
    
    NSDictionary *params = (@{
                              @"username": @"hadi@jumpinlife.ca",
                              @"password": @"something",
                              });
    
    [manager POST:[NSString stringWithFormat:@"%@",[BTRUserFetcher URLforUserAuthentication]]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              if (entitiesPropertyList) {
              
                  NSDictionary *tempDic = entitiesPropertyList[@"session"];
                  NSDictionary *userDic = entitiesPropertyList[@"user"];
                  NSString *sessionIdString = [tempDic valueForKey:@"session_id"];
                  
                  [[NSUserDefaults standardUserDefaults] setValue:sessionIdString forKey:@"Session"];
                  [[NSUserDefaults standardUserDefaults] setValue:[[self emailTextField] text] forKey:@"Username"];
                  [[NSUserDefaults standardUserDefaults] setValue:[[self passwordTextField] text] forKey:@"Password"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
                  [User userAuthWithAppServerInfo:userDic inManagedObjectContext:[self managedObjectContext]];
                  [document saveToURL:[document fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                  
                  success(@"TRUE");
     
              } else {
                  
                  [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Session"];
                  [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Username"];
                  [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Password"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
                  success(@"FALSE");
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [self alertUserForLoginError];

          }];
}




- (void)fetchFacebookUserSessionIntoDocument:(UIManagedDocument *)document
                       forFacebookUserParams:(NSDictionary *)fbUserParams
                                     success:(void (^)(id  responseObject, NSString *alertString)) success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    
    [manager POST:[NSString stringWithFormat:@"%@",[BTRUserFetcher URLforFacebookRegistration]]
       parameters:fbUserParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              
              int i_success = [[entitiesPropertyList valueForKey:@"success"] intValue];
              NSString *alertString = [entitiesPropertyList valueForKey:@"error"];
              
              
              if (i_success == 1) {
                  
                  NSDictionary *tempDic = entitiesPropertyList[@"session"];
                  NSDictionary *userDic = entitiesPropertyList[@"user"];
                  NSString *sessionIdString = [tempDic valueForKey:@"session_id"];
                  
                  [[NSUserDefaults standardUserDefaults] setValue:sessionIdString forKey:@"Session"];
                  [[NSUserDefaults standardUserDefaults] setValue:[[self emailTextField] text] forKey:@"Username"];
                  [[NSUserDefaults standardUserDefaults] setValue:[[self passwordTextField] text] forKey:@"Password"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
                  [User userAuthWithAppServerInfo:userDic inManagedObjectContext:[self managedObjectContext]];
                  [document saveToURL:[document fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                  
                  success(@"TRUE", nil);
               
              } else if (i_success == 0){
               
                  [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Session"];
                  [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Username"];
                  [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Password"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
               
                  success(@"FALSE", alertString);
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [self alertUserForLoginError];
              
          }];
}






@end


















