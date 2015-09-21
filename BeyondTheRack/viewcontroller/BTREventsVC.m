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
@end

@implementation BTREventsVC

- (NSMutableArray *)eventsArray {
    
    if (!_eventsArray) _eventsArray = [[NSMutableArray alloc] init];
    return _eventsArray;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEventsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)fetchEventsData {
    NSString* url = [NSString stringWithFormat:@"%@", [BTREventFetcher URLforRecentEventsForURLCategoryName:[self urlCategoryName]]];
    [BTRLoader showLoaderInView:self.view];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSArray *eventsArray = response[@"events"];
        self.eventsArray = [Event loadEventsfromAppServerArray:eventsArray withCategoryName:[self urlCategoryName] forEventsArray:[self eventsArray]];
        [self.collectionView reloadData];
        [self reloadTimers];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadTimers) userInfo:nil repeats:YES];
        [BTRLoader hideLoaderFromView:self.view];
    } faild:^(NSError *error) {
        
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
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.frame.size.width > 400) {
        return CGSizeMake(collectionView.frame.size.width / 2 - 1, 200);
    }
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height / 3);
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

@end
