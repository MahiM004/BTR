//
//  BTREventsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-19.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRMainViewController.h"
#import "BTRShoppingBagViewController.h"
#import "BTRCategoryViewController.h"
#import "BTRFacetsHandler.h"
#import "BTRSearchViewController.h"
#import "BTRBagFetcher.h"
#import "BTRAccountEmbeddedTVC.h"
#import "BTRAnimationHandler.h"
#import "BTRConnectionHelper.h"
#import "User+AppServer.h"
#import "Contact+AppServer.h"
#import "BTROrderHistoryFetcher.h"
#import "OrderHistoryBag+AppServer.h"
#import "BTRUserFetcher.h"
#import "OrderHistoryItem+AppServer.h"
#import "BTRContactFetcher.h"
#import "BTRContactUSViewController.h"
#import "BTRNotificationsVC.h"
#import "BTRTrackOrdersVC.h"
#import "BTRAccountInformationVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "BTRLoginViewController.h"
#import "JTSlideShadowAnimation.h"
#import "BTRLoader.h"
#import <math.h>
#import <FRDLivelyButton/FRDLivelyButton.h>

@interface BTRMainViewController ()

@property (weak, nonatomic) IBOutlet FRDLivelyButton * sideMenuButton;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGest;

@property (strong, nonatomic) JTSlideShadowAnimation *shadowAnimation;
@property (strong, nonatomic) BTRAccountEmbeddedTVC *accountViewController;

@property (strong, nonatomic) NSMutableDictionary *itemsDictionary;
@property (strong, nonatomic) NSMutableArray *headersArray;
@property (nonatomic, strong) Contact *contactInfo;

@property BOOL isMenuOpen;
@property (strong, nonatomic) UIView *tapRecognizerView;
@property NSString *type;
@property operation lastOperation;
@property BOOL isWorking;
@property BOOL isShadowsAnimationDone;

@end

@implementation BTRMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        [self getCartCountServerCallWithSuccess:^(NSString *bagCountString) {
            self.bagButton.badgeValue = bagCountString;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    [sharedFacetHandler resetFacets];
    sharedFacetHandler.searchString = @"";
    [_sideMenuButton setOptions:@{ kFRDLivelyButtonLineWidth: @(1.5f),
                          kFRDLivelyButtonHighlightedColor: [UIColor whiteColor],
                          kFRDLivelyButtonColor: [BTRViewUtility BTRBlack]
                          }];
    [_sideMenuButton setStyle:kFRDLivelyButtonStyleHamburger animated:YES];

}

-(void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin:)
                                                 name:kUSERDIDLOGIN
                                               object:nil];
    if (self.isShadowsAnimationDone == NO) {
        [NSTimer scheduledTimerWithTimeInterval:6.4
                                         target:self
                                       selector:@selector(updateImage)
                                       userInfo:nil
                                        repeats:NO];
        self.shadowAnimation = [JTSlideShadowAnimation new];
        self.shadowAnimation.animatedView = self.logoImageView;
        self.shadowAnimation.repeatCount = 1;
        self.shadowAnimation.duration = 7;
        [self.shadowAnimation start];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUSERDIDLOGIN object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.isMenuOpen = NO;
    self.isShadowsAnimationDone = NO;
    if (!self.swipeGest) {
        self.swipeGest = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
        self.swipeGest.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:self.swipeGest];
    }
}

-(void)updateImage {
    [self.shadowAnimation stop];
    [self setIsShadowsAnimationDone:YES];
}

#pragma mark - Get bag count

- (void)getCartCountServerCallWithSuccess:(void (^)(id  responseObject)) success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString *url = [NSString stringWithFormat:@"%@", [BTRBagFetcher URLforBagCount]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        NSString *bagCount = [NSString stringWithFormat:@"%@",response[@"count"]];
        BTRBagHandler *sharedShoppingBag = [BTRBagHandler sharedShoppingBag];
        sharedShoppingBag.bagCount = [bagCount integerValue];
        success(bagCount);
    } faild:^(NSError *error) {
        NSLog(@"errtr: %@", error);
        failure(nil, error);
    }];
}

#pragma mark - Navigation

