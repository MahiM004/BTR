//
//  BTRProductShowcaseVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRSelectSizeVC.h"


@interface BTRProductShowcaseVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,BTRSelectSizeVC>

@property (strong, nonatomic) NSString *eventSku;
@property (strong, nonatomic) NSString *eventTitleString;

@end
