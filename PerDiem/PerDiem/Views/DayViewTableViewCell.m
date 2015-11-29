//
//  DayViewTableViewCell.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/27/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "DayViewTableViewCell.h"
#import "UIColor+PerDiem.h"

@interface DayViewTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *progressBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *transactionsAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetsAmountLabel;
@end

@implementation DayViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTransactionList:(TransactionList *)transactionList {
    _transactionList = transactionList;
}

- (void)setBudgets:(NSArray<Budget *> *)budgets {
    _budgets = budgets;
    [self updateUI];
}

- (void)updateUI {
    self.transactionsAmountLabel.text = @"";
    self.budgetsAmountLabel.text = @"";
    
    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    [amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSInteger budgetsSum = 0;
    NSInteger transactionsSum = 0;
    
    if (self.budgets != nil) {
        for (Budget *budget in self.budgets) {
            budgetsSum = budgetsSum + [budget.amount integerValue];
        }
        NSString *budgetAmountString = [amountFormatter stringFromNumber:@(budgetsSum)];
        self.budgetsAmountLabel.text = [NSString stringWithFormat:@"%@ total", budgetAmountString];
    }

    if (self.transactionList != nil) {
        for (Transaction *transaction in self.transactionList.transactions) {
            transactionsSum = transactionsSum + [transaction.amount integerValue];
        }
        self.transactionsAmountLabel.text = [amountFormatter stringFromNumber:@(transactionsSum)];
    }
    
    NSInteger budgetUsedPercentage = 0;
    if (budgetsSum > 0) {
        budgetUsedPercentage = transactionsSum * 100 / budgetsSum;
    }
    
    self.progressBarView.backgroundColor = [UIColor colorWithBudgetProgress:budgetUsedPercentage alpha:.3];
    self.contentView.backgroundColor = [UIColor colorWithBudgetProgress:budgetUsedPercentage alpha:.1];
    self.widthConstraint.constant = budgetUsedPercentage * (self.frame.size.width / 100);
}

@end