- (IBAction)myAccountButtonTapped:(id)sender {
    if (![[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        [self setLastOperation:openUserMenu];
        [self showLogin];
        return;
    }
    
    if (self.isMenuOpen) {
        [self closeMenu];
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.accountViewController = (BTRAccountEmbeddedTVC *)[storyboard instantiateViewControllerWithIdentifier:@"BTRMyAccountController"];
    self.accountViewController.delegate = self;
    self.isMenuOpen = YES;
    [_sideMenuButton setStyle:kFRDLivelyButtonStyleArrowLeft animated:YES];
    [self AddTapRecognizerView];
    [BTRAnimationHandler showViewController:self.accountViewController atLeftOfViewController:self inDuration:0.5];
}

- (void)closeMenu {
    [self removeTapRecognizerView];
    [BTRAnimationHandler hideViewController:self.accountViewController fromMainViewController:self inDuration:0.5];
    [self setIsMenuOpen:NO];
    [_sideMenuButton setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
    dispatch_async (dispatch_get_main_queue(), ^{
        [self removeTapRecognizerView];
    });
}

- (IBAction)searchButtonTapped:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTRSearchViewController *viewController = (BTRSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchNavigationControllerIdentifier"];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)tappedShoppingBag:(id)sender {
    if ([[BTRSessionSettings sessionSettings]isUserLoggedIn]) {
        UIStoryboard *storyboard = self.storyboard;
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [self setLastOperation:gotoBag];
        [self showLogin];
    }
}

#pragma mark Account Delegate

- (void)signOutDidSelect {
    [self removeTapRecognizerView];
    [BTRAnimationHandler hideViewController:self.accountViewController fromMainViewController:self inDuration:0.0];
    [self setIsMenuOpen:NO];
    [self logutUserServerCallWithSuccess:^(NSString *didSucceed) {
        BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
        [btrSettings clearSession];
        self.bagButton.badgeValue = 0;
        [[[UIAlertView alloc]initWithTitle:@"Sign Out" message:@"You have been successfully signed out" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)userInformationDidSelect {
    [self removeTapRecognizerView];
    [BTRAnimationHandler hideViewController:self.accountViewController fromMainViewController:self inDuration:0.5];
    [self setIsMenuOpen:NO];
    [self performSegueWithIdentifier:_type sender:self];
}

-(void)deviceType:(NSString*)type {
    _type = type;
}

- (void)trackOrderDidSelect {
    [self removeTapRecognizerView];
    [BTRAnimationHandler hideViewController:self.accountViewController fromMainViewController:self inDuration:0.5];
    if (self.isWorking)
        return;
    [BTRLoader showLoaderInView:self.view];
    self.isWorking = YES;
    [self setIsMenuOpen:NO];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchOrderHistoryWithSuccess:^(NSDictionary *response) {
            if (response.count > 0) {
                NSArray *allKeysArray = response.allKeys;
                NSMutableArray *tempHeaderArray = [[NSMutableArray alloc] init];
                if ([allKeysArray count] != 0) {
                    for (NSString *key in allKeysArray) {
                        OrderHistoryBag *ohBag = [[OrderHistoryBag alloc] init];
                        NSDictionary *tempDictionary = [response objectForKey:key];
                        ohBag = [OrderHistoryBag extractOrderHistoryfromJSONDictionary:tempDictionary forOrderHistoryBag:ohBag];
                        [tempHeaderArray addObject:ohBag];
                        NSArray *tempArray = tempDictionary[@"lines"];
                        NSMutableArray *linesArray = [[NSMutableArray alloc] init];
                        linesArray = [OrderHistoryItem loadOrderHistoryItemsfromAppServerArray:tempArray forOrderHistoryItemsArray:linesArray];
                        [self.itemsDictionary setObject:linesArray forKey:key];
                    }
                    self.headersArray = tempHeaderArray;
                }
                [self performSegueWithIdentifier:@"BTRTrackOrdersSegueIdentifier" sender:self];
            }else {
                [self faildRequest];
                [[[UIAlertView alloc]initWithTitle:@"Empty" message:@"You dont have any order to track" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            }
        } failure:^(NSError *error) {
            [self faildRequest];
        }];
    });
}

- (void)notificationSettingDidSelect {
    [self removeTapRecognizerView];
    [BTRAnimationHandler hideViewController:self.accountViewController fromMainViewController:self inDuration:0.5];
    if (self.isWorking)
        return;
    [BTRLoader showLoaderInView:self.view];
    self.isWorking = YES;
    [self setIsMenuOpen:NO];
    [self performSegueWithIdentifier:_type sender:nil];
}

- (void)helpDidSelect {
    [self removeTapRecognizerView];
    [BTRAnimationHandler hideViewController:self.accountViewController fromMainViewController:self inDuration:0.5];
    if (self.isWorking)
        return;
    [BTRLoader showLoaderInView:self.view];
    self.isWorking = YES;
    [self setIsMenuOpen:NO];
    if (self.contactInfo == nil) {
        [self fetchContactWithSuccess:^(id responseObject) {
            [self performSegueWithIdentifier:@"BTRContactusSegueIdentifier" sender:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self faildRequest];
        }];
    } else
        [self performSegueWithIdentifier:@"BTRContactusSegueIdentifier" sender:self];
}

#pragma mark FETCHERS

- (void)fetchOrderHistoryWithSuccess:(void (^)(id  responseObject)) success
                             failure:(void (^)(NSError *error)) failure {
    if (!self.itemsDictionary)
        self.itemsDictionary = [NSMutableDictionary dictionary];
    [[self itemsDictionary] removeAllObjects];
    [[self headersArray] removeAllObjects];
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderHistoryFetcher URLforOrderHistory]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(response);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (void)fetchUserWithSuccess:(void (^)(id  responseObject)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfo]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            self.user = [User userWithAppServerInfo:response forUser:[self user]];
            success(self.user);
        }
    } faild:^(NSError *error) {
        failure(nil, error);
    }];
}

- (void)fetchContactWithSuccess:(void (^)(id  responseObject)) success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRContactFetcher URLForContact]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            if (!self.contactInfo)
                self.contactInfo = [[Contact alloc]init];
            self.contactInfo = [Contact contactWithAppServerInfo:response];
            success(self.contactInfo);
        }
    } faild:^(NSError *error) {
        failure(nil,error);
    }];
}

