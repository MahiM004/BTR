//
//  BTREventsTableViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventsTableViewController.h"
#import "BTREventTableViewCell.h"
#import "BTREventFetcher.h"

#import "Event+AppServer.h"

@interface BTREventsTableViewController ()

@property (strong, nonatomic) NSMutableArray *eventArray;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation BTREventsTableViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"BTREventTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"EventCellIdentifier"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
   // [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self getServerData];
        // Main thread work (UI usually)
        [self.tableView reloadData];
    //}];

    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [[self eventArray] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 161;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    
    NSString *imageName = [NSString stringWithFormat:@"eventImage%@.PNG",[(Event *)[[self eventArray] objectAtIndex:indexPath.row] eventId]];
    UIImage *img = [BTRUtility imageWithFilename:imageName];
    
    if (img == nil)
    {
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTREventFetcher URLforEventImageWithId:[(Event *)[[self eventArray] objectAtIndex:indexPath.row] imageName]]];
        

        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            cell.imageView.image = responseObject;
            [BTRUtility saveImage:responseObject withFilename:imageName];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            cell.imageView.image = [UIImage imageNamed:@"neulogo.png"];
            cell.backgroundColor = [UIColor redColor];
            //NSLog(@"Error: %@", error);

        }];
        [requestOperation start];
        
    }
    else {
        cell.imageView.image = img;
    }
    
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cell Tapped" message:[NSString stringWithFormat:@"Cell %ld tapped", (long)indexPath.row] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)dealloc {
    NSLog(@"Tab One Dealloc");
}




# pragma mark - Load Events

- (void)getServerData
{
    
    //    if([Reachability connectedToInternet])
    //  {
    
    if (!self.beyondTheRackDocument.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        [self fetchEventsDataIntoDocument:[self beyondTheRackDocument]];
        
    } else {
        
        [self fetchEventsDataIntoDocument:[self beyondTheRackDocument]];
    }
    //   }
    
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
         
         NSArray *eventObjects = [Event loadEventsFromAppServerArray:entitiesPropertyList intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
         
         self.eventArray = [[NSMutableArray alloc] initWithArray:eventObjects];
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         //NSLog(@"Error: %@", error);
     }];
    
}





@end





