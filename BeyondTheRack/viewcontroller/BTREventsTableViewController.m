//
//  BTREventsTableViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventsTableViewController.h"
#import "BTREventFetcher.h"

#import "Event+AppServer.h"

@interface BTREventsTableViewController ()

@property (strong, nonatomic) NSMutableArray *eventArray;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BTREventsTableViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    self.tableView.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setupDocument];
        [self.tableView reloadData];

    }];

}


# pragma mark - Load Events

- (void)setupDocument
{
    
    
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
        [self setupFetchedResultsController];
        [self fetchEventsDataIntoDocument:[self beyondTheRackDocument]];
        [self.tableView reloadData];
        
        
        
    } else {

        [self fetchEventsDataIntoDocument:[self beyondTheRackDocument]];
        [self.tableView reloadData];
        
    }

}


- (void)fetchEventsDataIntoDocument:(UIManagedDocument *)document
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTREventFetcher URLforAllRecentEvents]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSArray * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
         
         [Event loadEventsFromAppServerArray:entitiesPropertyList intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         //NSLog(@"Error: %@", error);
     }];
    
}


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"imageName" ascending:YES]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}



#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 161;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];

    self.eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 159)];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTREventFetcher URLforEventImageWithId:[event imageName]]];

    __weak typeof(self) weakSelf = self;
    [self.eventImageView setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"neulogo.png"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakSelf.eventImageView.alpha = 0.0;
                                       weakSelf.eventImageView.image = image;
                                       [UIView animateWithDuration:0.25
                                                        animations:^{
                                                            weakSelf.eventImageView.alpha = 1.0;
                                                        }];
                                   }
                                   failure:nil];
    
    
    [cell addSubview:self.eventImageView];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cell Tapped" message:[NSString stringWithFormat:@"Cell %ld tapped", (long)indexPath.row] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)dealloc {
    NSLog(@"Tab One Dealloc");
}




@end




// [eventImageView setImageWithURL:[BTREventFetcher URLforEventImageWithId:[event imageName]]] ;//] placeholderImage:[UIImage imageNamed:@"neulogo.png"]];

/*
 [eventImageView setImageWithURL:[BTREventFetcher URLforEventImageWithId:[event imageName]]
 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
 
 self.imageView.alpha = 0.0;
 self.imageView.image = image;
 [UIView animateWithDuration:0.25
 animations:^{
 self.imageView.alpha = 1.0;
 }];
 }
 failure:NULL];
 */



