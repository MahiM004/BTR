//
//  BTREventsTableViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-07.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventsCDTVC.h"
#import "BTREventFetcher.h"

#import "Event+AppServer.h"

@interface BTREventsCDTVC ()

@property (strong, nonatomic) NSMutableArray *eventArray;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BTREventsCDTVC



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    self.tableView.backgroundColor = [BTRUtility BTRBlack];
    self.tableView.separatorColor = [UIColor clearColor];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setupDocument];
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
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTREventFetcher URLforRecentEventsForURLCategoryName:[self urlCategoryName]]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSArray * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
         
         [Event loadEventsFromAppServerArray:entitiesPropertyList andCategoryName:[self urlCategoryName] intoManagedObjectContext:self.beyondTheRackDocument.managedObjectContext];
         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         //NSLog(@"Error: %@", error);
     }];
    
}


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"imageName" ascending:YES]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"myCategoryName==%@", [self urlCategoryName]]];

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

    cell.backgroundColor = [UIColor darkGrayColor];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    imageView.backgroundColor = [UIColor whiteColor];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[BTREventFetcher URLforEventImageWithId:[event imageName]]];

    __weak UIImageView *weakImageView = imageView;
    [imageView setImageWithURLRequest:urlRequest placeholderImage:nil
     
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
                              
                                  
                                  weakImageView.image = [UIImage imageNamed:@"neulogo.png"];
                              
                              }];

    [cell addSubview:imageView];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cell Tapped" message:[NSString stringWithFormat:@"Cell %ld tapped", (long)indexPath.row] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)dealloc {
    NSLog(@"Tab One Dealloc");
    [imageView cancelImageRequestOperation];

}




@end




