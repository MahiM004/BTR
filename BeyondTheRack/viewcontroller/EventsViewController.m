//
//  EventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "EventsViewController.h"
//#import "EventCollectionViewCell.h"
#import "ShoppingBagViewController.h"



#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "EventsTableTableViewController.h"


#import <math.h>

#define YOUR_CATAGORY 4

@interface EventsViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *originalDataArray;


@property (strong, nonatomic) TTScrollSlidingPagesController *slider;


@end

@implementation EventsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // handling boundry indexes for category titles

    
} 



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
  //  [[self collectionView] setDataSource:self];
  //  [[self collectionView] setDelegate:self];
    
    
    //[self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
    //[self.collectionView reloadData];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:YOUR_CATAGORY+1 inSection:0];
    // scrolling here does work
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    
    [self setupDataForCollectionViewInfiniteScrolling];
    
    
    NSInteger myHeaderIndex = YOUR_CATAGORY;
    
    if (myHeaderIndex >=0 && myHeaderIndex <= [self categoryCount] - 1) {
        
        self.categoryHeaderLabel.text = [self.categoryNames objectAtIndex:myHeaderIndex];
        self.nextCategory.text = [self.categoryNames objectAtIndex:[self modulaForIndex:(myHeaderIndex+1) withCategoryCount:[self categoryCount]]];
        self.lastCategory.text = [self.categoryNames objectAtIndex:[self modulaForIndex:(myHeaderIndex-1) withCategoryCount:[self categoryCount]]];
    }
    /*
    
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor lightGrayColor];
    //self.slider.titleScrollerBottomEdgeColour = [UIColor blueColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    self.slider.hideStatusBarWhenScrolling = NO;
    //self.slider.titleScrollerHidden = YES;
    //slider.titleScrollerHeight = 100;
    //slider.titleScrollerItemWidth=60;
    //self.slider.titleScrollerBackgroundColour = [UIColor redColor];
    self.slider.disableTitleScrollerShadow = YES;
    //slider.disableUIPageControl = YES;
    self.slider.initialPageNumber = 2;
    self.slider.pagingEnabled = YES;
    self.slider.zoomOutAnimationDisabled = YES;
    self.slider.disableTitleShadow = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.slider.hideStatusBarWhenScrolling = YES;//this property normally only makes sense on iOS7+. See the documentation in TTScrollSlidingPagesController.h. If you wanted to use it in iOS6 you'd have to make sure the status bar overlapped the TTScrollSlidingPagesController.
    }
    
    //set the datasource.
    self.slider.dataSource = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
    */
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
    
    
    
    /*
    EventCollectionViewCell *newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellIdentifier" forIndexPath:indexPath];
    
    //newCell.cellLabel.text = [NSString stringWithFormat:@"Section:%d, Item:%d", indexPath.section, indexPath.item];
    newCell.eventImageView.image = [UIImage imageNamed:@"1.png"];
    //newCell.backgroundColor = [UIColor blueColor];
    
    return newCell;
     */
}


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



-(void)tableCellDidSelect:(UITableViewCell *)cell{
    NSLog(@"Tap %@",cell.textLabel.text);
    //DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    //detailVC.label.text = cell.textLabel.text;
    //[self.navigationController pushViewController:detailVC animated:YES];
}



#pragma mark TTSlidingPagesDataSource methods

-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return 7;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    if (index % 2 == 0){ //just an example, alternating views between one example table view and another.
        viewController = [[EventsTableTableViewController alloc] init];
        
        //        viewController = [[TabOneViewController alloc] init];
    } else {
        viewController = [[EventsTableTableViewController alloc] init];
    }
    
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    // if (index == 0){
    //use a image as the header for the first page
    //   title= [[TTSlidingPageTitle alloc] initWithHeaderImage:[UIImage imageNamed:@"about-tomthorpelogo.png"]];
    //} else {
    //all other pages just use a simple text header
    switch (index) {
            
        case 0:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Women"];
            break;
        case 1:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Men"];
            break;
        case 2:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Your Catalog"];
            break;
        case 3:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Home"];
            break;
        case 4:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Kids"];
            break;
        case 5:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Outlet"];
            break;
        case 6:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"Curvey Closet"];
            break;
        default:
            title = [[TTSlidingPageTitle alloc] initWithHeaderText:[NSString stringWithFormat:@"Page %d", index+1]];
            break;
    }
    
    //                                                                                                                                                                                                                                 }
    return title;
}

#pragma mark - delegate
-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    NSLog(@"scrolled to view");
}

-(void)initData{
    
    self.categoryNames = [[NSMutableArray alloc] initWithObjects:
                          @"Women",
                          @"Men",
                          @"Home",
                          @"Outlet",
                          @"Your Catalog",
                          @"Kids",
                          @"Curvey Closet",
                          @"Holiday Sale",
                          nil];
    
    self.categoryCount = [[self categoryNames] count];
    
    self.originalDataArray = [[NSMutableArray alloc] initWithObjects:
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventwomen1.png",
                               @"eventwomen2.png",
                               @"eventwomen3.png",
                               @"eventwomen2.png",
                               @"eventwomen2.png",
                               @"eventwomen3.png",
                               @"eventwomen1.png",
                               @"eventwomen3.png",
                               nil],
                              
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventmen1.png",
                               @"eventmen2.png",
                               @"eventmen1.png",
                               @"eventmen2.png",
                               @"eventmen1.png",
                               @"eventmen2.png",
                               nil],
                              
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventhome1.png",
                               @"eventhome1.png",
                               @"eventhome1.png",
                               @"eventhome2.png",
                               @"eventhome1.png",
                               @"eventhome2.png",
                               nil],
                              
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventoutlet1.png",
                               @"eventoutlet2.png",
                               @"eventoutlet3.png",
                               @"eventoutlet4.png",
                               @"eventoutlet2.png",
                               @"eventoutlet4.png",
                               @"eventoutlet1.png",
                               @"eventoutlet3.png",
                               @"eventoutlet1.png",
                               @"eventoutlet1.png",
                               @"eventoutlet2.png",
                               @"eventoutlet4.png",
                               
                               nil],
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventwomen1.png",
                               @"eventwomen2.png",
                               @"eventwomen3.png",
                               @"eventmen1.png",
                               @"eventmen2.png",
                               @"eventhome1.png",
                               @"eventhome2.png",
                               @"eventoutlet1.png",
                               @"eventoutlet2.png",
                               @"eventoutlet3.png",
                               @"eventoutlet4.png",
                               @"eventkids.png",
                               @"eventcurveycloset.png",
                               @"eventholidaysale.png",
                               
                               nil],
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventkids.png",
                               @"eventkids.png",
                               @"eventkids.png",
                               @"eventkids.png",
                               @"eventkids.png",
                               nil],
                              
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               @"eventcurveycloset.png",
                               nil],
                              [[NSMutableArray alloc] initWithObjects:
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               @"eventholidaysale.png",
                               
                               nil],
                              
                              nil];
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


- (IBAction)unwindFromShoppingBagToMainScene:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindFromMyAccount:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindToEventViewController:(UIStoryboardSegue *)unwindSegue
{
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
