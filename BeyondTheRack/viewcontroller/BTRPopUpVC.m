//
//  BTRPopUpVC.m
//  BeyondTheRack
//
//  Created by Mahesh_iOS on 30/11/15.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRPopUpVC.h"
#import "BTRPopUPVCCell.h"
@interface BTRPopUpVC ()

@end

@implementation BTRPopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
#pragma mark - UIPickerView method implementation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _getArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTRPopUPVCCell * cell = [tableView dequeueReusableCellWithIdentifier:@"popCell"];
    if (!cell) {
        cell = [[BTRPopUPVCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popCell"];
    }
    cell.popTitle.text = _getArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate userDataChangedWith:indexPath];
}
@end
