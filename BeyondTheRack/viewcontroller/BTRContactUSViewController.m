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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    
    
    
}

- (IBAction)faqTapped:(id)sender {
    if (self.faqArray == nil) {
        [self fetchFAQWithSuccess:^(id responseObject) {
            [self performSegueWithIdentifier:@"BTRFAQSegueIdentifier" sender:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else
        [self performSegueWithIdentifier:@"BTRFAQSegueIdentifier" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRFAQSegueIdentifier"]) {
        BTRHelpViewController* vc = [segue destinationViewController];
        vc.faqArray = self.faqArray;
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
    }
    tView.text = [[self inquiryArray] objectAtIndex:row];
    return tView;
}


// getting FAQ

- (void)fetchFAQWithSuccess:(void (^)(id  responseObject)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];

    [manager GET:[NSString stringWithFormat:@"%@", [BTRFAQFetcher URLforFAQ]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {

         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                               options:0
                                                                                 error:NULL];
         if (entitiesPropertyList) {
             self.faqArray = [FAQ arrayOfFAQWithAppServerInfo:entitiesPropertyList];
             success(self.faqArray);
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

         failure(operation, error);

     }];

}


@end
