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
@property (weak, nonatomic) IBOutlet UILabel *shippingPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *gstTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *qstTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *gstLabel;
@property (weak, nonatomic) IBOutlet UILabel *qstLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotal;

// Heights
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemsHeight;

// scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BTRConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    //changing thanks label
    NSString *thanksString = [NSString stringWithFormat:@"%@,THANK YOU FOR YOUR ORDER NO. %@",self.info.billingName,self.info.orderID];
//    NSRange range = [thanksString rangeOfString:self.info.billingName];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:thanksString];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//    self.thanksLabel.attributedText = attributedString;
    self.thanksLabel.text = thanksString;
    
//    if (self.transactionID) {
//        // adding transactionID
//        NSString *string = [NSString stringWithFormat:@"we've billed your order to the transaction number : %@ with following address :",self.transactionID];
//        NSRange range = [string rangeOfString:self.transactionID];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//        self.billingLabel.attributedText = attributedString;
//        
//    } else {
//        // adding last 4 digits of card
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:self.billingLabel.attributedText];
//        [[text mutableString] replaceOccurrencesOfString:@"1111" withString:[self.order.cardNumber substringWithRange:NSMakeRange(self.order.cardNumber.length - 4, 4)] options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.string.length)];
//        self.billingLabel.attributedText = text;
//    }
    
    //address
    NSString* shippingAddressString = [NSString stringWithFormat:@"%@%@\n%@\n%@\n",self.info.shippingAddress.addressLine1,self.info.shippingAddress.addressLine2,self.info.shippingAddress.city,self.info.shippingAddress.country];
    self.shippingAddress.text = shippingAddressString;
    
    NSString* billingAddressString = [NSString stringWithFormat:@"%@%@\n%@\n%@\n",self.info.billingAddress.addressLine1,self.info.billingAddress.addressLine2,self.info.billingAddress.city,self.info.billingAddress.country];
    self.billingAddress.text = billingAddressString;
    
    // order Items
    CGPoint begingingpoint = self.orderView.bounds.origin;
    CGSize size = self.orderView.bounds.size;
    CGFloat space = 140.0;
    for (int i = 0; i < self.info.items.count; i++) {
        Item* item = [self.info.items objectAtIndex:i];
        UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(begingingpoint.x, begingingpoint.y + (i * space), size.width, space)];
        newLabel.numberOfLines = -1;
        newLabel.font = [UIFont systemFontOfSize:11];
        newLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",item.shortItemDescription,[BTRAttributeHandler attributeDictionaryToString:item.attributeDictionary],item.brand];
        [self.orderView addSubview:newLabel];
    }
    self.itemsHeight.constant = self.info.items.count * 140;
    if (self.info.items.count > 1)
        self.viewHeight.constant = self.viewHeight.constant + (self.info.items.count - 1) * 140;
    
    // Prices
    self.bagTotalLabel.text = [NSString stringWithFormat:@"%@",self.info.bagTotal];
    self.orderTotal.text = [NSString stringWithFormat:@"%@",self.info.totalOrderValue];
    self.shippingPriceLabel.text = [NSString stringWithFormat:@"%@",self.info.totalShipping];
    
    if (self.info.labelTax1 == nil) {
        self.qstLabel.hidden = YES;
        self.qstTextLabel.hidden = YES;
    } else
        self.qstLabel.text = self.info.labelTax1; //[NSString stringWithFormat:@"%.2f",self.order.qstTax.floatValue];
    if (self.info.labelTax2 == nil) {
        self.gstLabel.hidden = YES;
        self.gstTextLabel.hidden = YES;
    } else
        self.gstLabel.text = self.info.labelTax2; //[NSString stringWithFormat:@"%.2f",self.order.gstTax.floatValue];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
