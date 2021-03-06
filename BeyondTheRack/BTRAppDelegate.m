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
#import "DNNotificationController.h"
#import "DNDonkyCore.h"
#import "BTRInitializeViewController.h"
#import <IQKeyboardManager.h>
#import "BTRCheckoutViewController.h"
#import "User+AppServer.h"
#import "BTRUserFetcher.h"
#import "DNAccountController.h"

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
    if ([BTRViewUtility isIPAD])
        [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[BTRCheckoutViewController class]];
    
    /**
     *
     *  Use the following for first time app launch
     *
     */
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"%@; %@ ; BTR_IOS_App",appVersion,secretAgent];
    [[BTRSettingManager defaultManager]setInSetting:userAgent forKey:kUSERAGENT];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        BOOL isFirstTime = ![[[BTRSettingManager defaultManager]objectForKeyInSetting:kFIRSTTIMERUNNING]boolValue];
        if (isFirstTime){
            NSLocale *currentLocale = [NSLocale currentLocale];
            NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
            [[BTRSettingManager defaultManager]setInSetting:countryCode forKey:kUSERLOCATION];
            [[BTRSettingManager defaultManager]setInSetting:[NSNumber numberWithBool:YES] forKey:kFIRSTTIMERUNNING];
            
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [[DNDonkyCore sharedInstance] initialiseWithAPIKey:@"1KgJgRCYwEhqnA1PHeaKEaQsLaklBN2t8TiBI0gezGFmhmki9Kr7mHTKEGb3QPWeCwia1qDRKNtJbt3wyFyQ"];
        [self checkForRegisterUser];
    });
    
    [BTRGAHelper setupGA];
    
    [[BTRRefreshManager sharedInstance]start];
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

- (void)backToInitialViewControllerFrom:(UIViewController *)viewController {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRInitializeViewController *initial = [mainStoryBoard instantiateViewControllerWithIdentifier:@"BTRinitializeVCIdentifier"];
    self.window.rootViewController = initial;
    for (UIView *subview in self.window.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            [subview removeFromSuperview];
        }
    }
    [viewController dismissViewControllerAnimated:NO completion:^{
        [viewController.view removeFromSuperview];
    }];
    [self checkForRegisterUser];
}

#pragma mark Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [DNNotificationController registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [DNNotificationController didReceiveNotification:userInfo handleActionIdentifier:nil completionHandler:^(NSString *string) {
        completionHandler(UIBackgroundFetchResultNewData);
    }];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    [DNNotificationController didReceiveNotification:userInfo handleActionIdentifier:identifier completionHandler:^(NSString *string) {
        completionHandler();
    }];
}

- (void)checkForRegisterUser {
    if (![[[BTRSettingManager defaultManager]objectForKeyInSetting:kNOTIFICATIONREGISTER]boolValue] && [[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfoDetail]];
        [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
            if (response) {
                User *newUser = [[User alloc]init];
                
                [User userWithAppServerInfo:response forUser:newUser];
                [[BTRSettingManager defaultManager]setInSetting:newUser.userId forKey:kUSERID];
                
                DNUserDetails *knownUser = [[DNUserDetails alloc] initWithUserID:newUser.userId displayName:[NSString stringWithFormat:@"%@ %@",newUser.name,newUser.lastName] emailAddress:newUser.email mobileNumber:newUser.mobile countryCode:newUser.country firstName:newUser.name lastName:newUser.lastName avatarID:nil selectedTags:nil additionalProperties:nil];
                [DNAccountController updateUserDetails:knownUser automaticallyHandleUserIDTaken:YES success:^(NSURLSessionDataTask *task, id responseData) {
                    [[BTRSettingManager defaultManager]setInSetting:@YES forKey:kNOTIFICATIONREGISTER];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }];
            }
        } faild:^(NSError *error) {
        }];
    }
}

@end