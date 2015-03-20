//
//  BTRSignUpEmbeddedTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-17.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSignUpEmbeddedTVC.h"

#import "BTRUserFetcher.h"

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

@property (strong, nonatomic) NSArray *genderNameArray;
@property (strong, nonatomic) NSArray *countryNameArray;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewForPicker;

@property (nonatomic) NSUInteger pickerType;



@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


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


- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - PickerView Delegates


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {

    
    
    if ([self pickerType] == COUNTRY_PICKER)
        [self.countryTextField setText:[[self countryNameArray] objectAtIndex:row]];
    
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
