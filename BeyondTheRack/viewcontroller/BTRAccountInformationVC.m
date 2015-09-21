//
//  BTRAccountInformationVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountInformationVC.h"
#import "BTRConnectionHelper.h"
#import "BTRSettingManager.h"
#import "BTRUserFetcher.h"
#import "User+AppServer.h"
#import "BTRLoader.h"

#define COUNTRY_PICKER     1
#define GENDER_PICKER      2
#define INCOME_PICKER      3
#define CHILDREN_PICKER    4
#define MARITAL_PICKER     5
#define EDUCATION_PICKER   6
#define PROVINCE_PICKER    7
#define STATE_PICKER       8

@interface BTRAccountInformationVC ()
{
    BTRAppDelegate * appDelegate;
}
@property (nonatomic) NSUInteger pickerType;

@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSArray *countryNameArray;
@property (strong, nonatomic) NSArray *incomeBracketArray;
@property (strong, nonatomic) NSArray *childrenArray;
@property (strong, nonatomic) NSArray *maritalStatusArray;
@property (strong, nonatomic) NSArray *formalEducationArray;

@property (strong, nonatomic) NSArray *provincesArray;
@property (strong, nonatomic) NSArray *statesArray;

@property (nonatomic, strong) User *user;

@end




@implementation BTRAccountInformationVC

- (NSArray *)genderArray {
    _genderArray = @[@"Female", @"Male"];
    return _genderArray;
}

- (NSArray *)countryNameArray {
    _countryNameArray = @[@"Canada", @"USA"];
    return _countryNameArray;
}

- (NSArray *)incomeBracketArray {
    _incomeBracketArray = @[@"Up to $60,000", @"$60,000 to $100,000", @"$100,000 to $150,000", @"Over $150,000"];
    return _incomeBracketArray;
}

- (NSArray *)childrenArray {
    _childrenArray = @[@"Young children", @"Teenage children", @"Adult children"];
    return _childrenArray;
}


- (NSArray *)maritalStatusArray {
    _maritalStatusArray = @[@"Single", @"Unmarried", @"Married", @"Divorced", @"Widowed"];
    return _maritalStatusArray;
}


- (NSArray *)formalEducationArray {
    _formalEducationArray = @[@"Primary school", @"Secondary school", @"College", @"University", @"Graduate studies"];
    return _formalEducationArray;
}


- (NSArray *)provincesArray {
    _provincesArray = @[@"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick",
                        @"New foundland & Labrador", @"Northwest Territories", @"Nova Scotia",
                        @"Nunavut", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan", @"Yukon"];
    return _provincesArray;
}


- (NSArray *)statesArray {
    _statesArray = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut",
                     @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa",
                     @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan",
                     @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire",
                     @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma",
                     @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee",
                     @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];

    return _statesArray;
}




# pragma mark - UI

- (void)viewDidLoad {
    
    [super viewDidLoad];
     appDelegate = [[UIApplication sharedApplication]delegate];
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerParentView setHidden:TRUE];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self fetchUserInfoforSessionId:[sessionSettings sessionId] success:^(User *user) {
        
        [self.firstNameTextField setText:[user name]];
        [self.lastNameTextField setText:[user lastName]];
        [self.genderTextField setText:[user gender]];
        [self.maritalStatusTextField setText:[user maritalStatus]];
        [self.childrenTextField setText:[user children]];
        [self.formalEducationTextField setText:[user education]];
        [self.incomeBracketTextField setText:[user income]];
        [self.occupationTextField setText:[user occupation]];
        [self.shoppingClubsTextField setText:[user favoriteShopping]];
        [self.mobilePhoneTextField setText:[user mobile]];
        [self.emailTextField setText:[user email]];
        [self.alternateEmailTextField setText:[user alternateEmail]];
        [self.postalCodeTextField setText:[user postalCode]];
        [self.address1TextField setText:[user addressLine1]];
        [self.address2TextField setText:[user addressLine2]];
        [self.cityTextField setText:[user city]];
        
        NSString *provinceToShow = [BTRViewUtility provinceNameforCode:[user province]];
        
        [self.provinceTextField setText:provinceToShow];
        
        if ([user.country isEqualToString:@"CA"])
            [self.countryTextField setText:@"Canada"];
        else if ([user.country isEqualToString:@"US"])
            [self.countryTextField setText:@"USA"];
        
        [[BTRSettingManager defaultManager]setInSetting:user.country forKey:kUSERLOCATION];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)loadPickerViewforType:(NSUInteger)type {
    [self setPickerType:type];
    [self.pickerView reloadAllComponents];
    [self dismissKeyboard];
    [self.pickerParentView setHidden:FALSE];
    [self.pickerView becomeFirstResponder];
}


