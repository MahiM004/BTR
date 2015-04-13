//
//  BTRBagTableViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRBagTableViewCell.h"

@interface BTRBagTableViewCell ()


@end


@implementation BTRBagTableViewCell


- (void)awakeFromNib {

    self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    
    [self.stepper setup];
    [self.stepperView addSubview:self.stepper];
        
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateTime)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}




-(void)updateTime
{
 
    NSInteger ti = ((NSInteger)[self.dueDateTime timeIntervalSinceNow]);
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;

    if (seconds > 0 || minutes > 0) {

        self.remainingTimeLabel.text = [NSString stringWithFormat:@"Remaining time: %02i:%02i", minutes, seconds];
    
    } else if (seconds <= 0 && minutes <= 0) {
        
        self.remainingTimeLabel.text = [NSString stringWithFormat:@"Time OUT"];
    }
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}






@end
