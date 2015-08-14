//
//  BTRConfirmationViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRConfirmationViewController.h"
#import "Item.h"

@interface BTRConfirmationViewController ()

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
    NSString *thanksString = [NSString stringWithFormat:@"%@,THANK YOU FOR YOUR ORDER NO. %@",self.order.shippingRecipientName,self.order.orderId];
    NSRange range = [thanksString rangeOfString:self.self.order.shippingRecipientName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:thanksString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.thanksLabel.attributedText = attributedString;
    
    if (self.transactionID) {
        // adding transactionID
        NSString *string = [NSString stringWithFormat:@"we've billed your order to the transaction number : %@ with following address :",self.transactionID];
        NSRange range = [string rangeOfString:self.transactionID];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        self.billingLabel.attributedText = attributedString;
        
    } else {
        // adding last 4 digits of card
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:self.billingLabel.attributedText];
        [[text mutableString] replaceOccurrencesOfString:@"1111" withString:[self.order.cardNumber substringWithRange:NSMakeRange(self.order.cardNumber.length - 4, 4)] options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.string.length)];
        self.billingLabel.attributedText = text;
    }
    
    //address
    NSString* shippingAddressString = [NSString stringWithFormat:@"%@%@\n%@\n%@\n",self.order.shippingAddressLine1,self.order.shippingAddressLine2,self.order.shippingCity,self.order.shippingCountry];
    self.shippingAddress.text = shippingAddressString;
    
    NSString* billingAddressString = [NSString stringWithFormat:@"%@%@\n%@\n%@\n",self.order.billingAddressLine1,self.order.billingAddressLine2,self.order.billingCity,self.order.billingCountry];
    self.billingAddress.text = billingAddressString;
    
    // order Items
    CGPoint begingingpoint = self.orderView.bounds.origin;
    CGSize size = self.orderView.bounds.size;
    CGFloat space = 140.0;
    for (int i = 0; i < self.order.items.count; i++) {
        Item* item = [self.order.items objectAtIndex:i];
        UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(begingingpoint.x, begingingpoint.y + (i * space), size.width, space)];
        newLabel.numberOfLines = -1;
        newLabel.font = [UIFont systemFontOfSize:11];
        newLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",item.shortItemDescription,item.attributeList,item.brand];
        [self.orderView addSubview:newLabel];
    }
    self.itemsHeight.constant = self.order.items.count * 140;
    if (self.order.items.count > 1)
        self.viewHeight.constant = self.viewHeight.constant + (self.order.items.count - 1) * 140;
    
    // Prices
    self.bagTotalLabel.text = [NSString stringWithFormat:@"%@",self.order.bagTotalPrice];
    self.qstLabel.text = [NSString stringWithFormat:@"%@",self.order.qstTax];
    self.gstLabel.text = [NSString stringWithFormat:@"%@",self.order.gstTax];
    self.orderTotal.text = [NSString stringWithFormat:@"%@",self.order.orderTotalPrice];
    self.shippingPriceLabel.text = [NSString stringWithFormat:@"%@",self.order.shippingPrice];
    
    
}

- (IBAction)viewTapped:(id)sender {
    
}



@end
