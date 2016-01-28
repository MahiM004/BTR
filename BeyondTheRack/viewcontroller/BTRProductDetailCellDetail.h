//
//  BTRProductDetailCellDetail.h
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 04/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRProductDetailCellDetail : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeight;

@property (weak, nonatomic) IBOutlet UILabel *lblDesc2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightDesc2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginDesc2;

@property (weak, nonatomic) IBOutlet UILabel *lblGenNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightGenNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginGenNote;

@property (weak, nonatomic) IBOutlet UILabel *lblSpclNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSpclNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginSpclNote;

@property (weak, nonatomic) IBOutlet UILabel *lblTimeNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTimeNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginTimeNote;


@end
