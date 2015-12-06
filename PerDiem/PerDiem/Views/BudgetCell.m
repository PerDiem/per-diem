//
//  BudgetCell.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "BudgetCell.h"
#import "TransactionList.h"
#import "Budget.h"
#import <M13ProgressSuite/M13ProgressViewBorderedBar.h>

@interface BudgetCell ()

@property (weak, nonatomic) IBOutlet UILabel *budgetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountSpentBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountBadgetLabel;
@property (weak, nonatomic) IBOutlet UIView *charView;
@property (strong, nonatomic) NSNumberFormatter *amountFormatter;

@end

@implementation BudgetCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setBudget:(Budget *)budget {
    _budget = budget;

    self.budgetNameLabel.text = budget.name;

    self.amountBadgetLabel.text = [self.amountFormatter stringFromNumber:budget.amount];
    M13ProgressViewBorderedBar *progress = [[M13ProgressViewBorderedBar alloc] initWithFrame: CGRectMake(0, 0, 300, 20)];
    progress.cornerType = M13ProgressViewBorderedBarCornerTypeCircle;
    progress.progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;

    progress.translatesAutoresizingMaskIntoConstraints = NO;
    [self.charView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.charView removeConstraints:self.charView.constraints];
    [self.charView addSubview:progress];
    NSDictionary *views = NSDictionaryOfVariableBindings(progress);
    [self.charView addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|[progress]|"
                                   options:0
                                   metrics:nil
                                   views:views]];
    [self.charView addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|[progress(20)]|"
                                   options:0
                                   metrics:nil
                                   views:views]];


    if (budget.transactionList) {
        self.amountSpentBudgetLabel.text = [self.amountFormatter stringFromNumber:budget.transactionList.sum];
        if (budget.transactionList.sum > budget.amount) {
            [progress performAction:M13ProgressViewActionFailure animated:NO];
            [progress setProgress:1 animated:YES];
        } else {
            [progress performAction:M13ProgressViewActionSuccess animated:NO];

            float spent = [budget.transactionList.sum floatValue] / [budget.amount floatValue];
            [progress setProgress:spent animated:YES];
        }

    } else {
        self.amountSpentBudgetLabel.text = [self.amountFormatter stringFromNumber:@(0)];
    }
}

- (NSNumberFormatter *)amountFormatter {
    if (!_amountFormatter) {
        _amountFormatter = [[NSNumberFormatter alloc] init];
        [_amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    return _amountFormatter;
}

@end
