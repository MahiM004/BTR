//
//  BTRPopUpVC.h
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 30/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopUPDelegate

-(void)userDataChangedWith:(NSIndexPath *)index;
@end

@interface BTRPopUpVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property IBOutlet UITableView * tableView;

@property (nonatomic, strong) id<PopUPDelegate> delegate;
@property NSArray * getArray;
@end
