//
//  BTRConfirmationViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//
#import "BTRConfirmationViewController.h"
#import "BTRAttributeHandler.h"
#import "Item.h"

@interface BTRConfirmationViewController ()

// ThanksLabel
@property (weak, nonatomic) IBOutlet UILabel *thanksLabel;

// Billing Information
@property (weak, nonatomic) IBOutlet UILabel *billingLabel;

// Addresses Outlet
@property (weak, nonatomic) IBOutlet UILabel *billingAddress;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddress;

// items of order
@property (weak, nonatomic) IBOutlet UIView *orderView;

// receipt
@property (weak, nonatomic) IBOutlet UILabel *bagTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *taxLabel1;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel2;

@property (weak, nonatomic) IBOutlet UILabel *taxValue1;
@property (weak, nonatomic) IBOutlet UILabel *taxValue2;

@property (weak, nonatomic) IBOutlet UILabel *totalOrder;
@property (weak, nonatomic) IBOutlet UILabel *totalOrderValue;


// Heights
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label3HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiptViewHeight;

// scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


// Credit Promos
@property (weak, nonatomic) IBOutlet UILabel *lblCreditPromoPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCreditPromo;
@property (weak, nonatomic) IBOutlet UIView *creditView;
// Account Credited
@property (weak, nonatomic) IBOutlet UILabel *lblAccountCredited;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAccountCredit;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@end

@implementation BTRConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BTRViewUtility isIPAD]) {
        [_label3HeightConstraint setConstant:30];
        [_noteLabelHeight setConstant:70];
        _viewHeight.constant -= 100;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    //changing thanks label
    NSString *thanksString = [NSString stringWithFormat:@"%@,THANK YOU FOR YOUR ORDER NO. %@",self.info.shippingAddress.name,self.info.orderID];
    NSRange range = [thanksString rangeOfString:self.info.shippingAddress.name];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:thanksString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    self.thanksLabel.attributedText = attributedString;
    
    NSMutableAttributedString *billingString;
    if ([self.info.paymentMethod isEqualToString:@"credit"]) {
        billingString = [[NSMutableAttributedString alloc]initWithAttributedString:self.billingLabel.attributedText];
        [[billingString mutableString] replaceOccurrencesOfString:@"1111" withString:self.info.billingCardLastdigits options:NSCaseInsensitiveSearch range:NSMakeRange(0, billingString.string.length)];
    } else if ([self.info.paymentMethod isEqualToString:@"paypal"]) {
        NSString *text = [NSString stringWithFormat:@"We've billed your order to your PayPal account – %@, the transaction id is %@ with the following shipping address:",self.info.billingAddress.name,self.info.confirmationNumber];
        NSRange range = [text rangeOfString:self.info.billingAddress.name];
        billingString = [[NSMutableAttributedString alloc]initWithString:text];
        [billingString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    }
    
    
    NSNumber * creditPromoTxt = [NSNumber numberWithInt:[self.info.creditPromo intValue]];
    NSNumber * accountCreditedTxt = [NSNumber numberWithInt:[self.info.accountCredit intValue]];
    
    //You can Test With below
//    creditPromoTxt = @5;
//    accountCreditedTxt = @6;
    if ([creditPromoTxt isEqualToNumber:@0]) {
        [self.heightCreditPromo setConstant:0];
        self.receiptViewHeight.constant -= 35;
        self.viewHeight.constant -= 35;
        self.creditView.hidden = YES;
    } else {
        self.lblCreditPromoPrice.text = [NSString stringWithFormat:@"($%.2f)",[self.info.creditPromo floatValue]];
    }
    
    if ([accountCreditedTxt isEqualToNumber:@0]) {
        [self.heightAccountCredit setConstant:0];
        self.receiptViewHeight.constant -= 35;
        self.viewHeight.constant -= 35;
        self.accountView.hidden = YES;
    } else {
        self.lblAccountCredited.text = [NSString stringWithFormat:@"($%.2f)",[self.info.accountCredit floatValue]];
    }
    
    
    self.billingLabel.attributedText = billingString;
    //address
    NSString* shippingAddressString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@, %@\n%@\n%@",self.info.shippingAddress.name,self.info.shippingAddress.addressLine1,self.info.shippingAddress.addressLine2,self.info.shippingAddress.city,self.info.shippingAddress.province,self.info.shippingAddress.country,self.info.shippingAddress.postalCode];
    self.shippingAddress.text = shippingAddressString;
    
    NSString* billingAddressString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@, %@\n%@\n%@",self.info.shippingAddress.name,self.info.billingAddress.addressLine1,self.info.billingAddress.addressLine2,self.info.billingAddress.city,self.info.billingAddress.province,self.info.billingAddress.country,self.info.billingAddress.postalCode];
    self.billingAddress.text = billingAddressString;
    
    // order Items
    CGPoint begingingpoint = self.orderView.bounds.origin;
    CGSize size = self.orderView.bounds.size;
    CGFloat space = 140.0;
    for (int i = 0; i < self.info.items.count; i++) {
        Item* item = [self.info.items objectAtIndex:i];
        UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(begingingpoint.x, begingingpoint.y + (i * space), size.width, space)];
        newLabel.numberOfLines = -1;
        newLabel.font = [UIFont systemFontOfSize:13];
        newLabel.text = [NSString stringWithFormat:@"%@\nBrand : %@\nSize: %@\nPrice:$%.2f\nItem code : %@",item.shortItemDescription,item.brand,item.variant,[item.salePrice floatValue],item.sku];
        [self.orderView addSubview:newLabel];
    }
    self.itemsHeight.constant = self.info.items.count * 140;
    if (self.info.items.count > 1)
        self.viewHeight.constant = self.viewHeight.constant + (self.info.items.count - 1) * 140;
    
    // Prices
    self.bagTotalLabel.text = [NSString stringWithFormat:@"$%.2f",[self.info.bagTotal floatValue]];
    self.subTotalLabel.text = [NSString stringWithFormat:@"$%.2f",[self.info.orderSubtotal floatValue]];
    self.totalOrder.text = [NSString stringWithFormat:@"TOTAL %@ :",self.info.orderCurrency];
    self.totalOrderValue.text = [NSString stringWithFormat:@"$%.2f",[self.info.totalOrderValue floatValue]];
    self.shippingPriceLabel.text = [NSString stringWithFormat:@"$%.2f",[self.info.totalShipping floatValue]];
    
    if (self.info.totalTax1.doubleValue == 0) {
        self.taxLabel1.hidden = YES;
        self.taxValue1.hidden = YES;
    } else {
        self.taxValue1.text = [NSString stringWithFormat:@"$%.2f",[self.info.totalTax1 floatValue]];
        self.taxLabel1.text = self.info.labelTax1;
    }
    if (self.info.totalTax2.doubleValue == 0) {
        self.taxLabel2.hidden = YES;
        self.taxValue2.hidden = YES;
    } else {
        self.taxValue2.text = [NSString stringWithFormat:@"$%.2f",[self.info.totalTax2 floatValue]];
        self.taxLabel2.text = self.info.labelTax2;
    }
    
}

- (IBAction)viewTapped:(id)sender {
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
    sharedShoppingBag.bagCount = 0;
}

- (IBAction)continueTapped:(id)sender {
    BTRAppDelegate *appdel = (BTRAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdel backToInitialViewControllerFrom:self];
}


@end