- (IBAction)genderTapped:(UIButton *)sender {
    [self loadPickerViewforType:GENDER_PICKER];
}


- (IBAction)maritalStatusTapped:(UIButton *)sender {
    [self loadPickerViewforType:MARITAL_PICKER];
}


- (IBAction)childrenTapped:(UIButton *)sender {
    [self loadPickerViewforType:CHILDREN_PICKER];
}


- (IBAction)education:(UIButton *)sender {
    [self loadPickerViewforType:EDUCATION_PICKER];
}


- (IBAction)incomeBracketTapped:(UIButton *)sender {
    [self loadPickerViewforType:INCOME_PICKER];
}


- (IBAction)provinceButton:(UIButton *)sender {
    if ([self.countryTextField.text isEqualToString:@"Canada"])
        [self loadPickerViewforType:PROVINCE_PICKER];
    else if ([self.countryTextField.text isEqualToString:@"USA"])
        [self loadPickerViewforType:STATE_PICKER];
}


- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - PickerView Delegates


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if ([self pickerType] == GENDER_PICKER)
        [self.genderTextField setText:[[self genderArray] objectAtIndex:row]];

    if ([self pickerType] == MARITAL_PICKER)
        [self.maritalStatusTextField setText:[[self maritalStatusArray] objectAtIndex:row]];

    if ([self pickerType] == EDUCATION_PICKER)
        [self.formalEducationTextField setText:[[self formalEducationArray] objectAtIndex:row]];

    if ([self pickerType] == CHILDREN_PICKER)
        [self.childrenTextField setText:[[self childrenArray] objectAtIndex:row]];

    if ([self pickerType] == INCOME_PICKER)
        [self.incomeBracketTextField setText:[[self incomeBracketArray] objectAtIndex:row]];
 
    if ([self pickerType] == PROVINCE_PICKER)
        [self.provinceTextField setText:[[self provincesArray] objectAtIndex:row]];
    
    if ([self pickerType] == STATE_PICKER)
        [self.provinceTextField setText:[[self statesArray] objectAtIndex:row]];
    
    [self.pickerParentView setHidden:TRUE];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] count];

    if ([self pickerType] == INCOME_PICKER)
        return [[self incomeBracketArray] count];
    
    if ([self pickerType] == MARITAL_PICKER)
        return [[self maritalStatusArray] count];
    
    if ([self pickerType] == CHILDREN_PICKER)
        return [[self childrenArray] count];
    
    if ([self pickerType] == EDUCATION_PICKER)
        return [[self formalEducationArray] count];

    if ([self pickerType] == PROVINCE_PICKER)
        return [[self provincesArray] count];
    
    if ([self pickerType] == STATE_PICKER)
        return [[self statesArray] count];
    
    return [[self genderArray] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] objectAtIndex:row];

    if ([self pickerType] == MARITAL_PICKER)
        return [[self maritalStatusArray] objectAtIndex:row];
    
    if ([self pickerType] == EDUCATION_PICKER)
        return [[self formalEducationArray] objectAtIndex:row];
    
    if ([self pickerType] == CHILDREN_PICKER)
        return [[self childrenArray] objectAtIndex:row];
    
    if ([self pickerType] == INCOME_PICKER)
        return [[self incomeBracketArray] objectAtIndex:row];

    if ([self pickerType] == PROVINCE_PICKER)
        return [[self provincesArray] objectAtIndex:row];
    
    if ([self pickerType] == STATE_PICKER)
        return [[self statesArray] objectAtIndex:row];
    
    return [[self genderArray] objectAtIndex:row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300.0;
}

#pragma mark - User Info RESTful

