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
        [self setEmailFrequency:btrAllEmails];
    } else if ([preferencesList containsString:@"oncedailyreminders"]) {
        [self setEmailFrequency:btrDailyEmails];
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
    
    
    TNRectangularRadioButtonData *onceDayData = [TNRectangularRadioButtonData new];
    onceDayData.labelText = @"ONCE-A-DAY";
    onceDayData.identifier = @"onceaday";
    onceDayData.selected = YES;
    onceDayData.borderColor = [UIColor blackColor];
    onceDayData.rectangleColor = [UIColor blackColor];
    onceDayData.borderWidth = onceDayData.borderHeight = 12;
    onceDayData.rectangleWidth = onceDayData.rectangleHeight = 5;
    
    TNRectangularRadioButtonData *threeTimesData = [TNRectangularRadioButtonData new];
    threeTimesData.labelText = @"3 TIMES A WEEK";
    threeTimesData.identifier = @"threetimesaweek";
    threeTimesData.selected = NO;
    threeTimesData.borderColor = [UIColor blackColor];
    threeTimesData.rectangleColor = [UIColor blackColor];
    threeTimesData.borderWidth = threeTimesData.borderHeight = 12;
    threeTimesData.rectangleWidth = threeTimesData.rectangleHeight = 5;
    threeTimesData.borderColor = [UIColor blackColor];
    threeTimesData.rectangleColor = [UIColor blackColor];
    
    TNRectangularRadioButtonData *weeklyData = [TNRectangularRadioButtonData new];
    weeklyData.labelText = @"WEEKLY";
    weeklyData.identifier = @"weekly";
    weeklyData.selected = NO;
    weeklyData.borderColor = [UIColor blackColor];
    weeklyData.rectangleColor = [UIColor blackColor];
    weeklyData.borderWidth = threeTimesData.borderHeight = 12;
    weeklyData.rectangleWidth = threeTimesData.rectangleHeight = 5;
    weeklyData.borderColor = [UIColor blackColor];
    weeklyData.rectangleColor = [UIColor blackColor];
    
    TNRectangularRadioButtonData *noneData = [TNRectangularRadioButtonData new];
    noneData.labelText = @"NONE";
    noneData.identifier = @"none";
    noneData.selected = NO;
    noneData.borderColor = [UIColor blackColor];
    noneData.rectangleColor = [UIColor blackColor];
    noneData.borderWidth = threeTimesData.borderHeight = 12;
    noneData.rectangleWidth = threeTimesData.rectangleHeight = 5;
    noneData.borderColor = [UIColor blackColor];
    noneData.rectangleColor = [UIColor blackColor];
    
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






























