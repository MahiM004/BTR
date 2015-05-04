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

#define COUNTRY_PICKER 1
#define GENDER_PICKER 2

@interface BTRSignUpEmbeddedTVC ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (weak, nonatomic) IBOutlet UILabel *firstNameIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *invitationCodeIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryIconLabel;


@property (strong, nonatomic) NSString *chosenCountryCodeString;

@property (strong, nonatomic) NSArray *genderNameArray;
@property (strong, nonatomic) NSArray *countryNameArray;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewForPicker;

@property (nonatomic) NSUInteger pickerType;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


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
    
    [self setupDocument];
    
    self.firstNameTextField = [BTRViewUtility underlineTextField:[self firstNameTextField]];
    self.lastNameTextField = [BTRViewUtility underlineTextField:[self lastNameTextField]];
    self.emailTextField = [BTRViewUtility underlineTextField:[self emailTextField]];
    self.passwordTextField = [BTRViewUtility underlineTextField:[self passwordTextField]];
    self.invitationCodeTextField = [BTRViewUtility underlineTextField:[self invitationCodeTextField]];
    self.genderTextField = [BTRViewUtility underlineTextField:[self genderTextField]];
    self.countryTextField = [BTRViewUtility underlineTextField:[self countryTextField]];
 
    
    self.emailIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.emailIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope-o"];
    
    self.passwordIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.passwordIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-unlock-alt"];
    
    self.firstNameIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.firstNameIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-unlock-alt"];

    self.lastNameIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.lastNameIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-user"];

    self.invitationCodeIconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    self.invitationCodeIconLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-barcode"];
    
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
    
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameIconLabel resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.invitationCodeTextField resignFirstResponder];

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
     
        [self userRegistrationServerCallforSessionId:[self sessionId]
                                             success:^(NSString *didSignUp)
        {
            
            if ([didSignUp  isEqualToString:@"TRUE"]) {
                
                [self performSegueWithIdentifier:@"SignUpToMainSceneSegueIdentifier" sender:self];
            
            } else {
                
                [self alertUserForSignUpError];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        } ];
    }
    
}


- (void)alertUserForSignUpError {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try agian"
                                                    message:@"Sign Up Failed !"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}



- (BOOL)allFieldsAreValid {
    
    if ([[[self firstNameTextField] text] isEqualToString:@""]) {
        
        [self alertSystemFieldIncomplete:@"First Name"];
        return FALSE;
        
    } else if ([[[self lastNameTextField] text] isEqualToString:@""]) {
        
        [self alertSystemFieldIncomplete:@"Last Name"];
        return FALSE;
        
    } else if ([[[self emailTextField] text] isEqualToString:@""]) {
        
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


- (void)alertSystemFieldIncomplete:(NSString *)fieldString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Form"
                                                    message:[NSString stringWithFormat:@"%@ required.", fieldString]
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}




#pragma mark - User Registration RESTful

- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}


- (void)userRegistrationServerCallforSessionId:(NSString *)sessionId
                                success:(void (^)(id  responseObject)) success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *sessionIdString = [self sessionId];
    [manager.requestSerializer setValue:sessionIdString forHTTPHeaderField:@"SESSION"];
    
    NSDictionary *params = (@{
                              @"email": [[self emailTextField] text],
                              @"password": [[self passwordTextField] text],
                              @"gender": [[self genderTextField] text],
                              @"country": [self chosenCountryCodeString],
                              @"name": [[self firstNameTextField] text],
                              @"last_name": [[self lastNameTextField] text],
                              @"invite": [[self invitationCodeTextField ] text]
                              });
    
    [manager POST:[NSString stringWithFormat:@"%@",[BTRUserFetcher URLforUserRegistration]]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                   options:0
                                                                                     error:NULL];
              if (entitiesPropertyList) {
                  
                  NSDictionary *infoDic = entitiesPropertyList[@"info"];
                  NSDictionary *sessionDic = entitiesPropertyList[@"session"];
                  NSDictionary *userDic = entitiesPropertyList[@"user"];
                  NSString *sessionIdString = [sessionDic valueForKey:@"session_id"];

                  BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
                  [btrSettings initSessionId:sessionIdString withEmail:[self.emailTextField text] andPassword:[self.passwordTextField text] hasFBloggedIn:NO];
                  
                  [User signUpUserWithAppServerInfo:infoDic andUserInfo:userDic inManagedObjectContext:[self managedObjectContext]];
                  [self.beyondTheRackDocument saveToURL:[self.beyondTheRackDocument fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                  
                  success(@"TRUE");
              
              } else {
               
                  success(@"FALSE");
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [self alertUserForSignUpError];
              
              failure(operation, error);
          }];
    
}


#pragma mark - PickerView Delegates


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {

    if ([self pickerType] == COUNTRY_PICKER) {
        [self.countryTextField setText:[[self countryNameArray] objectAtIndex:row]];
        
        if ([self.countryTextField.text isEqualToString:@"Canada"]) {
            
            self.chosenCountryCodeString = @"CA";
            
        } else if ([self.countryTextField.text isEqualToString:@"USA"]) {
            
            self.chosenCountryCodeString = @"US";
        }
    }
    
    if ([self pickerType] == GENDER_PICKER) {
        [self.genderTextField setText:[[self genderNameArray] objectAtIndex:row]];
    }
    
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
    int sectionWidth = 300;
    
    return sectionWidth;
}










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
