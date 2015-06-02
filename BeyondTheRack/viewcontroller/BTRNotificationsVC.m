//
//  BTRNotificationsVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRNotificationsVC.h"

@interface BTRNotificationsVC ()

@property (nonatomic, assign) BOOL pushNotifications;
@property (nonatomic, assign) BOOL womenreminders;
@property (nonatomic, assign) BOOL mensreminders;
@property (nonatomic, assign) BOOL childreminders;
@property (nonatomic, assign) BOOL homereminders;
@property (nonatomic, assign) enum btrEmailNotificationFrequency emailFrequency;

@end

@implementation BTRNotificationsVC


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupPreferencesListAttributesforList:[[self user] preferencesList]];
    [self createVerticalList];
}


- (void)setupPreferencesListAttributesforList:(NSString *)preferencesList {
    
    if (![self user])
        return;
    
    if ([preferencesList containsString:@"partners"])
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

            [self setEmailFrequency:btrAllEmails];
            
        } else if ([preferencesList containsString:@"oncedailyreminders"]) {
            
            [self setEmailFrequency:btrDailyEmails];
        }
        
    } else if ([preferencesList containsString:@"threetimesweeklyreminders"]) {
        
        [self setEmailFrequency:btrThreeTimesAWeekEmails];
    
    } else if ([preferencesList containsString:@"weeklyreminders"]) {
    
        [self setEmailFrequency:btrWeeklyEmails];
    
    } else {
    
        [self setEmailFrequency:btrNoEmails];
    }
    
}



- (void)createVerticalList {
    
    TNRectangularRadioButtonData *allEmailsData = [TNRectangularRadioButtonData new];
    allEmailsData.labelText = @"ALL";
    allEmailsData.identifier = @"all";
    allEmailsData.selected = NO;
    if ([self emailFrequency]==btrAllEmails)
        allEmailsData.selected = YES;

    TNRectangularRadioButtonData *onceDayData = [TNRectangularRadioButtonData new];
    onceDayData.labelText = @"ONCE-A-DAY";
    onceDayData.identifier = @"onceaday";
    onceDayData.selected = NO;
    if ([self emailFrequency]==btrDailyEmails)
        onceDayData.selected = YES;
    
    TNRectangularRadioButtonData *threeTimesData = [TNRectangularRadioButtonData new];
    threeTimesData.labelText = @"3 TIMES A WEEK";
    threeTimesData.identifier = @"threetimesaweek";
    threeTimesData.selected = NO;
    if ([self emailFrequency]==btrThreeTimesAWeekEmails)
        threeTimesData.selected = YES;
    
    TNRectangularRadioButtonData *weeklyData = [TNRectangularRadioButtonData new];
    weeklyData.labelText = @"WEEKLY";
    weeklyData.identifier = @"weekly";
    weeklyData.selected = NO;
    if ([self emailFrequency]==btrWeeklyEmails)
        weeklyData.selected = YES;

    TNRectangularRadioButtonData *noneData = [TNRectangularRadioButtonData new];
    noneData.labelText = @"NONE";
    noneData.identifier = @"none";
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



- (void)emailGroupUpdated:(NSNotification *)notification {
    NSLog(@"[MainView] Email group updated to %@", self.emailNotificationGroup.selectedRadioButton.data.identifier);
}


- (void)dealloc {
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.emailNotificationGroup];
}


- (IBAction)updatedTapped:(UIButton *)sender {
    
}







@end






























