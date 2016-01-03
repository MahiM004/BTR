//
//  BTRHelpViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRHelpViewController.h"
#import "BTRFAQTableViewCell.h"
#import "BTRCheckoutViewController.h"
@interface BTRHelpViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faqBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopMargin;

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
    _headerView.backgroundColor= [BTRViewUtility BTRBlack];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([_getOriginalVCString isEqualToString:FROM_CHECKOUT]) {
        [_faqBtnHeight setConstant:0];
        [_lineTopMargin setConstant:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
        [_helpTable selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionTop];
        FAQ* faq = [self.faqArray objectAtIndex:indexPath.section];
        NSString* answerString = [[NSString alloc]init];
        QA* qa = [faq.questionsAndAnswers objectAtIndex:0];
        for (NSString* answer in qa.answer)
            answerString = [answerString stringByAppendingFormat:@"\n%@",answer];
        NSString* resultString = [NSString stringWithFormat:@"%@ \n %@",qa.question,answerString];
        
        BTRFAQTableViewCell* cell = (BTRFAQTableViewCell *)[self.helpTable cellForRowAtIndexPath:indexPath];
        cell.questionAndAnswerLabel.text = resultString;
        cell.questionAndAnswerLabel.font = [UIFont systemFontOfSize:12.0f];
        self.expandedIndexPath = indexPath;
        CGFloat decreaseForiPad;
        if ([BTRViewUtility isIPAD]) {
            decreaseForiPad = 140.0f;
        }
        self.heightOfSelectedCell = [self findHeightForText:resultString havingWidth:self.helpTable.frame.size.width andFont:[UIFont systemFontOfSize:12.0f]] -decreaseForiPad;
    }
}

- (IBAction)contactUS:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - FAQ TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return ((FAQ *)[self.faqArray objectAtIndex:section]).questionsAndAnswers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTRFAQTableViewCell* cell = (BTRFAQTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BTRFAQTableViewCellIdentifier"];
    FAQ* faq = [self.faqArray objectAtIndex:indexPath.section];
    QA* qa = [faq.questionsAndAnswers objectAtIndex:indexPath.row];
    cell.questionAndAnswerLabel.numberOfLines = -1;
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        FAQ* faq = [self.faqArray objectAtIndex:indexPath.section];
        NSString* answerString = [[NSString alloc]init];
        QA* qa = [faq.questionsAndAnswers objectAtIndex:indexPath.row];
        for (NSString* answer in qa.answer)
            answerString = [answerString stringByAppendingFormat:@"\n%@",answer];
        NSString* resultString = [NSString stringWithFormat:@"%@ \n %@",qa.question,answerString];
        cell.questionAndAnswerLabel.text = resultString;
        cell.questionAndAnswerLabel.font = [UIFont systemFontOfSize:12.0f];
    } else {
        cell.questionAndAnswerLabel.text = [NSString stringWithFormat:@"• %@",qa.question];
        cell.questionAndAnswerLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    }
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

    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
        cell.questionAndAnswerLabel.text = [NSString stringWithFormat:@"• %@",qa.question];
        cell.questionAndAnswerLabel.font = [UIFont boldSystemFontOfSize:13.0f];

    } else {
        if (self.expandedIndexPath) {
            BTRFAQTableViewCell* oldCell = (BTRFAQTableViewCell *)[self.helpTable cellForRowAtIndexPath:self.expandedIndexPath];
            oldCell.questionAndAnswerLabel.text = qa.question;
            oldCell.questionAndAnswerLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        }
        cell.questionAndAnswerLabel.text = [NSString stringWithFormat:@"• %@",qa.question];
        cell.questionAndAnswerLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        self.expandedIndexPath = indexPath;
        self.heightOfSelectedCell = [self findHeightForText:resultString havingWidth:self.helpTable.frame.size.width andFont:[UIFont systemFontOfSize:13.0f]];
        cell.questionAndAnswerLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.questionAndAnswerLabel.text = [NSString stringWithFormat:@"• %@",qa.question];
        [self crossFadeCurrentTextInView:cell.questionAndAnswerLabel withNewText:resultString duration:0.7];
    }
    [self.helpTable endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame)
        return self.heightOfSelectedCell;
    return 70.0; // Normal height
}

- (BOOL)crossFadeCurrentTextInView:(UIView *)view withNewText:(NSString *)text duration:(CGFloat)duration {
    if (!view) { return NO; }
    if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]]) {
        CATransition *animation = [CATransition animation];
        animation.duration        = duration;
        animation.type            = kCATransitionFade;
        animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [view.layer addAnimation:animation forKey:@"changeTextTransition"];
        
        if ([view isKindOfClass:[UILabel class]])
            ((UILabel *)view).text = text;
        else
            ((UITextField *)view).text = text;
        
        [view.layer performSelector:@selector(removeAnimationForKey:) withObject:@"changeTextTransition" afterDelay:duration]; // Remove animation.
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [header.textLabel setTextColor:[UIColor colorWithRed:78.0/255.0 green:47.0/255.0 blue:47.0/255.0 alpha:1]];
}
#pragma mark back

- (IBAction)backbuttonTapped:(id)sender {
    if ([_getOriginalVCString isEqualToString:FROM_CHECKOUT]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"BackButtonPressed"];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
@end
