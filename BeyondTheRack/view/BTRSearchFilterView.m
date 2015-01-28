//
//  BTRSearchFilterView.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-28.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchFilterView.h"

@implementation BTRSearchFilterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    
    UILabel *pageTitleLabel = [[UILabel alloc] init];
    pageTitleLabel.text = @"Filter Results";
    pageTitleLabel.backgroundColor = [UIColor clearColor];
    pageTitleLabel.opaque = NO;
    [pageTitleLabel sizeToFit];
    [pageTitleLabel setCenter:CGPointMake(self.frame.size.width,
                                          self.frame.size.height)];
    [pageTitleLabel setFrame:CGRectMake(110, 25, 200, 34)];
    [pageTitleLabel setTextColor:[UIColor whiteColor]];
    
    
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.opaque = NO;
    [cancelButton sizeToFit];
    [cancelButton setCenter:CGPointMake(self.frame.size.width,
                                        self.frame.size.height)];
    
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTintColor:[UIColor blueColor]];
    
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(0, 25, 100, 34)];
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cancelButton addTarget:self
                     action:@selector(cancelTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:pageTitleLabel];
    [self addSubview:cancelButton];
    
}

- (IBAction)cancelTapped:(id)sender {
    
    NSLog(@"cancel tapped");
    [self removeFromSuperview];
}


@end
