//
//  BTRAccountInformationVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountInformationVC.h"

#import "BTRUserFetcher.h"


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

    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerParentView setHidden:TRUE];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    
    NSLog(@"outside -0000-0 : %@", [sessionSettings sessionId]);

    
    [self fetchUserInfoforSessionId:[sessionSettings sessionId] success:^(NSString *didSucceed) {
        
        
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
    //[self.pickerView setHidden:TRUE];
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



- (void)fetchUserInfoforSessionId:(NSString *)sessionId
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    NSLog(@"inside -90-0 : %@", sessionId);
    
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
         NSArray *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                         options:0
                                                                           error:NULL];
         
         NSLog(@"-0-00- info : %@", entitiesPropertyList);
         
        // success([self itemArray]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         // failure(operation, error);
     }];
    
}




# pragma mark - Handle update buttons


- (IBAction)updatePasswordTapped:(UIButton *)sender {
}


- (IBAction)updateInfoTapped:(UIButton *)sender {
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
