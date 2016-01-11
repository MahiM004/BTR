//
//  FilterTypeCell.m
//  SampleRefine
//
//  Created by Mahesh_iOS on 07/01/16.
//  Copyright © 2016 Mall140. All rights reserved.
//

#import "FilterTypeCell.h"

@implementation FilterTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.sortImage setImage:[UIImage imageNamed:[self imageName:self.lblTitle.text]]];
}

-(NSString*)imageName:(NSString*)title {
    NSString * imageName;
    if ([title isEqualToString:@"SORT ITEMS"]) {
        imageName = @"sortBy";
    } else if ([title isEqualToString:@"CATEGORY"]) {
        imageName = @"Category";
    } else if ([title isEqualToString:@"PRICE"]) {
        imageName = @"priceTag";
    } else if ([title isEqualToString:@"BRAND"]) {
        imageName = @"offer";
    } else if ([title isEqualToString:@"COLOR"]) {
        imageName = @"colorImage";
    } else if ([title isEqualToString:@"SIZE"]) {
        imageName = @"offer";
    }
    
    return imageName;
}
@end
