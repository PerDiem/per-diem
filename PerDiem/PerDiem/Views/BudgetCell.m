//
//  BudgetCell.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BudgetCell.h"
#import "TransactionList.h"
#import "Budget.h"
#import "UIColor+PerDiem.h"

@interface BudgetCell ()

@property (weak, nonatomic) IBOutlet UILabel *budgetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountSpentBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountBadgetLabel;
@property (strong, nonatomic) NSNumberFormatter *amountFormatter;
@property (weak, nonatomic) IBOutlet UIView *progressBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIView *progressBarBackgroundView;
@property (assign, nonatomic) float percentage;

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
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

    self.percentage = 0;
    if (budget.transactionList) {
        self.amountSpentBudgetLabel.text = [self.amountFormatter stringFromNumber:budget.transactionList.sum];

        self.percentage = MIN(100, [budget.transactionList.sum floatValue] / [budget.amount floatValue] * 100);
    } else {
        self.amountSpentBudgetLabel.text = [self.amountFormatter stringFromNumber:@(0)];
    }
    self.mainContentView.backgroundColor = [UIColor backgroundColor];
    self.progressBarBackgroundView.backgroundColor = [UIColor colorWithProgress:self.percentage alpha:.4];
    self.progressBarView.backgroundColor = [UIColor colorWithProgress:self.percentage alpha:1];
    [self.progressBarBackgroundView.layer setCornerRadius:5.0f];
    [self.progressBarBackgroundView.layer setMasksToBounds:YES];

//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.widthConstraint.constant = self.percentage / 100.0 * self.mainContentView.frame.size.width;
}
- (NSNumberFormatter *)amountFormatter {
    if (!_amountFormatter) {
        _amountFormatter = [[NSNumberFormatter alloc] init];
        [_amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    return _amountFormatter;
}

@end
