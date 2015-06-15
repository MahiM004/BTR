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

#import "ETPush.h"


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

    
    
    
    
    /**
     *  The below method has to be implemented ONLY ONCE in the SDK. The below conditions are specifically for this app and you will NOT need multiple/ conditional implementation like this in your own app
     */
    
    NSLog(@"---0-0-0--000- update_app_ID_and_accessToken_to_production!");
    
    /*
    [[ETPush pushManager] configureSDKWithAppID:@"287a5914-4541-4941-a9c9-0dcd17c33211"//@"5f171b92-850b-4207-89a2-f8f688c002a8" // The App ID from Code@ExactTarget
                                 andAccessToken:@"qmcystmu33s4zrppaxerfvyn"//@"rwuhkzvm95bcs9aye9x4drc5" // The Access Token from Code@ExactTarget
                                  withAnalytics:YES // Whether or not you would like to use Salesforce analytics services
                            andLocationServices:YES  // Whether or not you would like to use location-based alerts
                                  andCloudPages:YES]; // Whether or not you would like to use CloudPages.
    
    ///
     //ET_NOTE: The OpenDirect Delegate must be set in order for OpenDirect to work with URL schemes other than http or https. Set this before you call [[ETPush pushManager] applicationLaunchedWithOptions:launchOptions];
     //
    //[[ETPush pushManager] setOpenDirectDelegate:self];
    
    ///
     //ET_NOTE: This method delivers the launch options dictionary to the SDK. This is a required implementation step to ensure that pushes are delivered and processed by Salesforce.
     //
    [[ETPush pushManager] applicationLaunchedWithOptions:launchOptions];
    
    ////
     //ET_NOTE: This method begins the push registration workflow. It indicates to iOS (and Apple) that this application wishes to send push messages. It is required for push, but the flags you provide are at your descretion (at least one is required).
     
     //UIRemoteNotificationTypeAlert - This flag will ask for permission to show text to the user, in either Banner or an Alert.
     //UIRemoteNotificationTypeBadge - This flag allows you to update the badge on the app icon
     //UIRemoteNotificationTypeSound - This flag allows you to play a sound when the push is received.
     
     // Use these for IOS8 instead of UIRemoteNotificationType...
     //UIUserNotificationTypeBadge - This flag allows you to update the badge on the app icon
     //UIUserNotificationTypeSound - This flag allows you to play a sound when the push is received.
     //UIUserNotificationTypeAlert - This flag will ask for permission to show text to the user, in either Banner or an Alert.
     //
    
    // See ETPush.h for reasoning behind this #if logic
    // IPHONEOS_DEPLOYMENT_TARGET = 6.X or 7.X
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    // Supports IOS SDK 8.X (i.e. XCode 6.X and up)
    // are we running on IOS8 and above?
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // create user actions here if wanted
        UIMutableUserNotificationAction *userActionButton1 = [[UIMutableUserNotificationAction alloc] init];
        userActionButton1.identifier = @"userActionButton1";
        userActionButton1.title = @"View Offer";
        
        // Given seconds, not minutes, to run in the background
        userActionButton1.activationMode = UIUserNotificationActivationModeBackground;
        userActionButton1.destructive = NO;
        
        // If YES requires passcode, but does not unlock the device
        userActionButton1.authenticationRequired = NO;
        
        UIMutableUserNotificationAction *userActionButton2 = [[UIMutableUserNotificationAction alloc] init];
        userActionButton2.identifier = @"userActionButton2";
        userActionButton2.title = @"Add to Passbook";
        
        // Given seconds, not minutes, to run in the background
        userActionButton2.activationMode = UIUserNotificationActivationModeBackground;
        userActionButton2.destructive = NO;
        
        // If YES requires passcode, but does not unlock the device
        userActionButton2.authenticationRequired = NO;
        
        UIMutableUserNotificationAction *userActionButton3 = [[UIMutableUserNotificationAction alloc] init];
        userActionButton3.identifier = @"userActionButton3";
        userActionButton3.title = @"Snooze";
        
        // Given seconds, not minutes, to run in the background
        userActionButton3.activationMode = UIUserNotificationActivationModeBackground;
        userActionButton3.destructive = NO;
        
        // If YES requires passcode, but does not unlock the device
        userActionButton3.authenticationRequired = NO;
        
        UIMutableUserNotificationAction *userActionButton4 = [[UIMutableUserNotificationAction alloc] init];
        userActionButton4.identifier = @"userActionButton4";
        userActionButton4.title = @"Call Support";
        
        // this one runs in the foreground
        userActionButton4.activationMode = UIUserNotificationActivationModeForeground;
        userActionButton4.destructive = NO;
        
        // If YES requires passcode, but does not unlock the device
        userActionButton4.authenticationRequired = NO;
        
        // create a category to handle the buttons
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"Example";
        
        // these will be the default context buttons
        [category setActions:@[userActionButton1, userActionButton2, userActionButton3, userActionButton4] forContext:UIUserNotificationActionContextDefault];
        
        // these will be the minimal context buttons
        [category setActions:@[userActionButton1, userActionButton4] forContext:UIUserNotificationActionContextMinimal];
        
        // make a set of all categories the app will support - just one for now
        NSSet *categories = [NSSet setWithObjects:category, nil];
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound |
                                                UIUserNotificationTypeAlert
                                                                                 categories:categories];
        [[ETPush pushManager] registerUserNotificationSettings:settings];
        [[ETPush pushManager] registerForRemoteNotifications];
    }
    else {
        [[ETPush pushManager] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
#else
    // Supports IOS SDKs < 8.X (i.e. XCode 5.X or less)
    [[ETPush pushManager] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
#endif
#else
    // IPHONEOS_DEPLOYMENT_TARGET >= 8.X
    // Supports IOS SDK 8.X (i.e. XCode 6.X and up)
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                            UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert
                                                                             categories:nil];
    [[ETPush pushManager] registerUserNotificationSettings:settings];
    [[ETPush pushManager] registerForRemoteNotifications];
#endif
    
    ///
     //ET_NOTE: If you specify YES, then a UIAlertView will be shown if a push received and the app is in the active state. This is not the recommended best practice for production apps but is called for in some use cases
     //
    [[ETPush pushManager] shouldDisplayAlertViewIfPushReceived:NO];
    
    //
     //ET_NOTE: This method is required in order for location messaging to work and the user's location to be processed
     //
    [[ETLocationManager locationManager] startWatchingLocation];
    
    ///
     //ET_NOTE: Logging the device id is very useful for debugging purposes. One thing this can help you do is create a filtered list inside of MobilePush that only includes the device that matches this id.
     //
      NSLog(@"== DEVICE ID ==\nThe ExactTarget Device ID is: %@\n", [ETPush safeDeviceIdentifier]);
    
    // To enable logging while debugging
    [ETPush setETLoggerToRequiredState:YES];
    */
    
    /*
     *
     Managing the entry scene to the app
     *
     */
    NSString *segueId= @"BTRLoginViewController";
    BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
    
    BOOL shouldSkipLogin = TRUE;
    
    /*if ([btrSettings fbLoggedIn]) {
        
        if (![FBSDKAccessToken currentAccessToken]) {

            //shouldSkipLogin = FALSE;
            NSLog(@"---000--  FB  %d,,,   -->  %@", shouldSkipLogin, [[FBSDKAccessToken currentAccessToken] tokenString]);
        }
    
    } else */
    
    //if ([_Session length] > 10)
    
    if ([btrSettings activeSessionPresent])
    {
        shouldSkipLogin = FALSE;
    }
    
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    
    if (shouldSkipLogin) {
        
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:segueId];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];

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






