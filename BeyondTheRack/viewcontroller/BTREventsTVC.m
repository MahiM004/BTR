//
//  BTREventsTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventsTVC.h"
#import "BTREventFetcher.h"
#import "Event+AppServer.h"
#import "BTRProductShowcaseVC.h"
#import "BTRConnectionHelper.h"

@interface BTREventsTVC ()

@property (strong, nonatomic) NSMutableArray *eventsArray;

@end



@implementation BTREventsTVC


- (NSMutableArray *)eventsArray {
    
    if (!_eventsArray) _eventsArray = [[NSMutableArray alloc] init];
    return _eventsArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self fetchEventsData];
    
    self.tableView.backgroundColor = [BTRViewUtility BTRBlack];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {

}


# pragma mark - Load Events


- (void)fetchEventsData {
    NSString* url = [NSString stringWithFormat:@"%@", [BTREventFetcher URLforRecentEventsForURLCategoryName:[self urlCategoryName]]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES success:^(NSDictionary *response) {
        NSArray *eventsArray = response[@"events"];
        self.eventsArray = [Event loadEventsfromAppServerArray:eventsArray withCategoryName:[self urlCategoryName] forEventsArray:[self eventsArray]];
        [self.tableView reloadData];
    } faild:^(NSError *error) {
        
    }];
}


#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self eventsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"EventCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    cell.backgroundColor = [UIColor darkGrayColor];
    Event *event = [[self eventsArray] objectAtIndex:[indexPath row]];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height / 3)];
    imageView.backgroundColor = [UIColor whiteColor];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTREventFetcher URLforEventImageWithId:[event imageName]]];

    __weak UIImageView *weakImageView = imageView;
    UILabel *durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width / 3.0, imageView.frame.size.height - 20, (imageView.frame.size.width * 2) / 3.0, 20)];
    durationLabel.font = [UIFont systemFontOfSize:11];
    durationLabel.textColor = [UIColor whiteColor];
    durationLabel.adjustsFontSizeToFitWidth = YES;
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.65];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeDateForLabel:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:durationLabel,@"label",event.endDateTime,@"date", nil] repeats:YES];
    
    [imageView setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"neulogo.png"]
     
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

    [cell addSubview:imageView];
    [cell addSubview:durationLabel];

    return cell;
}


#pragma mark - Navigation

- (void)changeDateForLabel:(NSTimer *)timer{
    
    NSDate *date = [[timer userInfo] objectForKey:@"date"];
    UILabel *label = [[timer userInfo] objectForKey:@"label"];

    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [sysCalendar components: (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear )
                                                  fromDate:[NSDate date]
                                                    toDate:date
                                                   options:0];
    if (components.hour < 0 || components.minute < 0 || components.second < 0) {
        [timer invalidate];
        label.text = [NSString stringWithFormat:@"Expired"];
        label.textColor = [UIColor redColor];
    } else {
        label.text = [NSString stringWithFormat:@" Event Ends In %li days %02ld:%02ld:%02ld",(long)components.day,(long)components.hour,(long)components.minute,(long)components.second];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *event = [[self eventsArray] objectAtIndex:[indexPath row]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRProductShowcaseVC *viewController = (BTRProductShowcaseVC *)[storyboard instantiateViewControllerWithIdentifier:@"BTRProductShowcaseVC"];
    viewController.eventSku = [event eventId];
    viewController.eventTitleString = [event eventName];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)dealloc {
    NSLog(@"Tab One Dealloc");
    [imageView cancelImageRequestOperation];
}




@end




