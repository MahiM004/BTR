//
//  BTRCheckoutViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRPopUpVC.h"
#import "Order+AppServer.h"
#import "BTRMasterPassViewController.h"
#import "CTCheckbox.h"
#import "CardIO.h"
#import "ApplePayManager.h"
#import <FRDLivelyButton/FRDLivelyButton.h>
#import "DownPicker.h"
#import <IQKeyboardManager.h>
#import <IQKeyboardReturnKeyHandler.h>
#import <IQUIView+IQKeyboardToolbar.h>
#import <IQUIViewController+Additions.h>

typedef enum {
    creditCard,
    paypal,
    masterPass
} paymentType;


typedef enum  PopUPType{
    PopUPTypePayment,
    PopUPTypeExpiryYear,
    PopUPTypeExpiryMonth,
    PopUPTypeState,
    PopUPTypeProvince,
    PopUPTypeBillingCountry,
    PopUPTypeShippingCountry
}PopUPType;

@interface BTRCheckoutViewController : UIViewController <UIPickerViewDelegate,UITextFieldDelegate,MasterPassInfoDelegate,UIAlertViewDelegate,CardIOPaymentViewControllerDelegate,ApplePayDelegate,PopUPDelegate,DropDownPickerDelegate>

@property (readwrite) PopUPType popType;

@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) NSDictionary *masterCallBackInfo;
@property (strong, nonatomic) NSDictionary *paypalCallBackInfo;


@property (weak, nonatomic) IBOutlet UIButton *chatWithRepButton;
@property (weak, nonatomic) IBOutlet UIButton *visaCheckoutButton;
@property (weak, nonatomic) IBOutlet UIButton *masterPassButton;


// VIP
@property (weak, nonatomic) IBOutlet UIControl *vipOptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipOptionViewHeight;

// Pick UP Free Montreal
@property (weak, nonatomic) IBOutlet UIView *freeMontrealView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeMontrealViewHeightConstraint;

/**
 
 Views
 
 */

@property (weak, nonatomic) IBOutlet UIView *applePayButtonView;
@property (weak, nonatomic) UIButton *applePayButton;

@property (weak, nonatomic) IBOutlet UIView *parentViewforScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIControl *childViewforScrollView;

@property (weak, nonatomic) IBOutlet UIControl *fastPaymentView;
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

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

/**
 
 Heights of Views
 
 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *haveAGiftViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fastPaymentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditCardDetailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paypalDetailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *billingAddressHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardPaymentTipHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sampleGiftViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fillFormLabelViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shippingViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftCardViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rememberCardInfoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sameAsShippingHeight;


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
@property (weak, nonatomic) IBOutlet UILabel *shippingPostalCodeLB;
@property (weak, nonatomic) IBOutlet UILabel *shippingProvinceLB;


/**
 
 Billing Address
 
 */

@property (weak, nonatomic) IBOutlet UIImageView *paymentMethodImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardPaymentTipLabel;

@property (weak, nonatomic) IBOutlet CTCheckbox *sameAddressCheckbox;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1BillingTF;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2BillingTF;
@property (weak, nonatomic) IBOutlet UITextField *countryBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *provinceBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *cityBillingTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneBillingTF;
@property (weak, nonatomic) IBOutlet UIButton *billingCountryButton;
@property (weak, nonatomic) IBOutlet UIButton *billingStateButton;
@property (weak, nonatomic) IBOutlet UILabel *billingProvinceLB;
@property (weak, nonatomic) IBOutlet UILabel *billingPostalCodeLB;

@property (weak, nonatomic) IBOutlet UIView *giftCardInfoView;
@property (weak, nonatomic) IBOutlet CTCheckbox *orderIsGiftCheckbox;
@property (weak, nonatomic) IBOutlet UITextField *giftMessageTF;
@property (weak, nonatomic) IBOutlet UIButton *learnAboutGiftsButton;


/**
 
 Payment Details
 
 */

@property (weak, nonatomic) IBOutlet UITextField *paypalEmailTF;
@property (weak, nonatomic) IBOutlet UILabel *sendmeToPaypalLabel;
@property (weak, nonatomic) IBOutlet CTCheckbox *sendmeToPaypalCheckbox;

@property (weak, nonatomic) IBOutlet UIButton *paymentMethodButton;
@property (weak, nonatomic) IBOutlet UITextField *paymentMethodTF;
@property (weak, nonatomic) IBOutlet UITextField *expiryMonthPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *expiryYearPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *nameOnCardPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberPaymentTF;
@property (weak, nonatomic) IBOutlet UITextField *cardVerificationPaymentTF;
@property (weak, nonatomic) IBOutlet UILabel *cardVerificationPaymentLB;
@property (weak, nonatomic) IBOutlet CTCheckbox *remeberCardInfoCheckbox;
@property (weak, nonatomic) IBOutlet UITextField *giftCardCodePaymentTF;
@property (weak, nonatomic) IBOutlet CTCheckbox *changePaymentMethodCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

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
@property (weak, nonatomic) IBOutlet UILabel *totalDueLabel;

@property (weak, nonatomic) IBOutlet UIView *sampleGiftView;
@property (weak, nonatomic) IBOutlet UIControl *paymentTypeView;
@property (weak, nonatomic) IBOutlet UIControl *paymentCreditView;

// Have a gift card
@property (weak, nonatomic) IBOutlet UIView *haveAgiftInnerView;


//Havea gife Button
@property (weak, nonatomic) IBOutlet FRDLivelyButton * expandHaveCode;


// For iPad
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payListWithSampleOut;

@property (nonatomic) DownPicker *paymentPicker;
@property (nonatomic) DownPicker *expiryMonthPicker;
@property (nonatomic) DownPicker *expiryYearPicker;
@property (nonatomic) DownPicker *billingCountryPicker;
@property (nonatomic) DownPicker *shippingCountryPicker;


//VIP PickUP Label
@property (weak, nonatomic) IBOutlet UILabel *vipTitleText;

@end






















