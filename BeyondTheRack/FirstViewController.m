//
//  FirstViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-15.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "FirstViewController.h"
#import "mockupTableViewCell.h"


@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    mockupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[mockupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCellIdentifier"];
    }
    
    int picNumber = (int)(indexPath.row) + 1;
    
    cell.mockupImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", picNumber] ];
    
    return cell;
}


# pragma mark - Navigation


- (IBAction)unwindFromShoppingBag:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindFromMyAccount:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
}




@end
