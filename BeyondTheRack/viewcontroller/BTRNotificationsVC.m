//
//  BTRNotificationsVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRNotificationsVC.h"

@interface BTRNotificationsVC ()

@end

@implementation BTRNotificationsVC


- (void)viewDidLoad {
    [super viewDidLoad];

    
    //[self createHorizontalList];
    [self createVerticalList];
    //[self createHorizontalListWithImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
