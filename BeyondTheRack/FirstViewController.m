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
@property (weak, nonatomic) IBOutlet UINavigationItem *bar;

@end

@implementation FirstViewController


- (void)viewWillAppear:(BOOL)animated {
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(320-102/2,0,102,44)];
    iv.image=[UIImage imageNamed:@"neulogocentered.png"];
    self.navigationItem.titleView=iv;
    
}

-(void)viewDidLayoutSubviews {
    CGRect frame=self.navigationItem.titleView.frame;
    frame.size.width=102;
    frame.size.height=44;
    self.navigationItem.titleView.frame=frame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    
    
    //UINavigationItem *item = self.bar;
    //item.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neulogo.png"]];
    
    // Do any additional setup after loading the view, typically from a nib.
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
    

    
    cell.mockupImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",indexPath.row + 1] ];
    
    return cell;
}



@end
