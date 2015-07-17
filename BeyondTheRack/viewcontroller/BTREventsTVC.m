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

# pragma mark - Load Events


- (void)fetchEventsData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTREventFetcher URLforRecentEventsForURLCategoryName:[self urlCategoryName]]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSArray * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
         
         self.eventsArray = [Event loadEventsfromAppServerArray:entitiesPropertyList withCategoryName:[self urlCategoryName] forEventsArray:[self eventsArray]];
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    
}


#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 161;
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

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    imageView.backgroundColor = [UIColor whiteColor];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTREventFetcher URLforEventImageWithId:[event imageName]]];

    __weak UIImageView *weakImageView = imageView;
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
    
    return cell;
}


#pragma mark - Navigation


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




