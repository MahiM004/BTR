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
  
    self.categoryNames = [[NSMutableArray alloc] initWithObjects:
                          @"Women",
                          @"Men",
                          @"Home",
                          @"Outlet",
                          @"All Events",
                          @"Kids",
                          @"Curvey Closet",
                          @"Holiday Sale",
                          nil];

    self.categoryItemPics = [[NSMutableArray alloc] initWithObjects:
                             @"women",
                             @"men",
                             @"home",
                             @"specials",
                             @"editor",
                             @"kids",
                             @"future",
                             @"xmasspecials",
                             nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self categoryNames] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainSceneCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[MainSceneCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCellIdentifier"];
    }
    
    
    int picNumber = (int)(indexPath.row);
    
    cell.categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.categoryItemPics objectAtIndex:picNumber]] ];
    cell.categoryLabel.text = [[self categoryNames] objectAtIndex:picNumber];
    
    return cell;
}


# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"categorySelectedSegue"])
    {
        EventsViewController *vc = [segue destinationViewController];
        
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [vc setCategoryNames:[self categoryNames]];
        [vc setCategoryCount:[self.categoryNames count]];
        [vc setSelectedCategoryIndex:[indexPath row]];
        
    }
    
}

- (IBAction)tappedShoppingBag:(id)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}






@end
