//
//  BTRAccountInformationVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountInformationVC.h"

@interface BTRAccountInformationVC ()

@end

@implementation BTRAccountInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)genderTapped:(UIButton *)sender {


    //[self setPickerType:COUNTRY_PICKER];
    [self.pickerView reloadAllComponents];
    [self dismissKeyboard];
    //[self.viewForPicker setHidden:FALSE];
}



- (void)dismissKeyboard {
    
    
    [self.emailTextField resignFirstResponder];
    //[self.passwordTextField resignFirstResponder];
}



- (IBAction)updatePasswordTapped:(UIButton *)sender {
}

- (IBAction)updateInfoTapped:(UIButton *)sender {
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
