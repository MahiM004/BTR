//
//  BTRNotificationsVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRNotificationsVC.h"
#import "BTRUserFetcher.h"
#import "BTRConnectionHelper.h"

@interface BTRNotificationsVC ()
@property IBOutlet UIView * view1 ;
@property IBOutlet UIView * view3 ;

@property (nonatomic, assign) BOOL pushNotifications;
@property (nonatomic, assign) BOOL womenreminders;
@property (nonatomic, assign) BOOL mensreminders;
@property (nonatomic, assign) BOOL childreminders;
@property (nonatomic, assign) BOOL homereminders;
@property (nonatomic, assign) enum btrEmailNotificationFrequency emailFrequency;
@property (nonatomic, assign) NSString *chosenEmailFrequencyString;

@end

@implementation BTRNotificationsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    _view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view1.layer.borderWidth = 0.8;
    _radioView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _radioView.layer.borderWidth = 0.8;
    _view3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _view3.layer.borderWidth = 0.8;
    [self setupPreferencesListAttributesforList:[[self user] preferencesList]];
    [self createVerticalList];
}

- (void)setupPreferencesListAttributesforList:(NSString *)preferencesList {
    if (![self user])
        return;
    if ([preferencesList rangeOfString:@"MobilePush"].location != NSNotFound)
        [[self pushNotificationSwitch] setOn:YES];
    
    if ([preferencesList rangeOfString:@"womenreminders"].location != NSNotFound)
        [[self womenSwitch] setOn:YES];
    
    if ([preferencesList rangeOfString:@"mensreminders"].location != NSNotFound)
        [[self menSwitch] setOn:YES];
          
    if ([preferencesList rangeOfString:@"childreminders"].location != NSNotFound)
        [[self childrenSwitch] setOn:YES];
    
    if ([preferencesList rangeOfString:@"homereminders"].location != NSNotFound)
        [[self homeSwitch] setOn:YES];
    
    if ([preferencesList rangeOfString:@"dailyreminders"].location != NSNotFound) {
        // Please check the condition is correct or not
        if (![preferencesList rangeOfString:@"oncedailyreminders"].location != NSNotFound) {
            [self setChosenEmailFrequencyString:@"dailyreminders"];
            [self setEmailFrequency:btrAllEmails];
            
        } else if ([preferencesList rangeOfString:@"oncedailyreminders"].location != NSNotFound) {
            [self setChosenEmailFrequencyString:@"oncedailyreminders"];
            [self setEmailFrequency:btrDailyEmails];
        }
        
    } else if ([preferencesList rangeOfString:@"threetimesweeklyreminders"].location != NSNotFound) {
        [self setChosenEmailFrequencyString:@"threetimesweeklyreminders"];
        [self setEmailFrequency:btrThreeTimesAWeekEmails];
    
    } else if ([preferencesList rangeOfString:@"weeklyreminders"].location != NSNotFound) {
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
    if ([BTRViewUtility isIPAD]) {
        self.emailNotificationGroup.position = CGPointMake(10, 70);
    } else {
        self.emailNotificationGroup.position = CGPointMake(10, 60);
    }
    [self.radioView addSubview:self.emailNotificationGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emailGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:self.emailNotificationGroup];
    
    [self.emailNotificationGroup update];
}

- (IBAction)updatedTapped:(UIButton *)sender {
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
    }
    [self updateUserPreferencesList:neuPreferencesList success:^(NSString *successString) {
        [self.user setPreferencesList:neuPreferencesList];
        [self setupPreferencesListAttributesforList:neuPreferencesList];
        [self alertUserforSuccessfulUpdate];
    } failure:^(NSError *error) {
        
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

- (void)updateUserPreferencesList:(NSString *)preferencesListString
                          success:(void (^)(id  responseObject)) success
                          failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRUserFetcher URLforUserInfoDetail]];
    NSDictionary *params = (@{
                              @"preferences_list": preferencesListString
                              });
    [BTRConnectionHelper putDataFromURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(@"TRUE");
    } faild:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Handle Notifications

- (void)emailGroupUpdated:(NSNotification *)notification {
    [self setChosenEmailFrequencyString:self.emailNotificationGroup.selectedRadioButton.data.identifier];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.emailNotificationGroup];
}


#pragma mark back

- (IBAction)backbuttonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

























