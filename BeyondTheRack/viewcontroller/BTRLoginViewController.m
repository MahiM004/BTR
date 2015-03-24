//
//  BTRLoginViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRLoginViewController.h"

#import "BTRUserFetcher.h"
#import "User+AppServer.h"

@interface BTRLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UILabel *emailIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordIconLabel;



@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation BTRLoginViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setupDocument];
    
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end











