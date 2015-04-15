//
//  BTRAppDelegate.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-15.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRAppDelegate.h"

#import "BTRAppDelegate+MOC.h"

#import "BTREventFetcher.h"
#import "BTRBagFetcher.h"

#import "Event+AppServer.h"
#import "Item+AppServer.h"
#import "BagItem+AppServer.h"

//#import "BTRDatabaseAvailibility.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BTRSearchViewController.h"




@interface BTRAppDelegate ()

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSMutableArray *bagItemsArray;

@end

@implementation BTRAppDelegate


- (NSMutableArray *)bagItemsArray {
    
    if (!_bagItemsArray) _bagItemsArray = [[NSMutableArray alloc] init];
    return _bagItemsArray;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
   
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        
        
        if (!self.beyondTheRackDocument) {
            
            [[BTRDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
                self.beyondTheRackDocument = document;
                
                
                NSString *firstTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"FirstTime"];
                
                if (![firstTime isEqualToString:@"FALSE"]){
                    
                    
                    [Event initInManagedObjectContext:[document managedObjectContext]];
                    [Item initInManagedObjectContext:[document managedObjectContext]];                    
                    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                    
                    [self deleteAllObjectsInContext:[[self beyondTheRackDocument] managedObjectContext] usingModel:[[self beyondTheRackDocument] managedObjectModel]];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"FALSE" forKey:@"FirstTime"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
            }];
        }

    }];

    
    /*
     *
     Managing the entry scene to the app
     *
     */
    
    NSString *segueId= @"BTRLoginViewController";
    NSString * _Session = [[NSUserDefaults standardUserDefaults] stringForKey:@"Session"];
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    
    //segueId = @"BTRMainViewController";
    if ([_Session length] < 10)
    {
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:segueId];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    
    } else {
        
        [self getCartServerCallforSessionId:_Session success:^(NSArray *bagArray) {
            
            BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
            [sharedShoppingBag setBagItems:(NSArray *)bagArray];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    

    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {


    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - empty the db

- (void)deleteAllObjectsInContext:(NSManagedObjectContext *)context
                       usingModel:(NSManagedObjectModel *)model
{
    NSArray *entities = model.entities;
    for (NSEntityDescription *entityDescription in entities) {
        [self deleteAllObjectsWithEntityName:entityDescription.name
                                   inContext:context];
    }
}

- (void)deleteAllObjectsWithEntityName:(NSString *)entityName
                             inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest =
    [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

#pragma mark - Bag RESTful Calls


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}



- (void)getCartServerCallforSessionId:(NSString *)sessionId
                              success:(void (^)(id  responseObject)) success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *sessionIdString = sessionId;
    [manager.requestSerializer setValue:sessionIdString forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBag]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                  options:0
                                                                                    error:NULL];
             
             [self.bagItemsArray removeAllObjects];
             
             NSArray *bagJsonArray = entitiesPropertyList[@"bag"][@"reserved"];             
             NSDate *serverTime = [NSDate date];
             if ([entitiesPropertyList valueForKeyPath:@"time"] && [entitiesPropertyList valueForKeyPath:@"time"] != [NSNull null]) {
                 
                 serverTime = [NSDate dateWithTimeIntervalSince1970:[[entitiesPropertyList valueForKeyPath:@"time"] integerValue]];
             }
             
             [self.bagItemsArray addObjectsFromArray:[BagItem loadBagItemsfromAppServerArray:bagJsonArray withServerDateTime:serverTime]];
             
             success([self bagItemsArray]);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"errtr: %@", error);
             failure(operation, error);
             
         }];
}


@end




//     BTRSearchViewController * svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BTRSearchViewController"];






