//
//  BTRRefineResultsViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "UIImage+ImageEffects.h"
#import <UIKit/UIKit.h>

@protocol BTRRefineResultsViewController;


@interface BTRRefineResultsViewController : UIViewController

@property (nonatomic, weak) id<BTRRefineResultsViewController> delegate;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end



@protocol BTRRefineResultsViewController <NSObject>

@optional

- (void)refineSceneWillDisappearWithResponseDictionary:(NSDictionary *)responseDictionary withJSonResponse:(NSString *)jSonString;

@end









