//
//  BTRSearchFilterTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchFilterTVC.h"


@interface BTRSearchFilterTVC ()

@end

@implementation BTRSearchFilterTVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    self.sliderView.backgroundColor = [UIColor clearColor];
    NSUInteger margin = 20;
    CGRect sliderFrame = CGRectMake(margin, margin, self.view.frame.size.width - margin * 2, 30);
    _rangeSlider = [[CERangeSlider alloc] initWithFrame:sliderFrame];
    
    [self.sliderView addSubview:_rangeSlider];
    
    [_rangeSlider addTarget:self
                     action:@selector(slideValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    [self performSelector:@selector(updateState) withObject:nil afterDelay:1.0f];
    */
    
    
    slider = [[RangeSlider alloc] initWithFrame:CGRectMake(10, 100, 300, 30)]; // the slider enforces a height of 30, although I'm not sure that this is necessary
    
    slider.minimumRangeLength = .03; // this property enforces a minimum range size. By default it is set to 0.0
    
    [slider setMinThumbImage:[UIImage imageNamed:@"rangethumb.png"]]; // the two thumb controls are given custom images
    [slider setMaxThumbImage:[UIImage imageNamed:@"rangethumb.png"]];
    
    
    UIImage *image; // there are two track images, one for the range "track", and one for the filled in region of the track between the slider thumbs
    
    [slider setTrackImage:[[UIImage imageNamed:@"fullrange.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)]];
    
    image = [UIImage imageNamed:@"fillrangeblue.png"];
    [slider setInRangeTrackImage:image];
    
    
    [slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged]; // The slider sends actions when the value of the minimum or maximum changes
    
    
    reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 310, 30)]; // a label to see the values of the slider in this demo
    reportLabel.adjustsFontSizeToFitWidth = YES;
    reportLabel.textAlignment = NSTextAlignmentCenter;
    [self.sliderView addSubview:reportLabel];
    NSString *report = [NSString stringWithFormat:@"current slider range is %f to %f", slider.min, slider.max];
    reportLabel.text = report;
    
    [self.sliderView addSubview:slider];
    
}



- (void)slideValueChanged:(RangeSlider *)sender {

    NSString *report = [NSString stringWithFormat:@"current slider range is %f to %f", sender.min, sender.max];
    reportLabel.text = report;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end










