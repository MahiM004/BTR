//
//  BTRLoadingButton.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-28.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRLoadingButton.h"

@interface BTRLoadingButton ()
@property (strong,nonatomic) UIActivityIndicatorView *activity;
@property (strong, nonatomic) NSString *currentText;
@property CGRect currentBounds;
@end

@implementation BTRLoadingButton

- (void)showLoading {
    self.clipsToBounds = YES;
    [self addActivityIndicator];
    [self setCurrentData];
    [self disableButton];
    [self deShapeAnimation];
    [self setIsLoading:YES];
    [self setNeedsDisplay];
}

- (void)addActivityIndicator {
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self setFrameForActivity];
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    [self.activity setCenter:self.center];
    [self.superview addSubview:self.activity];
}

- (void)setCurrentData {
    [self setCurrentText:self.currentTitle];
    [self setCurrentBounds:self.bounds];
}

- (void)disableButton {
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setEnabled:NO];
}

- (void)deShapeAnimation {
    CABasicAnimation *sizing = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizing.duration= 0.2;
    sizing.toValue= [NSValue valueWithCGRect:CGRectMake(self.layer.bounds.origin.x, self.layer.bounds.origin.y, self.layer.bounds.size.height, self.layer.bounds.size.height)];
    sizing.removedOnCompletion = FALSE;
    sizing.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:sizing forKey:@"sizing"];

    CABasicAnimation *shape = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    shape.beginTime = CACurrentMediaTime() + 0.3;
    shape.duration = 0.3;
    shape.toValue= @(self.layer.bounds.size.height / 2);
    shape.removedOnCompletion = FALSE;
    shape.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:shape forKey:@"shape"];
}

- (void)reShapeAnimation {
    CABasicAnimation *shape = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    shape.duration = 0.3;
    shape.toValue= @0;
    shape.removedOnCompletion = FALSE;
    shape.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:shape forKey:@"de-shape"];
    
    CABasicAnimation *sizing = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizing.beginTime = CACurrentMediaTime() + 0.3;
    sizing.duration= 0.2;
    sizing.toValue= [NSValue valueWithCGRect:self.currentBounds];
    sizing.removedOnCompletion = FALSE;
    sizing.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:sizing forKey:@"de-sizing"];
}

- (void)hideLoading {
    [self setIsLoading:NO];
    [self reShapeAnimation];
    [self reEnable];
}

- (void)reEnable {
    [self.activity removeFromSuperview];
    [self setTitle:self.currentText forState:UIControlStateNormal];
    [self setEnabled:YES];
}

- (void)setFrameForActivity {
    [self.activity setCenter:self.center];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setFrameForActivity];
}
@end