- (void)logutUserServerCallWithSuccess:(void (^)(id  responseObject)) success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserLogout]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        FBSDKLoginManager *fbAuth = [[FBSDKLoginManager alloc] init];
        [fbAuth logOut];
        success(@"TRUE");
    } faild:^(NSError *error) {
        failure(nil, error);
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.isWorking = NO;
    [BTRLoader hideLoaderFromView:self.view];
    if ([[segue identifier] isEqualToString:@"BTRNotificationsSegueIdentifier"] || [[segue identifier] isEqualToString:@"BTRNotificationsSegueiPadIdentifier"]) {
        BTRNotificationsVC *vc = [segue destinationViewController];
        vc.user = [self user];

    } else if ([[segue identifier] isEqualToString:@"BTRTrackOrdersSegueIdentifier"]) {
        BTRTrackOrdersVC *vc = [segue destinationViewController];
        vc.headersArray = [self headersArray];
        vc.itemsDictionary = [self itemsDictionary];

    } else if ([[segue identifier] isEqualToString:@"BTRContactusSegueIdentifier"]) {
        BTRContactUSViewController* vc = [segue destinationViewController];
        vc.contactInformaion = self.contactInfo;
        
    } else if ([[segue identifier] isEqualToString:@"BTRAccountInformationSegueIdentifier"]) {
//        BTRAccountInformationVC* info = [segue destinationViewController];
//        info.us
    }
}

- (void)AddTapRecognizerView {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myAccountButtonTapped:)];
    _tapRecognizerView = [[UIView alloc]initWithFrame:self.view.frame];
    _tapRecognizerView.backgroundColor = [UIColor clearColor];
    [_tapRecognizerView addGestureRecognizer:tap];
    [self.view addSubview:_tapRecognizerView];
}

- (void)removeTapRecognizerView {
    [_sideMenuButton setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
    [_tapRecognizerView removeFromSuperview];
    _tapRecognizerView = nil;
}

- (void)showLogin {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRLoginNavigation"];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidLogin:(NSNotification *) notification {
    if (self.lastOperation == openUserMenu)
        [self myAccountButtonTapped:nil];
    if (self.lastOperation == gotoBag)
        [self tappedShoppingBag:nil];
}

- (void)faildRequest {
    dispatch_async (dispatch_get_main_queue(), ^{
        [BTRLoader hideLoaderFromView:self.view];
        [self setIsWorking:NO];
    });
}


@end