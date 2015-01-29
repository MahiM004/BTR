//
//  BTRSearchFilterView.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-28.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchFilterView.h"
#import "UIImage+ImageEffects.h"

@implementation BTRSearchFilterView

@synthesize backgroundImage;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 70)];//initWithFrame:[[UIScreen mainScreen] bounds]];
    headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];// blackColor];
    headerView.opaque = NO;
    
    
    headerView.backgroundColor = [UIColor clearColor];
    UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:headerView.frame];
    bgToolbar.barStyle = UIBarStyleDefault;
    [headerView.superview insertSubview:bgToolbar belowSubview:headerView];
    
    
    
    
    
    
    UIImageView *backgroundImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    //backgroundImageView.image = [self.backgroundImage applyBTRSearchFilterLightEffect];
    backgroundImageView.image = [self.backgroundImage applyDarkEffect];
    [self addSubview:backgroundImageView];

    
    
    
    
    
    
    
    UILabel *pageTitleLabel = [[UILabel alloc] init];
    pageTitleLabel.text = @"Refine Results";
    pageTitleLabel.backgroundColor = [UIColor clearColor];
    pageTitleLabel.opaque = NO;
    [pageTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [pageTitleLabel setCenter:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [pageTitleLabel setFrame:CGRectMake(110, 25, 200, 34)];
    [pageTitleLabel setTextColor:[UIColor whiteColor]];
    
    
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.opaque = NO;
    [cancelButton setCenter:CGPointMake(self.frame.size.width,self.frame.size.height)];
    [cancelButton setTitleColor:[UIColor colorWithWhite:255.0/255.0 alpha:0.649999976158142] forState:UIControlStateNormal];
    [cancelButton setTintColor:[UIColor blueColor]];
    [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [cancelButton setFrame:CGRectMake(0, 25, 100, 34)];
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [cancelButton addTarget:self
                     action:@selector(cancelTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    [headerView addSubview:pageTitleLabel];
    [headerView addSubview:cancelButton];

    [self addSubview:headerView];
    
}

- (IBAction)cancelTapped:(id)sender {
    
    [self removeFromSuperview];
}


@end
