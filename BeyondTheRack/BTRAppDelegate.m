//
//  BTRAppDelegate.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-15.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRAppDelegate.h"
#import "Event+AppServer.h"
#import "Item+AppServer.h"
#import "User+AppServer.h"
#import "BagItem+AppServer.h"
#import "Order+AppServer.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BTRSearchViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface BTRAppDelegate ()


@end



@implementation BTRAppDelegate


#pragma mark - Class Methods

+ (void)initialize
{
    // Nib files require the type to have been loaded before they can do the wireup successfully.
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    
    /**
     *
     *  Initializing facebook classes
     *
     */

    [FBSDKLoginButton class];
    [FBSDKProfilePictureView class];
    [FBSDKSendButton class];
    [FBSDKShareButton class];
}


#pragma mark - UIApplicationDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch

    /**
     *
     *  Facebook setting
     *
     */
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    
    /**
     *
     *  Use the following for first time app launch
     *
     */
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        
        NSString *firstTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"FirstTime"];
        
        if (![firstTime isEqualToString:@"FALSE"]){
            
            /**
             *
             *  Currently here first time is not used for ant purpose. But in case if you want to run a piece of code only the very first time the app launches, put you code here.
             *
             */

            [[NSUserDefaults standardUserDefaults] setValue:@"FALSE" forKey:@"FirstTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    
    
    /**
     *
     *  Managing the entry scene to the app based on whether the user has signed up and logged in. Also whether the facebook token is still available.
     *
     */
    
    NSString *segueId= @"BTRLoginViewController";
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;

    BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
    BOOL shouldPresentLogin = FALSE;
    
    if (![btrSettings activeSessionPresent])
        shouldPresentLogin = TRUE;
    
    if ([btrSettings fbLoggedIn])
        if ([FBSDKAccessToken currentAccessToken])
            shouldPresentLogin = TRUE;
    
    if (shouldPresentLogin) {
    
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:segueId];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    
    /**
     *
     *  Activtes network activity indicator
     *
     */
    
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

- (BOOL)connected {
    BOOL rechable ;
    Reachability *networkReachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        rechable = NO;
    }
    else
    {
        rechable = YES;
    }
    return rechable;
}

@end