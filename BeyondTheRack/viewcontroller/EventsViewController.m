//
//  EventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "EventsViewController.h"
#import "EventCollectionViewCell.h"
#import "ShoppingBagViewController.h"

@interface EventsViewController ()

@property (nonatomic,strong) NSMutableArray *collectionData;


@end

@implementation EventsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.categoryHeaderLabel.text = [self catText];
    self.pageControl.numberOfPages = [self categoryCount];
    self.pageControl.currentPage = [self selectedCategoryIndex];
} 



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   
    
    
    self.collectionData = [[NSMutableArray alloc] initWithObjects:
                           [[NSMutableArray alloc] initWithObjects:
                            @"1a.png",
                            @"1b.png",
                            @"1c.png",
                            @"1d.png",
                            @"1e.png",
                            @"1f.png",
                            @"1g.png",
                            @"1h.gpng",
                            @"1i.png",
                            @"1j.png",
                            @"1k.png",
                            @"1l.png",
                            @"1m.png",
                            @"1n.png",
                            @"1o.png",
                            @"1p.png",
                            @"1q.png",
                            @"1r.png",
                            @"1s.png",
                            @"1t.png",
                            @"1u.png",
                            @"1v.png",
                            @"1w.png",
                            nil],
                           [[NSMutableArray alloc] initWithObjects:
                            @"2a.png",
                            @"2b.png",
                            @"2c.png",
                            @"2d.png",
                            @"2e.png",
                            @"2f.png",
                            @"2g.png",
                            @"2h.png",
                            @"2i.png",
                            @"2j.png",
                            @"2k.png",
                            @"2l.png",
                            @"2m.png",
                            @"2n.png",
                            @"2o.png",
                            @"2p.png",
                            @"2q.png",
                            @"2r.png",
                            nil],
    [[NSMutableArray alloc] initWithObjects:
     @"3a.png",
     @"3b.png",
     @"3c.png",
     @"3d.png",
     @"3e.png",
     @"3f.png",
     @"3g.png",
     @"3h.png",
     @"3i.png",
     @"3j.png",
     @"3k.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"4a.png",
     @"4b.png",
     @"4c.png",
     @"4d.png",
     @"4e.png",
     @"4f.png",
     @"4g.png",
     @"4h.png",
     @"4i.png",
     @"4j.png",
     @"4k.png",
     @"4l.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"5a.png",
     @"5b.png",
     @"5c.png",
     @"5d.png",
     @"5e.png",
     @"5f.png",
     @"5g.png",
     @"5h.png",
     @"5i.png",
     @"5j.png",
     @"5k.png",
     @"5l.png",
     @"5m.png",
     @"5n.png",
     @"5o.png",
     @"5p.png",
     @"5q.png",
     @"5r.png",
     @"5s.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"6a.png",
     @"6b.png",
     @"6c.png",
     @"6d.png",
     @"6e.png",
     @"6f.png",
     @"6g.png",
     @"6h.png",
     @"6i.png",
     @"6j.png",
     @"6k.png",
     @"6l.png",
     @"6m.png",
     @"6n.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"7a.png",
     @"7b.png",
     @"7c.png",
     @"7d.png",
     @"7e.png",
     @"7f.png",
     @"7g.png",
     @"7h.png",
     @"7i.png",
     @"7j.png",
     @"7k.png",
     @"7l.png",
     @"7m.png",
     @"7n.png",
     @"7o.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"8a.png",
     @"8b.png",
     @"8c.png",
     @"8d.png",
     @"8e.png",
     @"8f.png",
     @"8g.png",
     @"8h.png",
     @"8i.png",
     @"8j.png",
     @"8k.png",
     @"8l.png",
     @"8m.png",
     @"8n.png",
     @"8o.png",
     @"8p.png",
     @"8q.png",
     @"8r.png",
     @"8s.png",
     nil],
                           nil];
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    //_collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [[self collectionView] setDataSource:self];
    [[self collectionView] setDelegate:self];
    
    
    //[self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    

    
    /*
    - (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath
atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
animated:(BOOL)animated
    */
    
   // [self.collectionView reloadData];
    
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self selectedCategoryIndex] inSection:0];
    // scrolling here does work
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

/*
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.collectionData count];
}
*/


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {

    //return [self categoryCount];;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return [self categoryCount];//[[[self collectionData] objectAtIndex:section] count];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    
    self.pageControl.currentPage = currentIndex;
    self.categoryHeaderLabel.text = [self.categoryNames objectAtIndex:currentIndex];
    
}



// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellIdentifier" forIndexPath:indexPath];
    cell.cellData = [self.collectionData objectAtIndex:indexPath.row];
    
    [cell.tableView reloadData];
    return cell;
}

-(void)tableCellDidSelect:(UITableViewCell *)cell{
    NSLog(@"Tap %@",cell.textLabel.text);
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.label.text = cell.textLabel.text;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)tappedShoppingBag:(id)sender {

    ShoppingBagViewController *bagVC = [[ShoppingBagViewController alloc] initWithNibName:@"ShoppingBagViewController" bundle:nil];
    bagVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:bagVC animated:YES completion:NULL];
}

@end








// -(void)scrollViewDidScroll:(UIScrollView *)scrollView {  }



/*

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

*/



/*
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 
 
 EventCollectionViewCell *newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
 
 //newCell.cellLabel.text = [NSString stringWithFormat:@"Section:%d, Item:%d", indexPath.section, indexPath.item];
 //newCell.eventImageView.image = [UIImage imageNamed:@"1.png"];
 //newCell.backgroundColor = [UIColor blueColor];
 
 return newCell;
 }
 */


/*
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 return CGSizeMake(50, 50);
 }
 */



/* this works - not elegant
 
 UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
 UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,150,310)];
 imgView.contentMode = UIViewContentModeScaleAspectFit;
 imgView.clipsToBounds = YES;
 imgView.image = [UIImage imageNamed:@"1.png"];//[self.imageArray objectAtIndex:indexPath.row];
 [cell addSubview:imgView];
 return cell;
 */




//#pragma mark – UICollectionViewDelegateFlowLayout
/*
 // 1
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 
 //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
 //self.searchResults[searchTerm][indexPath.row];
 // 2
 //CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
 //retval.height += 35; retval.width += 35;
 
 //return retval;
 
 
 CGSize somethingSize = CGSizeMake(100, 100);
 return somethingSize;
 
 }
 
 // 3
 - (UIEdgeInsets)collectionView:
 (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
 return UIEdgeInsetsMake(20, 20, 1000, 1000);
 }
 */

/*
 // 1
 - (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
 NSString *searchTerm = self.searches[section];
 return [self.searchResults[searchTerm] count];
 }
 // 2
 - (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
 return [self.searches count];
 }
 // 3
 - (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell " forIndexPath:indexPath];
 cell.backgroundColor = [UIColor whiteColor];
 return cell;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
