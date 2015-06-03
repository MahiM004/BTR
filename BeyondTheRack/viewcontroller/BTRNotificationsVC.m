//
//  BTRNotificationsVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRNotificationsVC.h"
#import "BTRUserFetcher.h"

@interface BTRNotificationsVC ()

@property (nonatomic, assign) BOOL pushNotifications;
@property (nonatomic, assign) BOOL womenreminders;
@property (nonatomic, assign) BOOL mensreminders;
@property (nonatomic, assign) BOOL childreminders;
@property (nonatomic, assign) BOOL homereminders;
@property (nonatomic, assign) enum btrEmailNotificationFrequency emailFrequency;
@property (nonatomic, assign) NSString *chosenEmailFrequencyString;

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation BTRNotificationsVC


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupDocument];

    
    [self setupPreferencesListAttributesforList:[[self user] preferencesList]];
    [self createVerticalList];
}


- (void)setupPreferencesListAttributesforList:(NSString *)preferencesList {
    
    if (![self user])
        return;
    
    if ([preferencesList containsString:@"MobilePush"])
        [[self pushNotificationSwitch] setOn:YES];
    
    if ([preferencesList containsString:@"womenreminders"])
        [[self womenSwitch] setOn:YES];
    
    if ([preferencesList containsString:@"mensreminders"])
        [[self menSwitch] setOn:YES];
          
    if ([preferencesList containsString:@"childreminders"])
        [[self childrenSwitch] setOn:YES];
    
    if ([preferencesList containsString:@"homereminders"])
        [[self homeSwitch] setOn:YES];
    
    if ([preferencesList containsString:@"dailyreminders"]) {
        
        if (![preferencesList containsString:@"oncedailyreminders"]) {

            [self setChosenEmailFrequencyString:@"dailyreminders"];
            [self setEmailFrequency:btrAllEmails];
            
        } else if ([preferencesList containsString:@"oncedailyreminders"]) {
            
            [self setChosenEmailFrequencyString:@"oncedailyreminders"];
            [self setEmailFrequency:btrDailyEmails];
        }
        
    } else if ([preferencesList containsString:@"threetimesweeklyreminders"]) {

        [self setChosenEmailFrequencyString:@"threetimesweeklyreminders"];
        [self setEmailFrequency:btrThreeTimesAWeekEmails];
    
    } else if ([preferencesList containsString:@"weeklyreminders"]) {

        [self setChosenEmailFrequencyString:@"weeklyreminders"];
        [self setEmailFrequency:btrWeeklyEmails];
    
    } else {
    
        [self setChosenEmailFrequencyString:@"-"];
        [self setEmailFrequency:btrNoEmails];
    }
}



- (void)createVerticalList {
    
    TNRectangularRadioButtonData *allEmailsData = [TNRectangularRadioButtonData new];
    allEmailsData.labelText = @"ALL";
    allEmailsData.identifier = @"dailyreminders";
    allEmailsData.selected = NO;
    if ([self emailFrequency]==btrAllEmails)
        allEmailsData.selected = YES;

    TNRectangularRadioButtonData *onceDayData = [TNRectangularRadioButtonData new];
    onceDayData.labelText = @"ONCE-A-DAY";
    onceDayData.identifier = @"oncedailyreminders";
    onceDayData.selected = NO;
    if ([self emailFrequency]==btrDailyEmails)
        onceDayData.selected = YES;
    
    TNRectangularRadioButtonData *threeTimesData = [TNRectangularRadioButtonData new];
    threeTimesData.labelText = @"3 TIMES A WEEK";
    threeTimesData.identifier = @"threetimesweeklyreminders";
    threeTimesData.selected = NO;
    if ([self emailFrequency]==btrThreeTimesAWeekEmails)
        threeTimesData.selected = YES;
    
    TNRectangularRadioButtonData *weeklyData = [TNRectangularRadioButtonData new];
    weeklyData.labelText = @"WEEKLY";
    weeklyData.identifier = @"weeklyreminders";
    weeklyData.selected = NO;
    if ([self emailFrequency]==btrWeeklyEmails)
        weeklyData.selected = YES;

    TNRectangularRadioButtonData *noneData = [TNRectangularRadioButtonData new];
    noneData.labelText = @"NONE";
    noneData.identifier = @"-";
    noneData.selected = NO;
    if ([self emailFrequency]==btrNoEmails)
        noneData.selected = YES;

    self.emailNotificationGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[allEmailsData, onceDayData, threeTimesData, weeklyData, noneData] layout:TNRadioButtonGroupLayoutVertical];
    self.emailNotificationGroup.identifier = @"email group";
    [self.emailNotificationGroup create];
    self.emailNotificationGroup.position = CGPointMake(10, 60);
    
    [self.radioView addSubview:self.emailNotificationGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emailGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:self.emailNotificationGroup];
    
    [self.emailNotificationGroup update];
}



