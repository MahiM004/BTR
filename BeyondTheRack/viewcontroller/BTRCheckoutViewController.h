//
//  BTRCheckoutViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Order+AppServer.h"

#import "CTCheckbox.h"

typedef enum {
    creditCard,
    paypal
} paymentType;


@interface BTRCheckoutViewController : UIViewController <UIPickerViewDelegate>

@property (strong, nonatomic) Order *order;

@property (weak, nonatomic) IBOutlet UIButton *chatWithRepButton;
@property (weak, nonatomic) IBOutlet UIButton *visaCheckoutButton;
@property (weak, nonatomic) IBOutlet UIButton *masterPassButton;


/**
 
 Views
 
 */

@property (weak, nonatomic) IBOutlet UIView *parentViewforScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIControl *childViewforScrollView;

@property (weak, nonatomic) IBOutlet UIControl *vipOptionView;
@property (weak, nonatomic) IBOutlet UIControl *shippingDetailsView;
@property (weak, nonatomic) IBOutlet UIControl *billingAddressView;
@property (weak, nonatomic) IBOutlet UIControl *sameAsShippingAddressView;
@property (weak, nonatomic) IBOutlet UIControl *thisIsGiftView;
@property (weak, nonatomic) IBOutlet UIControl *paymentDetailsView;
@property (weak, nonatomic) IBOutlet UIControl *paypalDetailsView;
@property (weak, nonatomic) IBOutlet UIControl *rememberCardInfoView;
@property (weak, nonatomic) IBOutlet UIControl *haveGiftCardView;
@property (weak, nonatomic) IBOutlet UIControl *processOrderView;
@property (weak, nonatomic) IBOutlet UIControl *receiptView;
@property (weak, nonatomic) IBOutlet UIControl *pleaseFillOutTheShippingFormView;
@property (weak, nonatomic) IBOutlet UIControl *changePaymentMethodView;


/**
 
 Heights of Views
 
 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditCardDetailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paypalDetailHeight;


/**
 
 Picker
 
 */

@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;



/**
 
 Shipping Details
 
 */

@property (weak, nonatomic) IBOutlet CTCheckbox *vipOptionCheckbox;
@property (weak, nonatomic) IBOutlet CTCheckbox *pickupOptionCheckbox;

@property (weak, nonatomic) IBOutlet UIControl *pickupView;
@property (weak, nonatomic) IBOutlet UITextField *recipientNameShippingTF;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1ShippingTF;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2ShippingTF;
@property (weak, nonatomic) IBOutlet UITextField *countryShippingTF;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeShippingTF;
@property (weak, nonatomic) IBOutlet UITextField *provinceShippingTF;
@property (weak, nonatomic) IBOutlet UITextField *cityShippingTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneShippingTF;
@property (weak, nonatomic) IBOutlet UIButton *shippingCountryButton;
@property (weak, nonatomic) IBOutlet UIButton *shippingStateButton;

/**
 
 Billing Address
 
 */

@property (weak, nonatomic) IBOutlet CTCheckbox *sameAddressCheckbox;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1BillingTF;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2BillingTF;
@property (weak, nonatomic) IBOutlet UITextField *countryBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *provinceBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *cityBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneBillingTF;

@property (weak, nonatomic) IBOutlet CTCheckbox *orderIsGiftCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *learnAboutGiftsButton;


/**
 
 Payment Details
 
 */


@property (weak, nonatomic) IBOutlet UITextField *paymentMethodTF;
@property (weak, nonatomic) IBOutlet UITextField *expiryMonthPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *expiryYearPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *nameOnCardPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *cardVerificationPaymentTF;
@property (weak, nonatomic) IBOutlet CTCheckbox *remeberCardInfoCheckbox;
@property (weak, nonatomic) IBOutlet UITextField *giftCardCodePaymentTF;
@property (weak, nonatomic) IBOutlet CTCheckbox *changePaymentMethodCheckbox;


/**
 
 Receipt
 
 */

@property (weak, nonatomic) IBOutlet UILabel *youSaveDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *bagTotalDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *gstTaxDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *gstTaxLebl;
@property (weak, nonatomic) IBOutlet UILabel *qstTaxDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *qstTaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftDollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDueDollarLabel;


@end






















