//
//  BTRAppDelegate.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-15.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRAppDelegate.h"

#import "BTRAppDelegate+MOC.h"

#import "Event+AppServer.h"
#import "Item+AppServer.h"
//#import "BTRDatabaseAvailibility.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BTRSearchViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface BTRAppDelegate ()

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end

@implementation BTRAppDelegate


#pragma mark - Class Methods

+ (void)initialize
{
    // Nib files require the type to have been loaded before they can do the wireup successfully.
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    [FBSDKLoginButton class];
    [FBSDKProfilePictureView class];
    [FBSDKSendButton class];
    [FBSDKShareButton class];
}


#pragma mark - UIApplicationDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
   
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
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

    }
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //return YES;
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication                                                       annotation:annotation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    
    // Do the following if you use Mobile App Engagement Ads to get the deferred
    // app link after your app is installed.
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        if (error) {
            NSLog(@"Received error while fetching deferred app link %@", error);
        }
        if (url) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
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







@end




//     BTRSearchViewController * svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BTRSearchViewController"];






