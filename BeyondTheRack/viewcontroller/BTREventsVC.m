//
//  BTREventsVC.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventsVC.h"
#import "BTREventFetcher.h"
#import "Event+AppServer.h"
#import "BTRProductShowcaseVC.h"
#import "BTRConnectionHelper.h"
#import "UIImageView+AFNetworking.h"
#import "BTREventCell.h"
#import "BTRLoader.h"

@interface BTREventsVC ()

@property (strong, nonatomic) NSMutableArray *eventsArray;

// Pagination
@property int currentPage;
@property BOOL isLoadingNextPage;
@property BOOL lastPageDidLoad;

@end

@implementation BTREventsVC

- (NSMutableArray *)eventsArray {
    
    if (!_eventsArray) _eventsArray = [[NSMutableArray alloc] init];
    return _eventsArray;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFirstPageEvents];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.02 animations:^{
        [self.collectionView performBatchUpdates:nil completion:nil];
    }];
}

#pragma mark LoadEvents

- (void)loadFirstPageEvents {
    self.currentPage = 1;
    self.isLoadingNextPage = YES;
    self.lastPageDidLoad = NO;
    [self fetchEventsDataForPage:1 success:^(id responseObject) {
        NSArray *events = responseObject[@"events"];
        self.eventsArray = [Event loadEventsfromAppServerArray:events withCategoryName:[self urlCategoryName] forEventsArray:[self eventsArray]];
        [self.collectionView reloadData];
        [self reloadTimers];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadTimers) userInfo:nil repeats:YES];
        self.isLoadingNextPage = NO;
    } failure:^(NSError *error) {
        self.isLoadingNextPage = NO;
        NSLog(@"%@",error.description);
    }];
}

- (void)callForNextPage {
    self.isLoadingNextPage = YES;
    self.currentPage++;
    [self fetchEventsDataForPage:self.currentPage success:^(id responseObject) {
        NSArray *events = responseObject[@"events"];
        if (events.count == 0) {
            self.lastPageDidLoad = YES;
            return;
        }
        NSMutableArray* newItems = [[NSMutableArray alloc]init];
        newItems = [Event loadEventsfromAppServerArray:events withCategoryName:[self urlCategoryName] forEventsArray:newItems];
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        [self.eventsArray addObjectsFromArray:newItems];
        for (int i = 0; i < [newItems count]; i++)
            [indexPaths addObject:[NSIndexPath indexPathForItem:[self.eventsArray count] - [newItems count] + i  inSection:0]];
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + 50)];
        self.isLoadingNextPage = NO;
    } failure:^(NSError *error) {
        self.isLoadingNextPage = NO;

    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self eventsArray] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTREventCell *cell = (BTREventCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    Event *event = [[self eventsArray] objectAtIndex:[indexPath row]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTREventFetcher URLforEventImageWithId:[event imageName]]];
    cell.durationLabel.adjustsFontSizeToFitWidth = YES;
    [self changeDateForLabel:cell.durationLabel withDate:[[self.eventsArray objectAtIndex:indexPath.row]endDateTime]];
    __weak UIImageView *weakImageView = cell.eventImage;
    [cell.eventImage setImageWithURLRequest:urlRequest placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  UIImageView *strongImageView = weakImageView; // make local strong reference to protect against race conditions
                                  if (!strongImageView) return;
                                  weakImageView.alpha = 0.9;
                                  weakImageView.image = image;
                                  [UIView animateWithDuration:0.6
                                                   animations:^{
                                                       weakImageView.alpha = 1;
                                                   }
                                                   completion:nil];
                              } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                  weakImageView.image = [UIImage imageNamed:nil];
                              }];
    return cell;
}

#pragma mark RESTAPI

- (void)fetchEventsDataForPage:(int)pageNum success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure{
    NSString* url = [NSString stringWithFormat:@"%@", [BTREventFetcher URLforRecentEventsForURLCategoryName:[self urlCategoryName] forPage:pageNum]];
    [BTRLoader showLoaderInView:self.view];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(response);
        [BTRLoader hideLoaderFromView:self.view];
    } faild:^(NSError *error) {
        [BTRLoader hideLoaderFromView:self.view];
    }];
}

- (void)reloadTimers{
    for (int i = 0; i < [self.eventsArray count]; i++) {
        BTREventCell *cell = (BTREventCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self changeDateForLabel:cell.durationLabel withDate:[[self.eventsArray objectAtIndex:i]endDateTime]];
    }
}

- (void)changeDateForLabel:(UILabel *)label withDate:(NSDate *)date{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [sysCalendar components: (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear )
                                                  fromDate:[NSDate date]
                                                    toDate:date
                                                   options:0];
    if (components.hour < 0 || components.minute < 0 || components.second < 0) {
        label.text = [NSString stringWithFormat:@"Expired"];
        label.textColor = [UIColor redColor];
    } else {
        label.text = [NSString stringWithFormat:@" Event Ends In %li days %02ld:%02ld:%02ld",(long)components.day,(long)components.hour,(long)components.minute,(long)components.second];
        label.textColor = [UIColor whiteColor];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([BTRViewUtility isIPAD]) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            return CGSizeMake(screenBounds.size.width / 2 - 4.6,250);
        } else
            return CGSizeMake(screenBounds.size.width / 2 - 4.6, 200);
    }else
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height / 3);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    [self.collectionView.collectionViewLayout invalidateLayout];
}
#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [[self eventsArray] objectAtIndex:[indexPath row]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRProductShowcaseVC *viewController = (BTRProductShowcaseVC *)[storyboard instantiateViewControllerWithIdentifier:@"BTRProductShowcaseVC"];
    viewController.eventSku = [event eventId];
    viewController.eventTitleString = [event eventName];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    if (scrollOffset + scrollViewHeight > scrollContentSizeHeight - 1 * self.collectionView.frame.size.height) {
    if (!self.isLoadingNextPage && !self.lastPageDidLoad) {
        [self callForNextPage];
    }
}
}


@end
