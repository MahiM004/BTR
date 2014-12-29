//
//  MainViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-15.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "MainViewController.h"
#import "EventsViewController.h"
#import "MainSceneCategoryCell.h"
#import "ShoppingBagViewController.h"

@interface MainViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation MainViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
*/
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
    
    MainSceneCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[MainSceneCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCellIdentifier"];
    }
    
    NSArray  * categoryItems = [NSArray arrayWithObjects:@"women", @"men", @"home", @"specials", @"editor", @"kids", @"future", @"xmasspecials",nil];

    
    int picNumber = (int)(indexPath.row);
    
    cell.mockupImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[categoryItems objectAtIndex:picNumber]] ];
    
    return cell;
}


# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"categorySelectedSegue"])
    {
        EventsViewController *vc = [segue destinationViewController];
        
        NSArray  * categoryItems = [NSArray arrayWithObjects:@"The Holiday Issue", @"Editor's Picks", @"Furniture", @"Women", @"Kids", @"Home", @"State Concepts", @"Winter Sale",nil];

        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [vc setCatText:[categoryItems objectAtIndex:[indexPath row]]];
        [vc setCategoryCount:[categoryItems count]];
        [vc setSelectedCategoryIndex:[indexPath row]];
        
    }
    
}

- (IBAction)tappedShoppingBag:(id)sender {
    
    ShoppingBagViewController *bagVC = [[ShoppingBagViewController alloc] initWithNibName:@"ShoppingBagViewController" bundle:nil];
    bagVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:bagVC animated:YES completion:NULL];

}

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
