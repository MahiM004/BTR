//
//  BTRSizeSelector.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-11.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSizeSelector.h"

#import "BTRSelectSizeVC.h"

static const float kButtonWidth = 30.0f;



@implementation BTRSizeSelector



#pragma mark initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _value = @"Z";
     _buttonWidth = kButtonWidth;
    
    self.clipsToBounds = YES;
    [self setBorderWidth:1.0f];
    [self setCornerRadius:3.0];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.layer.borderWidth = 1.0f;
    //[self addSubview:self.countLabel];
    
    self.selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectionButton setTitle:@"-" forState:UIControlStateNormal];
    [self.selectionButton addTarget:self action:@selector(selectSizeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:self.selectionButton];
    
    UIColor *defaultColor = [UIColor blackColor];//[UIColor colorWithRed:(79/255.0) green:(161/255.0) blue:(210/255.0) alpha:1.0];
    [self setBorderColor:defaultColor];
    [self setLabelTextColor:defaultColor];
    [self setButtonTextColor:defaultColor forState:UIControlStateNormal];
    
    [self setLabelFont:[UIFont fontWithName:@"Avernir-Roman" size:10.0f]];
    [self setButtonFont:[UIFont fontWithName:@"Avenir-Black" size:12.0f]];
}




#pragma mark - render


- (void)layoutSubviews
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.countLabel.frame = CGRectMake(self.buttonWidth, 0, width - (self.buttonWidth * 2), height);
    self.selectionButton.frame = CGRectMake(0, 0, self.buttonWidth, height);
}

- (void)setup
{
    if (self.valueChangedCallback)
    {
        self.valueChangedCallback(self, self.value);
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        // if CGSizeZero, return ideal size
        CGSize labelSize = [self.countLabel sizeThatFits:size];
        return CGSizeMake(labelSize.width + (self.buttonWidth * 2), labelSize.height);
    }
    return size;
}




#pragma mark view customization


- (void)setBorderColor:(UIColor *)color {
    
    self.layer.borderColor = color.CGColor;
    self.countLabel.layer.borderColor = color.CGColor;
}

- (void)setBorderWidth:(CGFloat)width {
    
    self.layer.borderWidth = width;
}

- (void)setCornerRadius:(CGFloat)radius {
    
    self.layer.cornerRadius = radius;
}

- (void)setLabelTextColor:(UIColor *)color {
    
    self.countLabel.textColor = color;
}

- (void)setLabelFont:(UIFont *)font {
    
    self.countLabel.font = font;
}

- (void)setButtonTextColor:(UIColor *)color forState:(UIControlState)state {
    
    [self.selectionButton setTitleColor:color forState:state];
}

- (void)setButtonFont:(UIFont *)font {
    
    self.selectionButton.titleLabel.font = font;
}



#pragma mark setter

- (void)setValue:(NSString *)value
{
    _value = value;
    
    if (self.valueChangedCallback)
    {
        self.valueChangedCallback(self, _value);
    }
}



#pragma mark event handler

- (void)selectSizeButtonTapped:(id)sender
{
    if (self.valueChangedCallback)
    {
        self.valueChangedCallback(self, self.value);
    }
    
}


#pragma mark - BTRSelectSizeVC Delegate



- (void)selectSizeWillDisappearWithSelectionIndex:(NSUInteger)selectedIndex {
  /*
    
    */
    
}



@end













