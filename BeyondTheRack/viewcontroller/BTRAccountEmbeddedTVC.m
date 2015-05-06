//
//  BTRAccountEmbeddedTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountEmbeddedTVC.h"
#import "BTRLoginViewController.h"

//#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



#import "BTRUserFetcher.h"
#import "User+AppServer.h"


@interface BTRAccountEmbeddedTVC ()


@property (strong, nonatomic) NSString *sessionId;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation BTRAccountEmbeddedTVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
    self.sessionId  = [btrSettings sessionId];
    
    [self setupDocument];
    
    [self fetchUserDataIntoDocument:[self beyondTheRackDocument] success:^(User *user) {
        
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@ %@", [user name], [user lastName]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)signOutButtonTapped:(UIButton *)sender {
    

    [self logutUserServerCallforSessionId:[self sessionId] success:^(NSString *didSucceed) {
        
        BTRSessionSettings *btrSettings = [BTRSessionSettings sessionSettings];
        [btrSettings clearSession];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BTRLoginViewController *viewController = (BTRLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BTRLoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


#pragma mark - Load User Info RESTful


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}


- (void)fetchUserDataIntoDocument:(UIManagedDocument *)document
                          success:(void (^)(id  responseObject)) success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSString *sessionIdString = [self sessionId];
    [manager.requestSerializer setValue:sessionIdString forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfo]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         
         NSDictionary * entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:appServerJSONData
                                                                          options:0
                                                                            error:NULL];
         if (entitiesPropertyList) {
            
             User *user = [User userWithAppServerInfo:entitiesPropertyList inManagedObjectContext:[self managedObjectContext]];
             [document saveToURL:[document fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
         
             success(user);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
         failure(operation, error);
 
     }];
    
}


#pragma mark - Logout User RESTful


- (void)logutUserServerCallforSessionId:(NSString *)sessionId
                          success:(void (^)(id  responseObject)) success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *sessionIdString = [self sessionId];
    [manager.requestSerializer setValue:sessionIdString forHTTPHeaderField:@"SESSION"];
    
    [manager GET:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserLogout]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData) {
             
             FBSDKLoginManager *fbAuth = [[FBSDKLoginManager alloc] init];
             [fbAuth logOut];
             
             success(@"TRUE");
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         failure(operation, error);
         
     }];
    
}



@end












