//
//  BTRLoginViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRLoginViewController.h"

#import "BTRUserFetcher.h"

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

    [self fetchItemsIntoDocument:[self beyondTheRackDocument] success:^(NSString *sessionIdString) {
        
        [self performSegueWithIdentifier:@"LaunchCategoriesModalSegue" sender:self];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}




#pragma mark - Load Results RESTful


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

    // for every call
   
    // NSString*sessionIdString = @"9b4b00f5c39f6139768158dd7c5e417ed7ee005c24aaba6b08725a8b";
    //[manager.requestSerializer setValue:@"session" forHTTPHeaderField:sessionIdString];

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
              
              NSDictionary *tempDic = entitiesPropertyList[@"session"];
              NSString *sessionIdString = [tempDic valueForKey:@"session_id"];
              
              [[NSUserDefaults standardUserDefaults] setValue:sessionIdString forKey:@"Session"];
              [[NSUserDefaults standardUserDefaults] setValue:[[self emailTextField] text] forKey:@"Username"];
              [[NSUserDefaults standardUserDefaults] setValue:[[self passwordTextField] text] forKey:@"Password"];
              [[NSUserDefaults standardUserDefaults] synchronize];
              
              success(sessionIdString);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"fail: %@", error);
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











