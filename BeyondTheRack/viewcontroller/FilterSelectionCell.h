//
//  FilterSelectionCell.h
//  SampleRefine
//
//  Created by Mahesh_iOS on 07/01/16.
//  Copyright © 2016 Mall140. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSelectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property BOOL isMultipleAvailable;

@end
