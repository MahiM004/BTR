//
//  BTRHelpViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRHelpViewController.h"
#import "BTRFAQTableViewCell.h"

@interface BTRHelpViewController ()
@property NSIndexPath *expandedIndexPath;
@property CGFloat heightOfSelectedCell;
@end

@implementation BTRHelpViewController

- (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGFloat result = (font.pointSize + 4 ) * 6;
    if (text) {
        CGSize size;
        
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue - 60, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 10);
        result = MAX(size.height , result); //At five row
        if (result > 500) {
            result -= 400;
        }
    }
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FAQ TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return ((FAQ *)[self.faqArray objectAtIndex:section]).questionsAndAnswers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTRFAQTableViewCell* cell = (BTRFAQTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BTRFAQTableViewCellIdentifier"];
    FAQ* faq = [self.faqArray objectAtIndex:indexPath.section];
    QA* qa = [faq.questionsAndAnswers objectAtIndex:indexPath.row];
    cell.questionAndAnswerLabel.text = qa.question;
    cell.questionAndAnswerLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    cell.questionAndAnswerLabel.numberOfLines = -1;
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.faqArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    FAQ* faq = [self.faqArray objectAtIndex:section];
    return faq.faqCategory;
}

#pragma mark - FAQ TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.helpTable beginUpdates]; // tell the table you're about to start making changes
    
    BTRFAQTableViewCell* cell = (BTRFAQTableViewCell *)[self.helpTable cellForRowAtIndexPath:indexPath];
    FAQ* faq = [self.faqArray objectAtIndex:indexPath.section];
    NSString* answerString = [[NSString alloc]init];
    QA* qa = [faq.questionsAndAnswers objectAtIndex:indexPath.row];
    for (NSString* answer in qa.answer)
        answerString = [answerString stringByAppendingFormat:@"\n%@",answer];
    NSString* resultString = [NSString stringWithFormat:@"%@ \n %@",qa.question,answerString];

    // If the index path of the currently expanded cell is the same as the index that
    // has just been tapped set the expanded index to nil so that there aren't any
    // expanded cells, otherwise, set the expanded index to the index that has just
    // been selected.
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        cell.questionAndAnswerLabel.text = qa.question;
        cell.questionAndAnswerLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.expandedIndexPath = nil;
    } else {
        
        self.expandedIndexPath = indexPath;
        self.heightOfSelectedCell = [self findHeightForText:resultString havingWidth:self.helpTable.frame.size.width andFont:[UIFont systemFontOfSize:13.0f]];
        cell.questionAndAnswerLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.questionAndAnswerLabel.text = resultString;
    }
    
    [self.helpTable endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return self.heightOfSelectedCell;
        
    }
    return 70.0; // Normal height
}

@end