- (void)fetchUserInfoforSessionId:(NSString *)sessionId
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    [BTRConnectionHelper getDataFromURL:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfoDetail]] withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            self.user = [[User alloc]init];
            self.user = [User userWithAppServerInfo:response forUser:[self user]];
            success([self user]);
        }
    } faild:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)updateUserInfoWithSuccess:(void (^)(id  responseObject)) success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString *provinceToPost = [BTRViewUtility provinceCodeforName:[[self provinceTextField] text]];
    NSDictionary *params = (@{
                              @"address1": [[self address1TextField] text],
                              @"address2": [[self address2TextField] text],
                              @"city": [[self cityTextField] text],
                              @"gender": [[self genderTextField] text],
                              @"name": [[self firstNameTextField] text],
                              @"last_name": [[self lastNameTextField] text],
                              @"alternate_email": [[self alternateEmailTextField] text],
                              @"education": [[self formalEducationTextField] text],
                              @"children": [[self childrenTextField] text],
                              @"favorite_shopping": [[self shoppingClubsTextField] text],
                              @"income": [[self incomeBracketTextField] text],
                              @"marital_status": [[self maritalStatusTextField] text],
                              @"occupation": [[self occupationTextField] text],
                              @"region": provinceToPost,
                              @"postal": [[self postalCodeTextField] text]
                              });
    NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfoDetail]];
    [BTRConnectionHelper putDataFromURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(@"TRUE");
        [BTRLoader hideLoaderFromView:self.view];
    } faild:^(NSError *error) {
        failure(nil, error);
        [BTRLoader hideLoaderFromView:self.view];
    }];
}

- (void)updatePasswordWithSuccess:(void (^)(id  responseObject)) success
                          failure:(void (^)(NSError *error)) failure {
    if ([appDelegate connected] == 1) {
        if (_retypePasswordTextField.text.length == 0 || _neuPasswordTextField.text.length == 0) {
            [self showAlert:@"" msg:@"Please Fill the Both Fields to Update the Password"];
            
        } else {
            NSDictionary *params = (@{
                                      @"email": [[self emailTextField] text],
                                      @"password": [[self retypePasswordTextField] text]
                                      });
            [BTRLoader showLoaderInView:self.view];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforCurrentUser]];
                [BTRConnectionHelper putDataFromURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
                    success([[self retypePasswordTextField] text]);
                } faild:^(NSError *error) {
                    failure(error);
                }];
            });
        }
    } else {
        [self showAlert:@"Network Error !" msg:@"Please check the internet"];
    }
}


# pragma mark - Handle update buttons


- (IBAction)updatePasswordTapped:(UIButton *)sender {
    if (_retypePasswordTextField.text.length == 0 || _neuPasswordTextField.text.length == 0) {
        [self showAlert:@"" msg:@"Please Fill the Both Fields to Update the Password"];
        
    }else if ([self.neuPasswordTextField.text isEqualToString:self.retypePasswordTextField.text]) {
        [self updatePasswordWithSuccess:^(NSString *neuPassword) {
            BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
            [btrSettings updatePassword:neuPassword];
            [self.neuPasswordTextField setText:@""];
            [self.retypePasswordTextField setText:@""];
            [BTRLoader hideLoaderFromView:self.view];
            [self showAlert:@"Successful" msg:@"Your password was updated successfully."];
            [_retypePasswordTextField resignFirstResponder];
            [_neuPasswordTextField resignFirstResponder];
        } failure:^(NSError *error) {
            [BTRLoader hideLoaderFromView:self.view];
        }];
    } else
        [self showAlert:@"Attention" msg:@"The passwords do not match!"];
}


- (IBAction)updateInfoTapped:(UIButton *)sender {
    if ([appDelegate connected] == 1) {
        [BTRLoader showLoaderInView:self.view];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self updateUserInfoWithSuccess:^(NSString *successString) {
                [self showAlert:@"Successful" msg:@"Your info was updated successfully."];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        });
    } else {
        [self showAlert:@"Network Error !" msg:@"Please check the internet"];
    }
}

#pragma mark back

- (IBAction)backbuttonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIAlertView*)showAlert:(NSString *)title msg:(NSString *)messege {
    UIAlertView * aa = [[UIAlertView alloc]initWithTitle:title message:messege delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [aa show];
    return aa;
}
@end




























