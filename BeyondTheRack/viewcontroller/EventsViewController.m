//
//  EventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "EventsViewController.h"
#import "EventCollectionViewCell.h"


@interface EventsViewController ()



@property (nonatomic,strong) NSMutableArray *collectionData;
@property (strong, nonatomic) NSArray *_data;

@end

@implementation EventsViewController


- (void)viewWillAppear:(BOOL)animated
{
    self.categoryHeaderLabel.text = [self catText];
    self.pageControl.numberOfPages = [self categoryCount];
    self.pageControl.currentPage = [self selectedCategoryIndex];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.collectionData = [[NSMutableArray alloc] initWithObjects:
                           [[NSMutableArray alloc] initWithObjects:
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            @"1.png",
                            nil],
                           [[NSMutableArray alloc] initWithObjects:
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            @"2.png",
                            nil],
    [[NSMutableArray alloc] initWithObjects:
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     @"3.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     @"4.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     @"5.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     @"6.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     @"7.png",
     nil],
    [[NSMutableArray alloc] initWithObjects:
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     @"8.png",
     nil],
                           nil];
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    //_collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [[self collectionView] setDataSource:self];
    [[self collectionView] setDelegate:self];
    
    
    //[self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
   // [self.collectionView reloadData];
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
    
    NSArray  * categoryItems = [NSArray arrayWithObjects:@"The Holiday Issue", @"Editor's Picks", @"Furniture", @"Women", @"Kids", @"Home", @"State Concepts", @"Winter Sale",nil];
    
    
    self.pageControl.currentPage = currentIndex;
    self.categoryHeaderLabel.text = [categoryItems objectAtIndex:currentIndex];
    
}



// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellIdentifier" forIndexPath:indexPath];
    NSLog(@"CollectionData count: %lu", (unsigned long)[[self.collectionData objectAtIndex:indexPath.row] count]);
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
