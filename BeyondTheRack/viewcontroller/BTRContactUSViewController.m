//
//  BTRContactUSViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRContactUSViewController.h"
#import "BTRHelpViewController.h"
#import "BTRFAQFetcher.h"
#import "FAQ.h"
#import "FAQ+AppServer.h"
#import "BTRConnectionHelper.h"
#import "BTRContactFetcher.h"
#import "BTRViewUtility.h"
#import "BTRLoader.h"

@interface BTRContactUSViewController ()
@property (strong, nonatomic) NSArray *inquiryArray;
@property (nonatomic, strong) NSArray *faqArray;
@end

@implementation BTRContactUSViewController


- (NSArray *)inquiryArray {
    _inquiryArray = @[_contactInformaion.inquirySignIn,_contactInformaion.inquiryRecentOrder,_contactInformaion.inquiryReturn,_contactInformaion.inquiryProduct,_contactInformaion.inquiryOther];
    return _inquiryArray;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillData];
    self.view.backgroundColor = [BTRViewUtility BTRBlack];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL close = [[NSUserDefaults standardUserDefaults]boolForKey:@"BackButtonPressed"];
    if (close == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"BackButtonPressed"];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BTRLoader hideLoaderFromView:self.view];
}

- (void)fillData {
    // message
    if (self.contactInformaion.lostEmail) {
        self.messageLabel.text = [self.contactInformaion lostEmail];
        self.messageLabelHeight.constant = 120;
        self.messageLabel.hidden = NO;
    } else {
        self.messageLabelHeight.constant = 0;
        self.messageLabel.hidden = YES;
    }
    
    // faq suggestion
    NSString* faqString = [[[self.contactInformaion headersArray]firstObject]content];
    NSRange range = [faqString rangeOfString:@"FAQ"];
    NSMutableAttributedString *faqAttributedString = [[NSMutableAttributedString alloc]initWithString:faqString];
    [faqAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.faqSugesstionLabel.attributedText = faqAttributedString;

    // contact support
    [self.contactSupportTitleLabel setText:[[[self.contactInformaion headersArray]objectAtIndex:1]title]];
    [self.contactSupportContentLabel setText:[[[self.contactInformaion headersArray]objectAtIndex:1]content]];
    
    // customer service
    [self.customerServiceHoursTitleLabel setText:[[[self.contactInformaion headersArray]objectAtIndex:2]title]];
    
    NSString* contactString = [[[self.contactInformaion headersArray]objectAtIndex:2]content];
    range = [contactString rangeOfString:@"1-"];
    NSMutableAttributedString *contactAttributedString = [[NSMutableAttributedString alloc]initWithString:contactString];
    if (range.location != -1) {
        range.length = 14;
        [contactAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    self.customerServiceHoursContentLabel.attributedText = contactAttributedString;
    
    // inquiry
    [self.typeOfEnquiryLabel setText:self.contactInformaion.inquiry];
    
    // order number
    NSMutableAttributedString *orderText = [[NSMutableAttributedString alloc]initWithAttributedString:self.orderNumberLabel.attributedText];
    [[orderText mutableString] replaceOccurrencesOfString:@"if applicable" withString:self.contactInformaion.ifApplicable options:NSCaseInsensitiveSearch range:NSMakeRange(0, orderText.string.length)];
    [[orderText mutableString] replaceOccurrencesOfString:@"Order number" withString:self.contactInformaion.orderNumber options:NSCaseInsensitiveSearch range:NSMakeRange(0, orderText.string.length)];
    self.orderNumberLabel.attributedText = orderText;
    
    // product information
    NSMutableAttributedString *productText = [[NSMutableAttributedString alloc]initWithAttributedString:self.productLabel.attributedText];
    [[productText mutableString] replaceOccurrencesOfString:@"if applicable" withString:self.contactInformaion.ifApplicable options:NSCaseInsensitiveSearch range:NSMakeRange(0, productText.string.length)];
    [[productText mutableString] replaceOccurrencesOfString:@"Product, brand or item number" withString:self.contactInformaion.product options:NSCaseInsensitiveSearch range:NSMakeRange(0, productText.string.length)];
    self.productLabel.attributedText = productText;
    
    // Help Message
    [self.helpLabel setText:self.contactInformaion.helpDetails];
    
    // button title
    [self.sendMessageButton setTitle:self.contactInformaion.sendMessage forState:UIControlStateNormal];
}

#pragma mark - Actions

// selecting type of enquiry

- (IBAction)typeOfInquirySelecting:(id)sender {
    [self dismissKeyboard];
    [self.pickerParentView setHidden:FALSE];
}

// send messsage

- (IBAction)sendMessage:(id)sender {
    if (![self isFormCompleted])
        return;
    NSString *inquiry = [[BTRViewUtility inquiryTypes]valueForKey:self.typeOfInquiryTF.text];
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:inquiry,@"inquiry_type",
                           self.firstNameTF.text,@"first_name",
                           self.lastNameTF.text,@"last_name",
                           self.orderTF.text,@"order_id",
                           self.itemNumberTF.text,@"item_id",
                           self.descriptionTV.text,@"message",
                           self.emailTF.text,@"email"
                           , nil];
    NSString* url = [NSString stringWithFormat:@"%@", [BTRContactFetcher URLForSendMessage]];
    [BTRLoader showLoaderInView:self.view];
    [BTRConnectionHelper postDataToURL:url withParameters:param setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [BTRLoader hideLoaderFromView:self.view];
        if (response && [[response valueForKey:@"success"]boolValue])
            [[[UIAlertView alloc]initWithTitle:@"Thanks" message:@"You message has been sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        else if (response)
            [[[UIAlertView alloc]initWithTitle:@"Error" message:[response valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    } faild:^(NSError *error) {
        [BTRLoader hideLoaderFromView:self.view];
    }];
}

- (BOOL)isFormCompleted {
    if (self.typeOfInquiryTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Inquiry" message:@"Please select your inquiry type" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        return NO;
    }
    if (self.firstNameTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"First Name" message:@"Please fill your first name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        [self.firstNameTF becomeFirstResponder];
        return NO;
    }
    if (self.lastNameTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Last Name" message:@"Please fill your last name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        [self.lastNameTF becomeFirstResponder];
        return NO;
    }
    if (self.emailTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Email" message:@"Please fill your email address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        [self.emailTF becomeFirstResponder];
        return NO;
    }
    if (self.descriptionTV.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please fill Message" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        [self.descriptionTV becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)faqTapped:(id)sender {
    if (self.faqArray == nil) {
        [BTRLoader showLoaderInView:self.view];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchFAQWithSuccess:^(id responseObject) {
            BTRHelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRHelpViewController"];
            [help setFaqArray:self.faqArray];
            [self.navigationController pushViewController:help animated:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
            });
    }else {
        BTRHelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRHelpViewController"];
        [help setFaqArray:self.faqArray];
        [self.navigationController pushViewController:help animated:NO];
    }
}

#pragma mark - keyboard

- (IBAction)viewTapped:(id)sender {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - PickerView Delegate & DataSource

// PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    [self.typeOfInquiryTF setText:[[self inquiryArray] objectAtIndex:row]];
    [self.pickerParentView setHidden:TRUE];
}

// PickerView DataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  [[self inquiryArray] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat sectionWidth = 300;
    return sectionWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.adjustsFontSizeToFitWidth = YES;
        tView.textAlignment = NSTextAlignmentCenter;
    }
    tView.text = [[self inquiryArray] objectAtIndex:row];
    return tView;
}

// getting FAQ

- (void)fetchFAQWithSuccess:(void (^)(id  responseObject)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRFAQFetcher URLforFAQ]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            self.faqArray = [FAQ arrayOfFAQWithAppServerInfo:response];
            success(self.faqArray);
        }
    } faild:^(NSError *error) {
        failure(nil, error);
    }];
}

#pragma mark back

- (IBAction)backbuttonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
