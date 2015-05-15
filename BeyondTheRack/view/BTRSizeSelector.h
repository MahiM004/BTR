//
//  BTRSizeSelector.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-11.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTRSelectSizeVC.h"



@class BTRSizeSelector;
// called when value is changed
typedef void (^BTRSizeSelectorValueChangedCallback)(BTRSizeSelector *sizeSelector, NSString *newValue);

IB_DESIGNABLE
@interface BTRSizeSelector : UIControl
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIButton *selectionButton;

@property (nonatomic, strong) NSString *value; // default: Z
@property (nonatomic) CGFloat buttonWidth; // default: 44.0f


@property (nonatomic, copy) BTRSizeSelectorValueChangedCallback valueChangedCallback;

// call this method after setting value(s) and callback(s)
// This method will call callback
- (void)setup;

// view customization
- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;
- (void)setCornerRadius:(CGFloat)radius;

- (void)setLabelTextColor:(UIColor *)color;
- (void)setLabelFont:(UIFont *)font;

- (void)setButtonTextColor:(UIColor *)color forState:(UIControlState)state;
- (void)setButtonFont:(UIFont *)font;



@end












