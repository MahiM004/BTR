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

#import <math.h>

@interface EventsViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *originalDataArray;

@end

@implementation EventsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // handling boundry indexes for category titles
    NSInteger myHeaderIndex = [self selectedCategoryIndex];

    if (myHeaderIndex >=0 && myHeaderIndex <= [self categoryCount] - 1) {
        
        self.categoryHeaderLabel.text = [self.categoryNames objectAtIndex:myHeaderIndex];
        self.nextCategory.text = [self.categoryNames objectAtIndex:[self modulaForIndex:(myHeaderIndex+1) withCategoryCount:[self categoryCount]]];
        self.lastCategory.text = [self.categoryNames objectAtIndex:[self modulaForIndex:(myHeaderIndex-1) withCategoryCount:[self categoryCount]]];
    }
    
} 



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.originalDataArray = [[NSMutableArray alloc] initWithObjects:
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
                               @"8o.png",
                               nil],

                           nil];
    
    
    
    [[self collectionView] setDataSource:self];
    [[self collectionView] setDelegate:self];
    
    
    //[self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //[self.collectionView reloadData];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self selectedCategoryIndex]+1 inSection:0];
    // scrolling here does work
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    
    [self setupDataForCollectionViewInfiniteScrolling];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource


// for infinite scrolling
-(void)setupDataForCollectionViewInfiniteScrolling {
    
    id firstItem = [[self originalDataArray] objectAtIndex:0];
    id lastItem = [[self originalDataArray ] lastObject];
    
    NSMutableArray *workingArray = [self.originalDataArray mutableCopy];
    
    // Add the copy of the last item to the beginning
    [workingArray insertObject:lastItem atIndex:0];
    
    // Add the copy of the first item to the end
    [workingArray addObject:firstItem];
    
    // Update the collection view's data source property
    self.dataArray = [NSMutableArray arrayWithArray:workingArray];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return [self categoryCount]+2; // extra 2 for infinite scrolling
}



// for infinite scrolling
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    
    // handling boundry indexes for category titles
    NSInteger myHeaderIndex = currentIndex - 1;
    if (myHeaderIndex == [self categoryCount]) myHeaderIndex = 0;
    if (myHeaderIndex == -1) myHeaderIndex = [self categoryCount] - 1;

    if (myHeaderIndex >=0 && myHeaderIndex <= [self categoryCount] - 1) {
        
        self.categoryHeaderLabel.text = [self.categoryNames objectAtIndex:myHeaderIndex];
        self.nextCategory.text = [self.categoryNames objectAtIndex:[self modulaForIndex:(myHeaderIndex+1) withCategoryCount:[self categoryCount]]];
        self.lastCategory.text = [self.categoryNames objectAtIndex:[self modulaForIndex:(myHeaderIndex-1) withCategoryCount:[self categoryCount]]];

    }
    

    if (currentIndex == ([self categoryCount] + 1)) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

    } else if (scrollView.contentOffset.x == 0)  {
        
        // user is scrolling to the left from the first item to the fake 'item N'.
        // reposition offset to show the 'real' item N at the right end end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self categoryCount]) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

    }
}



// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellIdentifier" forIndexPath:indexPath];
   
    cell.cellData = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.tableView reloadData];
    return cell;
}

-(void)tableCellDidSelect:(UITableViewCell *)cell{
    NSLog(@"Tap %@",cell.textLabel.text);
    //DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    //detailVC.label.text = cell.textLabel.text;
    //[self.navigationController pushViewController:detailVC animated:YES];
}



- (IBAction)tappedShoppingBag:(id)sender {

    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (IBAction)unwindFromShoppingBagToEventsScene:(UIStoryboardSegue *)unwindSegue
{
}



- (NSInteger) modulaForIndex:(NSInteger)inputInt withCategoryCount:(NSInteger)count
{
    NSInteger relevantInt = (inputInt >= 0) ? (inputInt % count) : ((inputInt % count) + count);

    return relevantInt;
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
