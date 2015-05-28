//
//  BTRAccountInformationVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountInformationVC.h"

#import "BTRUserFetcher.h"
#import "User+AppServer.h"

#define COUNTRY_PICKER     1
#define GENDER_PICKER      2
#define INCOME_PICKER      3
#define CHILDREN_PICKER    4
#define MARITAL_PICKER     5
#define EDUCATION_PICKER   6
#define PROVINCE_PICKER    7

@interface BTRAccountInformationVC ()

@property (nonatomic) NSUInteger pickerType;


@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSArray *countryNameArray;
@property (strong, nonatomic) NSArray *incomeBracketArray;
@property (strong, nonatomic) NSArray *childrenArray;
@property (strong, nonatomic) NSArray *maritalStatusArray;
@property (strong, nonatomic) NSArray *formalEducationArray;
@property (strong, nonatomic) NSArray *provincesArray;
@property (strong, nonatomic) NSArray *statesArray;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

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
    [self setupDocument];

    
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
        [self.provinceTextField setText:[user province]];
        
        if ([user.country isEqualToString:@"CA"]) {
            
            [self.countryTextField setText:@"Canada"];
            
        } else if ([user.country isEqualToString:@"US"]) {
            
            [self.countryTextField setText:@"USA"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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

- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}


#pragma mark - PickerView Delegates


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    
    if ([self pickerType] == GENDER_PICKER) {
        [self.genderTextField setText:[[self genderArray] objectAtIndex:row]];
    }

    if ([self pickerType] == MARITAL_PICKER) {
        [self.maritalStatusTextField setText:[[self maritalStatusArray] objectAtIndex:row]];
    }

    if ([self pickerType] == EDUCATION_PICKER) {
        [self.formalEducationTextField setText:[[self formalEducationArray] objectAtIndex:row]];
    }

    if ([self pickerType] == CHILDREN_PICKER) {
        [self.childrenTextField setText:[[self childrenArray] objectAtIndex:row]];
    }

    if ([self pickerType] == INCOME_PICKER) {
        [self.incomeBracketTextField setText:[[self incomeBracketArray] objectAtIndex:row]];
    }
 
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
    
    return [[self genderArray] objectAtIndex:row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}




#pragma mark - User Info RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}


- (void)fetchUserInfoforSessionId:(NSString *)sessionId
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfo]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                               options:0
                                                                                 error:NULL];
         
         NSLog(@"-0-00- info : %@", entitiesPropertyList);
         
         int make_sure_nsdictionary_works;
         
         if (entitiesPropertyList) {
             
             User *user = [User userWithAppServerInfo:entitiesPropertyList inManagedObjectContext:[self managedObjectContext]];
             [self.beyondTheRackDocument saveToURL:[self.beyondTheRackDocument fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
             
             success(user);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         // failure(operation, error);
     }];
}


- (void)updateUserInfoforSessionId:(NSString *)sessionId
                          success:(void (^)(id  responseObject)) success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    NSDictionary *params = (@{
                              @"address1": [[self address1TextField] text],
                              @"address2": [[self address2TextField] text],
                              @"city": [[self cityTextField] text],
                              @"gender": [[self genderTextField] text],
                              @"name": [[self firstNameTextField] text],
                              @"last_name": [[self lastNameTextField] text],
                              @"postal": [[self postalCodeTextField] text]
                              });
    
    
    int uncomment_after_info_detail_ready_on_back_end;

                                /*
                              @"alternate_email": [[self alternateEmailTextField] text],
                              @"education": [[self formalEducationTextField] text],
                              @"children": [[self childrenTextField] text],
                              @"favorite_shopping": [[self shoppingClubsTextField] text],
                              @"income": [[self incomeBracketTextField] text],
                              @"marital_status": [[self maritalStatusTextField] text],
                              @"occupation": [[self occupationTextField] text],
                              */
    
    [manager POST:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfo]]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                               options:0
                                                                                 error:NULL];
         
         NSLog(@"-0-00- info : %@", entitiesPropertyList);
         
         int update_local_model;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
}




- (void)updatePasswordforSessionId:(NSString *)sessionId
                           success:(void (^)(id  responseObject)) success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    NSDictionary *params = (@{
                              @"email": [[self emailTextField] text],
                              @"password": [[self retypePasswordTextField] text]
                              });
    
    
    [manager PUT:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforCurrentUser]]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                               options:0
                                                                                 error:NULL];
         
         NSLog(@"-0-00- info : %@", entitiesPropertyList);
         
         int update_local_model;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
}


# pragma mark - Handle update buttons


- (IBAction)updatePasswordTapped:(UIButton *)sender {
    
    if ([self.neuPasswordTextField.text isEqualToString:self.retypePasswordTextField.text]) {
    
        BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
        
        [self updatePasswordforSessionId:[sessionSettings sessionId] success:^(User *user) {
            
            int inform_the_user;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    } else {

        int infor_the_user;
    }
}


- (IBAction)updateInfoTapped:(UIButton *)sender {

    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    [self updateUserInfoforSessionId:[sessionSettings sessionId] success:^(User *user) {
 
        int inform_the_user;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



@end




























