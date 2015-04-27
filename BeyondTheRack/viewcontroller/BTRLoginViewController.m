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

@end

@implementation BTRLoginViewController
/*
{
    BOOL _viewDidAppear;
    BOOL _viewIsVisible;
}
*/

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    self.fbButton.readPermissions = @[@"public_profile", @"email"];

    // If there's already a cached token, read the profile information.
    if ([FBSDKAccessToken currentAccessToken]) {
        
        int needs_session_from_backend;
        
        [self performSegueWithIdentifier:@"LaunchCategoriesModalSegue" sender:self];
        // User is logged in, do work such as go to next view controller.

        NSLog(@"trtr FBSDKAccessToken");
        [self observeProfileChange:nil];
    }
    
    
    
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


#pragma mark - Actions

- (IBAction)showLogin:(UIStoryboardSegue *)segue
{
    // This method exists in order to create an unwind segue to this controller.
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
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@", result);
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



#pragma mark - Observations

- (void)observeProfileChange:(NSNotification *)notfication {
    
    //NSLog(@"observeProfileChange: %@-%@  nnname: %@", [[FBSDKProfile currentProfile]  firstName], [[FBSDKProfile currentProfile] lastName], [[FBSDKProfile currentProfile] name]);
    
    if ([FBSDKProfile currentProfile]) {
        //NSString *title = [NSString stringWithFormat:@"continue as %@", [FBSDKProfile currentProfile].name];
        //[self.continueButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)observeTokenChange:(NSNotification *)notfication {
    
    //NSLog(@"observeTokenChange: %@    -- for User: %@", [[FBSDKAccessToken currentAccessToken] tokenString], [[FBSDKAccessToken currentAccessToken] userID]);
    
    if (![FBSDKAccessToken currentAccessToken]) {
        
       // [self.continueButton setTitle:@"continue as a guest" forState:UIControlStateNormal];
    } else {
        
        [self performSegueWithIdentifier:@"LaunchCategoriesModalSegue" sender:self];

        int needs_session_from_backend;
        
        [self observeProfileChange:nil];
    }
}


- (void)dismissKeyboard {
    
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



- (IBAction)signInButtonTapped:(UIButton *)sender {

    [self fetchItemsIntoDocument:[self beyondTheRackDocument] success:^(NSString *didLogIn) {
        
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



#pragma mark - Load User RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}

- (void)fetchItemsIntoDocument:(UIManagedDocument *)document
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



/*
#pragma mark - Navigation

 
*/


@end