- (IBAction)updatedTapped:(UIButton *)sender {

    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];

    BOOL oneChosen = FALSE;
    NSString *neuPreferencesList = @"";
    
    if (self.pushNotificationSwitch.on) {
        neuPreferencesList = [neuPreferencesList stringByAppendingString:@"MobilePush"];
        oneChosen = TRUE;
    }

    if (![self.chosenEmailFrequencyString isEqualToString:@"-"]) {
        
        if (oneChosen) neuPreferencesList = [neuPreferencesList stringByAppendingString:@","];
        neuPreferencesList = [neuPreferencesList stringByAppendingString:[self chosenEmailFrequencyString]];
        oneChosen = TRUE;
    }
    
    if (oneChosen) neuPreferencesList = [neuPreferencesList stringByAppendingString:@","];
    if (self.womenSwitch.on) {
        neuPreferencesList = [neuPreferencesList stringByAppendingString:@"womenreminders"];
        oneChosen = TRUE;
    }
    
    if (oneChosen) neuPreferencesList = [neuPreferencesList stringByAppendingString:@","];
    if (self.menSwitch.on) {
        neuPreferencesList = [neuPreferencesList stringByAppendingString:@"mensreminders"];
        oneChosen = TRUE;
    }
    
    if (oneChosen) neuPreferencesList = [neuPreferencesList stringByAppendingString:@","];
    if (self.childrenSwitch.on) {
        neuPreferencesList = [neuPreferencesList stringByAppendingString:@"childreminders"];
        oneChosen = TRUE;
    }
    
    if (oneChosen) neuPreferencesList = [neuPreferencesList stringByAppendingString:@","];
    if (self.homeSwitch.on) {
        neuPreferencesList = [neuPreferencesList stringByAppendingString:@"homereminders"];
        oneChosen = TRUE;
    }
    
    [self updateUserPreferencesListforSessionId:[sessionSettings sessionId] andPreferencesList:neuPreferencesList success:^(NSString *successString) {
        
        [self.user setPreferencesList:neuPreferencesList];
        [self.beyondTheRackDocument saveToURL:[self.beyondTheRackDocument fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        [self setupPreferencesListAttributesforList:neuPreferencesList];
        
        [self alertUserforSuccessfulUpdate];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


# pragma mark - User alerts


- (void)alertUserforSuccessfulUpdate {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful"
                                                    message:@"Your Preferences were updated successfully."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}


#pragma mark - User Info RESTful - Update Preferences List


- (void)setupDocument
{
    if (!self.managedObjectContext) {
        
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
}


- (void)updateUserPreferencesListforSessionId:(NSString *)sessionId
                           andPreferencesList:(NSString *)preferencesListString
                          success:(void (^)(id  responseObject)) success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    NSDictionary *params = (@{
                              @"preferences_list": preferencesListString
                              });
    
    [manager PUT:[NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfoDetail]]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id appServerJSONData)
     {
         success(@"TRUE");
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         failure(operation, error);
     }];
}


#pragma mark - Handle Notifications



- (void)emailGroupUpdated:(NSNotification *)notification {
    
    [self setChosenEmailFrequencyString:self.emailNotificationGroup.selectedRadioButton.data.identifier];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.emailNotificationGroup];
}





@end

























